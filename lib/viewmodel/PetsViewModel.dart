import 'dart:io';
import  'package:string_similarity/string_similarity.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_login/model/Pet.dart';
import 'package:image_picker/image_picker.dart'; // Import the Pet model class

class PetViewModel extends ChangeNotifier {
  final CollectionReference _petsCollection =
      FirebaseFirestore.instance.collection('pets');
  final _storage = FirebaseStorage.instance;

  List<Pet> _pets = []; // List to store fetched pets
  List<String> photos = [];
  List<Pet> filteredPets = [];

  List<Pet> get pets => _pets.toList(); // Getter for the list of pets

  // Method to create a new pet
  Future<void> createPet(Pet pet) async {
    try {
      pet.photos = photos;
      await _petsCollection.add(pet.toJson());
      // Update the list of pets after adding a new pet
      await _fetchPets();
    } catch (e) {
      // Handle any errors during pet creation
      print('Error creating pet: $e');
    }
  }

  // Method to read (fetch) all pets from the database
  Future<void> readPets() async {
    await _fetchPets();
  }

  // Method to update an existing pet
  Future<void> updatePet(String uid, Pet pet) async {
    try {
      await _petsCollection.doc(uid).update(pet.toJson());

      // Update the list of pets after updating the pet
      await _fetchPets();
    } catch (e) {
      // Handle any errors during pet update
      print('Error updating pet: $e');
    }
  }

  // Method to delete a pet by its ID
  Future<void> deletePet(String petId) async {
    try {
      await _petsCollection.doc(petId).delete();
      // Update the list of pets after deleting the pet
      await _fetchPets();
    } catch (e) {
      // Handle any errors during pet deletion
      print('Error deleting pet: $e');
    }
  }

  //upload pet image to firebase storage
  Future<void> uploadImageToStorage(List<File> imageFile, Pet pet) async {
    try {
      final String petName = pet.name + pet.age.toString();
      // Upload each image to Firebase Storage and save it inside pet object.
      for (File file in imageFile) {
        String storagePath =
            'pet/$petName/${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageReference = _storage.ref().child(storagePath);
        TaskSnapshot snapshot = await storageReference.putFile(file);
        // Get the download URL of the uploaded image
        String downloadURL = await snapshot.ref.getDownloadURL();
        pet.photos.add(downloadURL); // add the photos to current pet
        photos.add(downloadURL); // add the photos to current pet
      }
      createPet(pet); // create the pet with the photos
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      //TODO : Change return value to default photo !
      return;
    }
  }

  // Method to fetch all pets from Firestore and update the pets list
  Future<void> _fetchPets() async {
    try {
      final querySnapshot = await _petsCollection.get();
      _pets = querySnapshot.docs.map((doc) => Pet.fromJson(doc)).toList();
      notifyListeners();
    } catch (e) {
      // Handle any errors during pet fetching
      print('Error fetching pets: $e');
    }
  }

  Future<List<Pet>> findTopMatches(List<Pet> pets, bool isMale, bool isFemale,
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
}
