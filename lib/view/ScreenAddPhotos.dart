import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/Pet.dart';
import '../viewmodel/PetsViewModel.dart';

class AddPetPhotos extends StatefulWidget {
  final Pet newPet;

  @override
  _AddPetPhotosState createState() => _AddPetPhotosState(newPet);

  AddPetPhotos({required this.newPet});
}

class _AddPetPhotosState extends State<AddPetPhotos> {
  // Variables to store the user's answers for each question
  Pet pet;

  final imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  _AddPetPhotosState(this.pet);

  @override
  Widget build(BuildContext context) {
    PetViewModel petViewModel =
        Provider.of<PetViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('הוספת חיה'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                selectImages();
              },
              child: Text('בחירת תמונה'),
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      itemCount: imageFileList!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return Image.file(
                          File(imageFileList![index].path),
                          fit: BoxFit.cover,
                        );
                      }),
                ),
              ),
            // Complete Button
            ElevatedButton(
              onPressed: () {
                if (imageFileList == null || imageFileList!.isEmpty){
                  _showSnackBar('בחרו לפחות תמונה אחת'); // if list is empty dont continue.
                  return; }
                List<File> images =
                    imageFileList!.map((xFile) => File(xFile.path)).toList();
                petViewModel.uploadImageToStorage(
                    images, pet); // upload & save pet in database.
                Navigator.popUntil(context,
                    (route) => route.isFirst); // return to home screen.
              },
              child: Text('סיום'),
            ),
          ],
        ),
      ),
    );
  }

  void selectImages() async {
    //TODO : Limit the photos number to 4.
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    } else
      _showSnackBar("הוסיפו תמונה אחת לפחות");
    print("Image List Length:" + imageFileList!.length.toString());
    setState(() {});
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 16),
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 8.0,
        showCloseIcon: true,
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
