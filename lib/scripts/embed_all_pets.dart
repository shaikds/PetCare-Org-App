import '../model/embedding_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> main() async {
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firestore = FirebaseFirestore.instance;
  final embeddingRepo = EmbeddingRepo();

  final pets = await firestore.collection('pets').get();
  for (final doc in pets.docs) {
    final data = doc.data();
    final desc = data['description'] ?? '';
    final photos = List<String>.from(data['photos'] ?? []);
    String? mainPhotoPath;
    if (photos.isNotEmpty) {
      // Download the first photo to a temp file for embedding
      try {
        final url = photos.first;
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/${doc.id}_main.jpg');
        final response = await HttpClient().getUrl(Uri.parse(url));
        final fileStream = await response.close();
        await fileStream.pipe(tempFile.openWrite());
        mainPhotoPath = tempFile.path;
      } catch (e) {
        print('Failed to download image for pet ${doc.id}: $e');
      }
    }
    try {
      List<double>? descEmbedding;
      List<double>? imgEmbedding;
      if (desc.isNotEmpty) {
        descEmbedding = await embeddingRepo.getTextEmbedding(desc);
      }
      if (mainPhotoPath != null && File(mainPhotoPath).existsSync()) {
        imgEmbedding = await embeddingRepo.getImageEmbedding(mainPhotoPath);
      }
      await doc.reference.update({
        if (descEmbedding != null) 'descEmbedding': descEmbedding,
        if (imgEmbedding != null) 'imgEmbedding': imgEmbedding,
      });
      print('Embedded pet: ${doc.id}');
    } catch (e) {
      print('Failed to embed pet ${doc.id}: $e');
    }
  }
  print('All pets embedded!');
} 