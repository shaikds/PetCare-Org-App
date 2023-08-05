import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/model/Pet.dart';

class PetDetailsScreen extends StatelessWidget {
  final Pet pet;
  final bool isManager = !FirebaseAuth.instance.currentUser!.isAnonymous; // is it a manager or a guest?

  PetDetailsScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display pet's images in a simple image slider
            SizedBox(
              height: 200,
              child: ImageSlider(pet.photos),
            ),

            SizedBox(height: 16),

            // Rest of the content (description, form, etc.)
            // Display pet's description
            Text(
              pet.description,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            ),

            SizedBox(height: 16),

            // Form for the user to fill out
            TextFormField(
              decoration: const InputDecoration(
                  hintText: 'שם פרטי ומשפחה', icon: Icon(Icons.person)),
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              textDirection: TextDirection.ltr,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  hintText: 'אימייל',
                  icon: Icon(Icons.email),
                  alignLabelWithHint: true),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'מספר טלפון',
                icon: Icon(Icons.phone),
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            ),
            // Expandable text field for additional comments
            TextFormField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                  hintText: 'הערות נוספות', icon: Icon(Icons.comment)),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            ),

            SizedBox(height: 32),

            // Button to send the form
            ElevatedButton(
              onPressed: () {
                //TODO : Send Email To The Manager With The Data.(Ask Him)
                // Handle the form submission
                // You can implement sending data to the server here
              },
              child: const Text('שליחה'),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;

  ImageSlider(this.imageUrls, {super.key});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentIndex = 0;

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.imageUrls.length;
    });
  }

  void _previousImage() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + widget.imageUrls.length) %
          widget.imageUrls.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          itemCount: widget.imageUrls.length,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.imageUrls[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _previousImage,
            color: Colors.white,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _nextImage,
            color: Colors.white,
          ),
        ),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imageUrls.map((url) {
              int index = widget.imageUrls.indexOf(url);
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.white : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
