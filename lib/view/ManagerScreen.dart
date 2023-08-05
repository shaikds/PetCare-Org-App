import 'package:flutter/material.dart';
import 'package:flutter_login/viewmodel/PetsViewModel.dart';
import 'package:flutter_login/model/Pet.dart';

class ManagerScreen extends StatefulWidget {
  final Pet pet;

  const ManagerScreen({super.key, required this.pet});

  @override
  _ManagerScreen createState() => _ManagerScreen();
}

class _ManagerScreen extends State<ManagerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _energyLevelController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final PetViewModel _petViewModel = PetViewModel();


  late double _ageValue;
  late double _energyLevelValue;

  @override
  void initState() {
    super.initState();

    // Initialize the text controllers with the current pet's values
    _nameController.text = widget.pet.name;
    _energyLevelController.text = widget.pet.energyLevel.toString();
    _genderController.text = widget.pet.gender;
    _descriptionController.text = widget.pet.description;
    _sizeController.text = widget.pet.size;

    _ageValue = widget.pet.age.toDouble();
    _energyLevelValue = widget.pet.energyLevel.toDouble();
    String _genderValue = widget.pet.gender;
    String _sizeValue = widget.pet.size;
    final List<double> values = [0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.5,7.0,7.5,8.0,8.5,9.0,9.5,10.0,10.5,11.0,11.5,12.0,12.5,13.0,13.5,14.0,14.5,15.0];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('עדכון חיה'),
      ),
      body: SingleChildScrollView(
        child: Flexible(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nameController,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      labelText: 'שם',
                      floatingLabelAlignment: FloatingLabelAlignment.center),
                ),
                // TextField(
                //   controller: _ageController,
                //   textDirection: TextDirection.rtl,
                //   textAlign: TextAlign.center,
                //   decoration: InputDecoration(labelText: 'גיל',floatingLabelAlignment: FloatingLabelAlignment.center),
                //   keyboardType: TextInputType.number,
                // ),
                // TextField(
                //   controller: _energyLevelController,
                //   textDirection: TextDirection.rtl,
                //   textAlign: TextAlign.center,
                //   decoration: InputDecoration(labelText: 'רמת אנרגיה',floatingLabelAlignment: FloatingLabelAlignment.center),
                //   keyboardType: TextInputType.number,
                // ),
                // TextField(
                //   controller: _genderController,
                //   textDirection: TextDirection.rtl,
                //   textAlign: TextAlign.center,
                //   decoration: InputDecoration(labelText: 'מין',floatingLabelAlignment: FloatingLabelAlignment.center),
                // ),

                TextField(
                  controller: _descriptionController,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      labelText: 'תיאור',
                      floatingLabelAlignment: FloatingLabelAlignment.center),
                ),
                // TextField(
                //   controller: _sizeController,
                //   textDirection: TextDirection.rtl,
                //   textAlign: TextAlign.center,
                //   decoration: InputDecoration(labelText: 'גודל',floatingLabelAlignment: FloatingLabelAlignment.center),
                // ),
                // Replace the TextField for age with a Slider

                const SizedBox(height: 16),

                _buildAgeSlider(),

          _buildEnergyLevelSlider(),

// Replace the TextField for gender with RadioListTile
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('מין', textAlign: TextAlign.right),
                    RadioListTile(
                      title: const Text('זכר'),
                      value: 'זכר',
                      groupValue: _genderController.text,
                      onChanged: (value) {
                        setState(() {
                          _genderController.text = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('נקבה'),
                      value: 'נקבה',
                      groupValue: _genderController.text,
                      onChanged: (value) {
                        setState(() {
                          _genderController.text = value.toString();
                        });
                      },
                    ),
                  ],
                ),

// Replace the TextField for size with RadioListTile
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('גודל', textAlign: TextAlign.center),
                    RadioListTile(
                      title: const Text('קטן.ה'),
                      value: 'קטן.ה',
                      groupValue: _sizeController.text,
                      onChanged: (value) {
                        setState(() {
                          _sizeController.text = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('בינוני.ת'),
                      value: 'בינוני.ת',
                      groupValue: _sizeController.text,
                      onChanged: (value) {
                        setState(() {
                          _sizeController.text = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('גדול.ה'),
                      value: 'גדול.ה',
                      groupValue: _sizeController.text,
                      onChanged: (value) {
                        setState(() {
                          _sizeController.text = value.toString();
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Update the pet in the database using the PetViewModel
                    final updatedPet = Pet(
                      name: _nameController.text,
                      age: _ageValue.toInt(),
                      energyLevel:_energyLevelValue.toInt(),
                      gender: _genderController.text,
                      description: _descriptionController.text,
                      size: _sizeController.text,
                      photos: widget.pet.photos,
                      isAdopted: widget.pet.isAdopted,
                    );
                    _petViewModel.updatePet(widget.pet.uid, updatedPet);

                    // Navigate back to the previous screen
                    Navigator.pop(context);
                  },
                  child: const Text('עדכון'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Delete the pet from the database using the PetViewModel
                    _showDeleteConfirmationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: const Text('מחיקה'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('מחיקה'),
          content: const Text('האם למחוק את החיה מהמאגר?'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog when the user taps "Cancel"
                Navigator.of(context).pop();
              },
              child: const Text('ביטול'),
            ),
            TextButton(
              onPressed: () {
                // Perform the delete operation here
                // You can call the delete method from your view model or data source
                // For example: Provider.of<PetViewModel>(context, listen: false).deletePet(pet);
                // Don't forget to add the necessary code to delete the pet from your data source
                _petViewModel.deletePet(widget.pet.uid);
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: const Text('מחיקה'),
            ),
          ],
        );
      },
    );
  }
// Energy Level Slider
Widget _buildEnergyLevelSlider() {
  return Slider(
    value: _energyLevelValue,
    onChanged: (double newValue) {
      setState(() {
        _energyLevelValue = newValue;
      });
    },
    activeColor: Colors.green,
    min: 1,
    max: 5,
    divisions: 4,
    label: _energyLevelValue.toStringAsFixed(0),
  );
}
  Widget _buildAgeSlider() {
    final List<double> values = [0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.5,7.0,7.5,8.0,8.5,9.0,9.5,10.0,10.5,11.0,11.5,12.0,12.5,13.0,13.5,14.0,14.5,15.0];

    return Slider(
      value: _ageValue.toDouble(),
      onChanged: (double newValue) {
        setState(() {
          _ageValue = newValue;
        });
      },
      activeColor: Colors.green,
      min: 0,
      max: 30,
      divisions: 30,
      // This divides the slider into 5 equal parts (1-5).
      label: (_ageValue/2).toStringAsFixed(1),
    );
  }

}
