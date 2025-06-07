import 'package:flutter/material.dart';

import '../model/Pet.dart';
import '../viewmodel/PetsViewModel.dart';

class AppColors {
  static const Color primaryBrown = Color(0xFF8D6E63);
  static const Color lightBrown = Color(0xFFBCAAA4);
  static const Color darkBrown = Color(0xFF5D4037);
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color lightYellow = Color(0xFFFFF8E1);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF424242);
}

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
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.lightYellow, AppColors.accentYellow.withOpacity(0.3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkBrown.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'עדכון חיה',
            style: TextStyle(
              color: AppColors.darkBrown,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ),
        centerTitle: true,
        shadowColor: AppColors.darkBrown.withOpacity(0.3),
        elevation: 12,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.primaryBrown),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.8),
              AppColors.lightGray,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header card with pet info
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, AppColors.lightYellow.withOpacity(0.5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkBrown.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: AppColors.primaryBrown,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'עריכת פרטי החיה',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBrown,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.pet.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.mediumGray,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Name field
                _buildSectionCard(
                  title: 'שם החיה',
                  icon: Icons.pets,
                  child: _buildTextField(
                    controller: _nameController,
                    labelText: 'שם',
                    hintText: 'הכניסו את שם החיה',
                  ),
                ),

                const SizedBox(height: 20),

                // Description field (disabled)
                _buildSectionCard(
                  title: 'תיאור',
                  icon: Icons.description,
                  child: _buildTextField(
                    controller: _descriptionController,
                    labelText: 'תיאור',
                    hintText: 'לא ניתן לשנות ערך זה בהמשך',
                    enabled: false,
                  ),
                ),

                const SizedBox(height: 20),

                // Age slider
                _buildSectionCard(
                  title: 'גיל החיה',
                  icon: Icons.cake,
                  child: _buildAgeSlider(),
                ),

                const SizedBox(height: 20),

                // Energy level slider
                _buildSectionCard(
                  title: 'רמת אנרגיה',
                  icon: Icons.flash_on,
                  child: _buildEnergyLevelSlider(),
                ),

                const SizedBox(height: 20),

                // Gender selection
                _buildSectionCard(
                  title: 'מין החיה',
                  icon: Icons.pets,
                  child: _buildGenderSelection(),
                ),

                const SizedBox(height: 20),

                // Size selection
                _buildSectionCard(
                  title: 'גודל החיה',
                  icon: Icons.straighten,
                  child: _buildSizeSelection(),
                ),

                const SizedBox(height: 32),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [AppColors.primaryBrown, AppColors.darkBrown],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkBrown.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            // Update the pet in the database using the PetViewModel
                            final updatedPet = Pet(
                              name: _nameController.text,
                              age: _ageValue.toInt(),
                              energyLevel: _energyLevelValue.toInt(),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.accentYellow.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.save,
                                  color: AppColors.accentYellow,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'עדכון',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [Colors.red.shade400, Colors.red.shade600],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            // Delete the pet from the database using the PetViewModel
                            _showDeleteConfirmationDialog(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'מחיקה',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBrown.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.lightYellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryBrown,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightBrown.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: enabled ? AppColors.darkGray : AppColors.mediumGray,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: TextStyle(
            color: AppColors.mediumGray,
            fontSize: 14,
          ),
          hintStyle: TextStyle(
            color: AppColors.mediumGray.withOpacity(0.7),
            fontSize: 12,
          ),
          floatingLabelAlignment: FloatingLabelAlignment.center,
          filled: true,
          fillColor: enabled ? Colors.white : AppColors.lightGray.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.lightBrown.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.lightBrown.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryBrown, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.mediumGray.withOpacity(0.3)),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildAgeSlider() {
    final List<double> values = [0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.5,7.0,7.5,8.0,8.5,9.0,9.5,10.0,10.5,11.0,11.5,12.0,12.5,13.0,13.5,14.0,14.5,15.0];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primaryBrown,
              inactiveTrackColor: AppColors.lightBrown.withOpacity(0.3),
              thumbColor: AppColors.accentYellow,
              overlayColor: AppColors.accentYellow.withOpacity(0.2),
              valueIndicatorColor: AppColors.primaryBrown,
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Slider(
              value: _ageValue.toDouble(),
              onChanged: (double newValue) {
                setState(() {
                  _ageValue = newValue;
                });
              },
              min: 0,
              max: 30,
              divisions: 30,
              label: (_ageValue/2).toStringAsFixed(1),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.lightYellow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${(_ageValue/2).toStringAsFixed(1)} שנים',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildEnergyLevelSlider() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primaryBrown,
              inactiveTrackColor: AppColors.lightBrown.withOpacity(0.3),
              thumbColor: AppColors.accentYellow,
              overlayColor: AppColors.accentYellow.withOpacity(0.2),
              valueIndicatorColor: AppColors.primaryBrown,
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Slider(
              value: _energyLevelValue,
              onChanged: (double newValue) {
                setState(() {
                  _energyLevelValue = newValue;
                });
              },
              min: 1,
              max: 5,
              divisions: 4,
              label: _energyLevelValue.toStringAsFixed(0),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.lightYellow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  Icons.flash_on,
                  color: index < _energyLevelValue
                      ? AppColors.accentYellow
                      : AppColors.mediumGray.withOpacity(0.3),
                  size: 20,
                );
              }),
              const SizedBox(width: 8),
              Text(
                '${_energyLevelValue.toStringAsFixed(0)}/5',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      children: [
        _buildCustomRadio(
          title: 'זכר',
          value: 'זכר',
          groupValue: _genderController.text,
          onChanged: (value) {
            setState(() {
              _genderController.text = value.toString();
            });
          },
          icon: Icons.male,
        ),
        const SizedBox(height: 12),
        _buildCustomRadio(
          title: 'נקבה',
          value: 'נקבה',
          groupValue: _genderController.text,
          onChanged: (value) {
            setState(() {
              _genderController.text = value.toString();
            });
          },
          icon: Icons.female,
        ),
      ],
    );
  }

  Widget _buildSizeSelection() {
    return Column(
      children: [
        _buildCustomRadio(
          title: 'קטן.ה',
          value: 'קטן.ה',
          groupValue: _sizeController.text,
          onChanged: (value) {
            setState(() {
              _sizeController.text = value.toString();
            });
          },
          icon: Icons.pets,
        ),
        const SizedBox(height: 12),
        _buildCustomRadio(
          title: 'בינוני.ת',
          value: 'בינוני.ת',
          groupValue: _sizeController.text,
          onChanged: (value) {
            setState(() {
              _sizeController.text = value.toString();
            });
          },
          icon: Icons.pets,
        ),
        const SizedBox(height: 12),
        _buildCustomRadio(
          title: 'גדול.ה',
          value: 'גדול.ה',
          groupValue: _sizeController.text,
          onChanged: (value) {
            setState(() {
              _sizeController.text = value.toString();
            });
          },
          icon: Icons.pets,
        ),
      ],
    );
  }

  Widget _buildCustomRadio({
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightYellow : AppColors.lightGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accentYellow : AppColors.lightBrown.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryBrown : AppColors.mediumGray,
                  width: 2,
                ),
                color: isSelected ? AppColors.primaryBrown : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
                  : null,
            ),
            const SizedBox(width: 12),

            // Icon
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBrown : AppColors.mediumGray,
              size: 20,
            ),
            const SizedBox(width: 8),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.darkBrown : AppColors.mediumGray,
              ),
              textAlign: TextAlign.start,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'מחיקה',
                style: TextStyle(
                  color: AppColors.darkBrown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'האם למחוק את החיה מהמאגר?',
            style: TextStyle(
              color: AppColors.darkGray,
              fontSize: 16,
            ),
            textDirection: TextDirection.rtl,
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog when the user taps "Cancel"
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'ביטול',
                style: TextStyle(
                  color: AppColors.mediumGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade400, Colors.red.shade600],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  // Perform the delete operation here
                  // You can call the delete method from your view model or data source
                  // For example: Provider.of<PetViewModel>(context, listen: false).deletePet(pet);
                  // Don't forget to add the necessary code to delete the pet from your data source
                  _petViewModel.deletePet(widget.pet.uid);
                  Navigator.of(context).pop(); // Close the dialog after deletion
                  Navigator.pop(context); // Navigate back to the previous screen
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'מחיקה',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}