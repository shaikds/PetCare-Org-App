import 'package:flutter/material.dart';
import 'package:flutter_login/model/Pet.dart';
import 'package:flutter_login/view/ScreenAddPhotos.dart';

class AddPetScreen extends StatefulWidget {
  //TODO : Transfer the data to Photos screen.
  @override
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final List<double> values = [0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.5,7.0,7.5,8.0,8.5,9.0,9.5,10.0,10.5,11.0,11.5,12.0,12.5,13.0,13.5,14.0,14.5,15.0];

  // Variables to store the user's answers for each question
  String petGender = 'Male'; // Default option
  int petAge = 1; // Default option
  String petName = '';
  String size = '';
  int energyLevel = 1;
  String description = '';
  List<String> petPhotos = [];

  // Controller for the text field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController energyController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('הוספת חיה'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question 1: Pet Name, Gender, and Energy Level
            _buildQuestion(
              'מלאו את הפרטים הבאים',
              //Name
              _buildTextField(nameController, 'שם'),
            ),
            const SizedBox(height: 16),

            // Description
            _buildTextField(descriptionController, 'תיאור'),
            const SizedBox(height: 16),

            //Energy
            _buildQuestion('רמת אנרגיה', _buildEnergySlider()),
            //Age
            _buildQuestion('גיל', _buildAgeSlider()),

            const SizedBox(height: 16),

            // Size
            _buildSizeSelection(),
            //Question 1B: Gender
            _buildGenderSelection(),
            const SizedBox(height: 16),
            // Complete Button
            ElevatedButton(
              onPressed: () {
                if (nameController.text == "" ||
                    petGender == "" ||
                    petGender == null ||
                    descriptionController.text == "") {
                  _showSnackBar("אנא מלאו את כל הפרטים");
                  return;
                }
                Pet newPet = Pet(
                  name: nameController.text,
                  gender: petGender,
                  age: petAge,
                  description: descriptionController.text,
                  isAdopted: false,
                  energyLevel: energyLevel,
                  size: size,
                  photos: petPhotos,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddPetPhotos(newPet: newPet)),
                );

                // Navigate to the choose photo clicked.
              },
              child: const Text('הוספת תמונות'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(String question, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          question,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          hintTextDirection: TextDirection.rtl, hintText: label),
      textDirection: TextDirection.rtl,
    );
  }

  //Energy Slider
  Widget _buildEnergySlider() {
    return Slider(
      value: energyLevel.toDouble(),
      onChanged: (newValue) {
        setState(() {
          energyLevel = newValue.round();
        });
      },
      activeColor: Colors.green,
      min: 1,
      max: 5,
      divisions: 4,
      // This divides the slider into 5 equal parts (1-5).
      label: energyLevel.toString(),
    );
  } //Energy Slider

  Widget _buildAgeSlider() {
    return Slider(
      value: petAge.toDouble(),
      onChanged: (double newValue) {
        setState(() {
          petAge = newValue.toInt();
        });
      },
      activeColor: Colors.green,
      min: 0,
      max: values.length-1,
      divisions: values.length-1,
      // This divides the slider into 5 equal parts (1-5).
      label: values[petAge].toString(),
    );
  }



  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 16),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 8.0,
        showCloseIcon: true,
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'מין',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        // RadioListTile for male
        RadioListTile(
          title: const Text('זכר'),
          value: 'זכר',
          selected: true,
          groupValue: petGender,
          onChanged: (value) {
            setState(() {
              petGender = value.toString();
            });
          },
        ),
        // RadioListTile for female
        RadioListTile(
          title: const Text('נקבה'),
          value: 'נקבה',
          selected: false,
          groupValue: petGender,
          onChanged: (value) {
            setState(() {
              petGender = value.toString();
            });
          },
        ),
      ],
    );
  }

  Widget _buildSizeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'גודל',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        // RadioListTile for male
        RadioListTile(
          title: const Text('קטן.ה'),
          value: 'קטן.ה',
          selected: true,
          groupValue: size,
          onChanged: (value) {
            setState(() {
              size = value.toString();
            });
          },
        ),
        // RadioListTile for female
        RadioListTile(
          title: const Text('בינוני.ת'),
          value: 'בינוני.ת',
          selected: false,
          groupValue: size,
          onChanged: (value) {
            setState(() {
              size = value.toString();
            });
          },
        ),        // RadioListTile for גדול
        RadioListTile(
          title: const Text('גדול.ה'),
          value: 'גדול.ה',
          selected: false,
          groupValue: size,
          onChanged: (value) {
            setState(() {
              size = value.toString();
            });
          },
        ),
      ],
    );
  }
}
