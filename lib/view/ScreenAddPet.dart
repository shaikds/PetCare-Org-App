import 'package:flutter/material.dart';

import '../model/Pet.dart';
import 'ScreenAddPhotos.dart';

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
            'הוספת חיה',
            style: TextStyle(
              color: AppColors.darkBrown,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ),
        shadowColor: AppColors.darkBrown.withOpacity(0.3),
        centerTitle: true,
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome header
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
                        Icons.add_circle,
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
                            'הוספת חיה חדשה',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBrown,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'מלאו את הפרטים הבאים',
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

              // Pet details section
              _buildSectionCard(
                title: 'פרטי החיה',
                icon: Icons.pets,
                child: Column(
                  children: [
                    _buildTextField(nameController, 'שם'),
                    const SizedBox(height: 16),
                    _buildTextField(descriptionController, 'תיאור'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Energy level section
              _buildSectionCard(
                title: 'רמת אנרגיה',
                icon: Icons.flash_on,
                child: _buildEnergySlider(),
              ),

              const SizedBox(height: 20),

              // Age section
              _buildSectionCard(
                title: 'גיל',
                icon: Icons.cake,
                child: _buildAgeSlider(),
              ),

              const SizedBox(height: 20),

              // Size selection
              _buildSectionCard(
                title: 'גודל החיה',
                icon: Icons.straighten,
                child: _buildSizeSelection(),
              ),

              const SizedBox(height: 20),

              // Gender selection
              _buildSectionCard(
                title: 'מין החיה',
                icon: Icons.pets,
                child: _buildGenderSelection(),
              ),

              const SizedBox(height: 32),

              // Complete Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
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
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.photo_camera,
                          color: AppColors.accentYellow,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'הוספת תמונות',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
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
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: AppColors.darkGray,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintTextDirection: TextDirection.rtl,
          hintText: label,
          hintStyle: TextStyle(
            color: AppColors.mediumGray,
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white,
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
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  //Energy Slider
  Widget _buildEnergySlider() {
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
              value: energyLevel.toDouble(),
              onChanged: (newValue) {
                setState(() {
                  energyLevel = newValue.round();
                });
              },
              min: 1,
              max: 5,
              divisions: 4,
              label: energyLevel.toString(),
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
                  color: index < energyLevel
                      ? AppColors.accentYellow
                      : AppColors.mediumGray.withOpacity(0.3),
                  size: 20,
                );
              }),
              const SizedBox(width: 8),
              Text(
                '$energyLevel/5',
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

  Widget _buildAgeSlider() {
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
              value: petAge.toDouble(),
              onChanged: (double newValue) {
                setState(() {
                  petAge = newValue.toInt();
                });
              },
              min: 0,
              max: values.length-1,
              divisions: values.length-1,
              label: values[petAge].toString(),
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
            '${values[petAge]} שנים',
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 12,
        margin: const EdgeInsets.all(16),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      children: [
        _buildCustomRadio(
          title: 'זכר',
          value: 'זכר',
          groupValue: petGender,
          onChanged: (value) {
            setState(() {
              petGender = value.toString();
            });
          },
          icon: Icons.male,
        ),
        const SizedBox(height: 12),
        _buildCustomRadio(
          title: 'נקבה',
          value: 'נקבה',
          groupValue: petGender,
          onChanged: (value) {
            setState(() {
              petGender = value.toString();
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
          groupValue: size,
          onChanged: (value) {
            setState(() {
              size = value.toString();
            });
          },
          icon: Icons.pets,
        ),
        const SizedBox(height: 12),
        _buildCustomRadio(
          title: 'בינוני.ת',
          value: 'בינוני.ת',
          groupValue: size,
          onChanged: (value) {
            setState(() {
              size = value.toString();
            });
          },
          icon: Icons.pets,
        ),
        const SizedBox(height: 12),
        _buildCustomRadio(
          title: 'גדול.ה',
          value: 'גדול.ה',
          groupValue: size,
          onChanged: (value) {
            setState(() {
              size = value.toString();
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
}