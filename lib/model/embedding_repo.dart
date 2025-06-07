import 'dart:convert';
import 'dart:math';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class EmbeddingRepo {
  final String textUrl;
  final String imageUrl;

  EmbeddingRepo({
    String? host,
  }) : textUrl = 'http://${host ?? _getDefaultHost()}:8000/embed_text',
       imageUrl = 'http://${host ?? _getDefaultHost()}:8000/embed_image';

  static String _getDefaultHost() {
    if (Platform.isAndroid) {
      return '10.0.2.2'; // Special IP for Android emulator to reach host machine
    }
    return '127.0.0.1'; // For iOS simulator and desktop
  }

  Future<List<double>> getTextEmbedding(String text) async {
    try {
      print('Sending text embedding request for: ${text.substring(0, min(50, text.length))}...');
      print('Using URL: $textUrl');
      
      final response = await http.post(
        Uri.parse(textUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );
      print('Text embedding response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<double>.from(data['embedding']);
      } else {
        print('Text embedding error response: ${response.body}');
        throw Exception('Failed to get text embedding: ${response.body}');
      }
    } catch (e) {
      print('Text embedding request failed: $e');
      rethrow;
    }
  }

  Future<List<double>> getImageEmbedding(String imagePath) async {
    try {
      print('Sending image embedding request for: $imagePath');
      print('Using URL: $imageUrl');
      
      var request = http.MultipartRequest('POST', Uri.parse(imageUrl));
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));
      
      print('Sending request...');
      final response = await request.send();
      print('Image embedding response status: ${response.statusCode}');
      
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final data = jsonDecode(respStr);
        return List<double>.from(data['embedding']);
      } else {
        print('Image embedding error response: $respStr');
        throw Exception('Failed to get image embedding: $respStr');
      }
    } catch (e) {
      print('Image embedding request failed: $e');
      rethrow;
    }
  }
} 