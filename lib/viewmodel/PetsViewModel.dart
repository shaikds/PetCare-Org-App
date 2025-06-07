import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:string_similarity/string_similarity.dart';

import '../model/Pet.dart';
import '../model/embedding_repo.dart';

class PetViewModel extends ChangeNotifier {
  final CollectionReference _petsCollection =
      FirebaseFirestore.instance.collection('pets');
  final _storage = FirebaseStorage.instance;
  // For Android emulator, use default (10.0.2.2)
  // final EmbeddingRepo _embeddingRepo = EmbeddingRepo();
  // For physical device, use your computer's LAN IP:
  final EmbeddingRepo _embeddingRepo = EmbeddingRepo(host: '192.168.1.16');

  List<Pet> _pets = [];
  List<String> photos = [];
  List<Pet> filteredPets = [];
  bool _isLoading = false;

  List<Pet> get pets => _pets.toList();

  bool get isLoading => _isLoading;

  Future<void> createPet(Pet pet) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Get description embedding
      List<double>? descEmbedding;
      List<double>? imgEmbedding;

      try {
        descEmbedding = await _embeddingRepo.getTextEmbedding(pet.description);
        if (pet.photos.isNotEmpty) {
          imgEmbedding = await _embeddingRepo.getImageEmbedding(pet.photos[0]);
        }
      } catch (e) {
        print('Error getting embeddings: $e');
        // Continue without embeddings
      }

      final petData = pet.toJson();
      if (descEmbedding != null) petData['descEmbedding'] = descEmbedding;
      if (imgEmbedding != null) petData['imgEmbedding'] = imgEmbedding;

      await _petsCollection.add(petData);
      await _fetchPets();
    } catch (e) {
      print('Error creating pet: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> readPets() async {
    await _fetchPets();
  }

  Future<void> _fetchPets() async {
    try {
      _isLoading = true;
      // notifyListeners();

      final querySnapshot = await _petsCollection.get();
      _pets = querySnapshot.docs.map((doc) => Pet.fromJson(doc)).toList();
    } catch (e) {
      print('Error fetching pets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePet(String uid, Pet pet) async {
    try {
      final updateData = pet.toJson();
      updateData.removeWhere((key, value) => value == null);
      await _petsCollection.doc(uid).update(updateData);

      // Update the list of pets after updating the pet
      await _fetchPets();
    } catch (e) {
      // Handle any errors during pet update
      print('Error updating pet: $e');
    }
  }

  Future<void> deletePet(String petId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _petsCollection.doc(petId).delete();
      await _fetchPets();
    } catch (e) {
      print('Error deleting pet: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadImageToStorage(List<File> imageFiles, Pet pet) async {
    try {
      _isLoading = true;
      notifyListeners();

      final String petName = pet.name + pet.age.toString();

      // Get image embedding for the first local file BEFORE upload
      try {
        if (imageFiles.isNotEmpty) {
          pet.imgEmbedding = await _embeddingRepo.getImageEmbedding(imageFiles[0].path);
        }
      } catch (e) {
        print('Error getting image embedding: $e');
      }

      for (File file in imageFiles) {
        String storagePath =
            'pet/$petName/${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageReference = _storage.ref().child(storagePath);
        TaskSnapshot snapshot = await storageReference.putFile(file);
        String downloadURL = await snapshot.ref.getDownloadURL();
        pet.photos.add(downloadURL);
        photos.add(downloadURL);
      }

      await createPet(pet);
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Pet>> findTopMatchesByImage(
    List<Pet> pets,
    String userImagePath,
    int topN,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final userEmbedding =
          await _embeddingRepo.getImageEmbedding(userImagePath);

      // Filter pets with valid image embeddings
      final petsWithEmbeddings = pets
          .where(
              (pet) => pet.imgEmbedding != null && pet.imgEmbedding!.isNotEmpty)
          .toList();

      if (petsWithEmbeddings.isEmpty) {
        return [];
      }

      final scoredPets = petsWithEmbeddings.map((pet) {
        final similarity = cosineSimilarity(userEmbedding, pet.imgEmbedding!);
        return {'pet': pet, 'similarity': similarity};
      }).toList();

      scoredPets.sort((a, b) =>
          (b['similarity'] as double).compareTo(a['similarity'] as double));

      filteredPets =
          scoredPets.take(topN).map((entry) => entry['pet'] as Pet).toList();
      return filteredPets;
    } catch (e) {
      print('Error finding image matches: $e');
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Pet>> findTopMatches(
    List<Pet> pets,
    bool isMale,
    bool isFemale,
    int maxAge,
    int minEnergyLevel,
    String userDescription, {
    int topN = 3,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      var gender = isMale
          ? 'זכר'
          : isFemale
              ? 'נקבה'
              : null;
      // Debug print all pets and their attributes
      print('All pets:');
      for (var pet in pets) {
        print(
            'Name: \\${pet.name} | Gender: \\${pet.gender} | Age: \\${pet.age} | Energy: \\${pet.energyLevel}');
      }

      // Filter by basic attributes first
      final filteredByAttributes = gender == null
          ? pets
              .where((pet) =>
                  pet.age / 2 <= maxAge && pet.energyLevel >= minEnergyLevel)
              .toList()
          : pets
              .where((pet) =>
                  pet.gender.contains(gender.toString()) &&
                  pet.age / 2 <= maxAge &&
                  pet.energyLevel >= minEnergyLevel)
              .toList();

      print('Filtered by attributes: \\${filteredByAttributes.length} pets');

      if (userDescription.trim().isEmpty) {
        filteredPets = filteredByAttributes.take(topN).toList();
        print('No description provided, returning attribute-filtered pets');
        return filteredPets;
      }

      List<Map<String, dynamic>> scoredPets = [];

      try {
        // Try embedding-based search first
        final userEmbedding =
            await _embeddingRepo.getTextEmbedding(userDescription);

        scoredPets = filteredByAttributes
            .where((pet) =>
                pet.descEmbedding != null && pet.descEmbedding!.isNotEmpty)
            .map((pet) {
          final similarity =
              cosineSimilarity(userEmbedding, pet.descEmbedding!);
          return {'pet': pet, 'similarity': similarity};
        }).toList();

        print('Embedding-based scored pets: \\${scoredPets.length}');
      } catch (e) {
        print('Embedding search failed, falling back to description score: $e');
      }

      // If embedding search failed or found no results, fall back to description score
      if (scoredPets.isEmpty) {
        print('Falling back to description score');
        scoredPets = filteredByAttributes.map((pet) {
          final similarity =
              _calculateDescriptionScore(pet.description, userDescription);
          return {'pet': pet, 'similarity': similarity};
        }).toList();
      }

      scoredPets.sort(
          (a, b) => (b['similarity'] as num).compareTo(a['similarity'] as num));

      filteredPets =
          scoredPets.take(topN).map((entry) => entry['pet'] as Pet).toList();

      print('Returning \\${filteredPets.length} pets');

      // if (filteredPets.isEmpty){ // Fallback handling, again
      //   return findTopMatchesFallBack(pets, isMale, isFemale, maxAge, minEnergyLevel, userDescription);
      // }
      return filteredPets;
    } catch (e) {
      print('Error finding matches: $e');
      return [];
    } finally {

      _isLoading = false;
      notifyListeners();
    }
  }

  double cosineSimilarity(List<double> a, List<double> b) {
    if (a.isEmpty || b.isEmpty || a.length != b.length) return 0.0;

    double dot = 0, normA = 0, normB = 0;
    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }

    if (normA == 0 || normB == 0) return 0.0;
    return dot / (sqrt(normA) * sqrt(normB));
  }

  // Method to calculate the description score between two strings
  int _calculateLevenshteinDistance(String a, String b) {
    if (a.isEmpty || b.isEmpty) return a.length + b.length;

    List<int> previousRow = List.generate(b.length + 1, (i) => i);
    List<int> currentRow = List<int>.filled(b.length + 1, 0);

    for (int i = 1; i <= a.length; i++) {
      currentRow[0] = i;

      for (int j = 1; j <= b.length; j++) {
        int insertCost = currentRow[j - 1] + 1;
        int deleteCost = previousRow[j] + 1;
        int replaceCost = previousRow[j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1);

        currentRow[j] = [insertCost, deleteCost, replaceCost]
            .reduce((minValue, value) => minValue > value ? value : minValue);
      }

      // Swap the rows
      List<int> temp = previousRow;
      previousRow = currentRow;
      currentRow = temp;
    }

    return previousRow[b.length];
  }

  // Method to calculate the description score between two strings
  int _calculateDescriptionScore(
      String petDescription, String userDescription) {
    // Calculate the Levenshtein distance between the two descriptions
    int distance = _calculateLevenshteinDistance(
        petDescription.toLowerCase(), userDescription.toLowerCase());

    // Calculate the similarity as the inverse of the distance (higher values indicate better matches)
    double similarity = 1 - (distance / petDescription.length);

    // Convert the similarity score to a percentage (0 to 100)
    int score = (similarity * 100).round();

    // Return the score
    return score;
  }

  Future<void> embedAllPets() async {
    try {
      print('Starting embedding process...');
      final pets = await FirebaseFirestore.instance.collection('pets').get();
      print('Found ${pets.docs.length} pets to process');

      for (final doc in pets.docs) {
        print('\nProcessing pet ${doc.id}...');
        final data = doc.data();
        final desc = data['description'] ?? '';
        final photos = List<String>.from(data['photos'] ?? []);
        String? mainPhotoPath;

        if (photos.isNotEmpty) {
          try {
            final url = photos.first;
            print('Downloading image from: $url');
            final tempDir = Directory.systemTemp;
            final tempFile = File('${tempDir.path}/${doc.id}_main.jpg');
            final response = await http.get(Uri.parse(url));

            if (response.statusCode == 200) {
              await tempFile.writeAsBytes(response.bodyBytes);
              mainPhotoPath = tempFile.path;
              print('Successfully downloaded image to: $mainPhotoPath');
            } else {
              print(
                  'Failed to download image for pet ${doc.id}: HTTP ${response.statusCode}');
              print('Response body: ${response.body}');
            }
          } catch (e, stackTrace) {
            print('Failed to download image for pet ${doc.id}:');
            print('Error: $e');
            print('Stack trace: $stackTrace');
          }
        }

        try {
          List<double>? descEmbedding;
          List<double>? imgEmbedding;

          if (desc.isNotEmpty) {
            print('Getting text embedding for description...');
            try {
              descEmbedding = await _embeddingRepo.getTextEmbedding(desc);
              print('Successfully got text embedding');
            } catch (e) {
              print('Text embedding failed: $e');
            }
          }

          if (mainPhotoPath != null && File(mainPhotoPath).existsSync()) {
            print('Getting image embedding...');
            try {
              imgEmbedding =
                  await _embeddingRepo.getImageEmbedding(mainPhotoPath);
              print('Successfully got image embedding');
            } catch (e) {
              print('Image embedding failed: $e');
            }
          }

          if (descEmbedding != null || imgEmbedding != null) {
            await doc.reference.update({
              if (descEmbedding != null) 'descEmbedding': descEmbedding,
              if (imgEmbedding != null) 'imgEmbedding': imgEmbedding,
            });
            print('Successfully updated pet ${doc.id} with embeddings');
          }
        } catch (e, stackTrace) {
          print('Failed to process embeddings for pet ${doc.id}:');
          print('Error: $e');
          print('Stack trace: $stackTrace');
        }
      }
      print('\nAll pets processed!');
    } catch (e, stackTrace) {
      print('Fatal error in embedAllPets:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<List<Pet>> getTopPet(
    List<Pet> pets,
    bool isMale,
    bool isFemale,
    int maxAge,
    int minEnergyLevel,
    String userDescription, {
    int topN = 3,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      var gender = isMale
          ? 'זכר'
          : isFemale
              ? 'נקבה'
              : null;

      // Use the same filtering logic as findTopMatches
      final filteredByAttributes = gender == null
          ? pets
              .where((pet) =>
                  pet.age / 2 <= maxAge && pet.energyLevel >= minEnergyLevel)
              .toList()
          : pets
              .where((pet) =>
                  pet.gender.contains(gender.toString()) &&
                  pet.age / 2 <= maxAge &&
                  pet.energyLevel >= minEnergyLevel)
              .toList();

      print('All pets:');
      for (var pet in pets) {
        print('Name: \\${pet.name} | Gender: \\${pet.gender} | Age: \\${pet.age} | Energy: \\${pet.energyLevel}');
      }
      print('Filtered by attributes: \\${filteredByAttributes.length} pets');

      if (userDescription.trim().isEmpty) {
        filteredPets = filteredByAttributes.take(topN).toList();
        print('No description provided, returning attribute-filtered pets');
        return filteredPets;
      }

      List<Map<String, dynamic>> scoredPets = [];

      // Get the user description embedding
      final userEmbedding = await _embeddingRepo.getTextEmbedding(userDescription);

      // Compare user description embedding to pet image embeddings
      scoredPets = filteredByAttributes
          .where((pet) => pet.imgEmbedding != null && pet.imgEmbedding!.isNotEmpty)
          .map((pet) {
        final similarity = cosineSimilarity(userEmbedding, pet.imgEmbedding!);
        return {'pet': pet, 'similarity': similarity};
      }).toList();
      print('Semantic (desc->img) scored pets: \\${scoredPets.length}');

      scoredPets.sort((a, b) => (b['similarity'] as num).compareTo(a['similarity'] as num));
      filteredPets = scoredPets.take(topN).map((entry) => entry['pet'] as Pet).toList();

      print('Returning \\${filteredPets.length} pets');
      return filteredPets;
    } catch (e) {
      print('Error finding matches: $e');
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  Future<List<Pet>> findTopMatchesFallBack(List<Pet> pets, bool isMale, bool isFemale,
      int maxAge, int minEnergyLevel, String userDescription) async {
    // Filter the pets based on user preferences
    int score = 0;
    filteredPets = await pets.where((pet) {
      if (!isMale && isFemale) {
        if (isMale && !pet.gender.contains('זכר')) return false;
        if (isFemale && !pet.gender.contains('נקבה')) return false;
      }
      if (pet.age > maxAge) return false;
      if (pet.energyLevel < minEnergyLevel) return false;

      // Calculate a score for the pet based on the description matching
      // Only if the user has entered a description
      if (userDescription.isNotEmpty) {
        var similarityTo = userDescription.similarityTo(pet.description);
        print(similarityTo);
        int descriptionScore =
        _calculateDescriptionScore(pet.description, userDescription);
        if (descriptionScore <= 0) return false;
      }
      return true;
    }).toList();

    // Sort the filtered pets based on some criteria (e.g., energy level, age, etc.).
    // In this example, we're sorting by energy level in descending order and description score in descending order.
    filteredPets.sort((a, b) {
      int energyLevelComparison = b.energyLevel.compareTo(a.energyLevel);
      int ageComparison = b.age.compareTo(a.age);
      if (energyLevelComparison < 0) {
        return energyLevelComparison;
      } else if (ageComparison < 0) {
        return ageComparison;
      } else {
        return b.descriptionScore.compareTo(a.descriptionScore);
      }
    });

    // Get the top 3 matches (or fewer if there are not enough matches)
    List<Pet> topMatches = filteredPets.take(2).toList();
    print(topMatches);
    return topMatches;
  }

}


