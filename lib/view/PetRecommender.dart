import 'package:flutter/material.dart';

import '../model/Pet.dart';
import '../viewmodel/PetsViewModel.dart';
import 'TopPetsScreen.dart';

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

class PetRecommenderScreen extends StatefulWidget {
  final List<Pet> pets;

  const PetRecommenderScreen({super.key, required this.pets});

  @override
  _PetRecommenderScreenState createState() => _PetRecommenderScreenState(pets);
}

class _PetRecommenderScreenState extends State<PetRecommenderScreen> {
  bool _isMale = false;
  bool _isFemale = false;
  double _maxAge = 15.0; // Default maximum age preference
  int _minEnergyLevel = 1; // Default minimum energy level preference
  String _description = '';
  PetViewModel petViewModel = PetViewModel();

  // AI search mode: 0 = desc->desc, 1 = desc->img
  int _aiSearchMode = 0;

  _PetRecommenderScreenState(List<Pet> pets);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.lightYellow,
                AppColors.accentYellow.withOpacity(0.3)
              ],
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
            'חיה בהתאמה אישית',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome header
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      AppColors.lightYellow.withOpacity(0.5)
                    ],
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
                        Icons.auto_awesome,
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
                            'מצאו את ההתאמה המושלמת',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBrown,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ענו על השאלות למטה',
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

              // Gender section
              _buildSectionCard(
                title: 'מין',
                icon: Icons.pets,
                child: Column(
                  children: [
                    _buildCustomCheckbox(
                      title: 'זכר',
                      value: _isMale,
                      onChanged: (value) {
                        setState(() {
                          _isMale = value!;
                        });
                      },
                      icon: Icons.male,
                    ),
                    const SizedBox(height: 8),
                    _buildCustomCheckbox(
                      title: 'נקבה',
                      value: _isFemale,
                      onChanged: (value) {
                        setState(() {
                          _isFemale = value!;
                        });
                      },
                      icon: Icons.female,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Enhanced AI Search Mode Section
              _buildSectionCard(
                title: 'סוג חיפוש חכם',
                icon: Icons.psychology,
                child: Column(
                  children: [
                    // Description text
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.lightYellow.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.accentYellow.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.primaryBrown,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'בחרו איך תרצו שהמערכת תמצא עבורכם חיות מתאימות',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.darkGray,
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Enhanced radio buttons
                    Column(
                      children: [
                        _buildEnhancedRadioOption(
                          value: 0,
                          groupValue: _aiSearchMode,
                          onChanged: (val) {
                            setState(() {
                              print("KOOKI ${_aiSearchMode}");
                              _aiSearchMode = 0;
                            });
                          },
                          icon: Icons.text_snippet,
                          title: 'חיפוש טקסטואלי מתקדם',
                          subtitle: 'התאמה על בסיס תיאורים כתובים',
                          description:
                              'המערכת תחפש חיות על בסיס התיאור שכתבתם ותתאים לתיאורים של החיות במאגר',
                          isRecommended: true,
                        ),
                        const SizedBox(height: 12),
                        _buildEnhancedRadioOption(
                          value: 1,
                          groupValue: _aiSearchMode,
                          onChanged: (val) {
                            setState(() {
                              _aiSearchMode = 1;
                            });
                          },
                          icon: Icons.image_search,
                          title: 'חיפוש ויזואלי חכם',
                          subtitle: 'התאמה על בסיס תמונות וחזות',
                          description:
                              'המערכת תנתח את התיאור שלכם ותמצא חיות שנראות בהתאם לציפיות שלכם',
                          isExperimental: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Size section placeholder
              _buildSectionCard(
                title: 'גודל',
                icon: Icons.straighten,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightYellow.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.accentYellow.withOpacity(0.3)),
                  ),
                  child: Text(
                    'בחירת גודל תתווסף בעתיד',
                    style: TextStyle(
                      color: AppColors.mediumGray,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Age section
              _buildSectionCard(
                title: 'גיל מקסימלי',
                icon: Icons.cake,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.primaryBrown,
                          inactiveTrackColor:
                              AppColors.lightBrown.withOpacity(0.3),
                          thumbColor: AppColors.accentYellow,
                          overlayColor: AppColors.accentYellow.withOpacity(0.2),
                          valueIndicatorColor: AppColors.primaryBrown,
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Slider(
                          value: _maxAge,
                          min: 1,
                          max: 15,
                          divisions: 28,
                          label: _maxAge.toStringAsFixed(1),
                          onChanged: (value) {
                            setState(() {
                              _maxAge = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.lightYellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_maxAge.toStringAsFixed(1)} שנים',
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
                ),
              ),

              const SizedBox(height: 20),

              // Energy level section
              _buildSectionCard(
                title: 'רמת אנרגיה מינימלית',
                icon: Icons.flash_on,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.primaryBrown,
                          inactiveTrackColor:
                              AppColors.lightBrown.withOpacity(0.3),
                          thumbColor: AppColors.accentYellow,
                          overlayColor: AppColors.accentYellow.withOpacity(0.2),
                          valueIndicatorColor: AppColors.primaryBrown,
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Slider(
                          value: _minEnergyLevel.toDouble(),
                          min: 1,
                          max: 5,
                          divisions: 4,
                          label: _minEnergyLevel.toString(),
                          onChanged: (value) {
                            setState(() {
                              _minEnergyLevel = value.toInt();
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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
                              color: index < _minEnergyLevel
                                  ? AppColors.accentYellow
                                  : AppColors.mediumGray.withOpacity(0.3),
                              size: 20,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            '$_minEnergyLevel/5',
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
                ),
              ),

              const SizedBox(height: 20),

              // Description section
              _buildSectionCard(
                title: 'תיאור החיה ופרטים נוספים',
                icon: Icons.description,
                child: Container(
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
                    onChanged: (value) {
                      setState(() {
                        _description = value;
                      });
                    },
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: TextStyle(
                      color: AppColors.darkGray,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      labelText: 'ספרו לנו מה אתם מחפשים...',
                      labelStyle: TextStyle(
                        color: AppColors.mediumGray,
                        fontSize: 14,
                      ),
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: AppColors.lightBrown.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: AppColors.lightBrown.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppColors.primaryBrown, width: 2),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit button
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
                  onPressed: () async {
                    if (_aiSearchMode == 1) {
                      petViewModel.filteredPets = await petViewModel.getTopPet(
                        widget.pets,
                        _isMale,
                        _isFemale,
                        _maxAge.toInt(),
                        _minEnergyLevel,
                        _description,
                      );
                    } else {
                      petViewModel.filteredPets = await petViewModel.findTopMatches(
                        widget.pets,
                        _isMale,
                        _isFemale,
                        _maxAge.toInt(),
                        _minEnergyLevel,
                        _description,
                      );
                    }
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetOptionsScreen(
                          petOptions: petViewModel.filteredPets,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.auto_awesome,
                          color: AppColors.accentYellow,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'מצאו לי התאמה',
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

  Widget _buildEnhancedRadioOption({
    required int value,
    required int groupValue,
    required ValueChanged<int?> onChanged,
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    bool isRecommended = false,
    bool isExperimental = false,
  }) {
    bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightYellow : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.accentYellow
                : AppColors.lightBrown.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.accentYellow.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Radio button
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryBrown
                          : AppColors.mediumGray,
                      width: 2,
                    ),
                    color: isSelected
                        ? AppColors.primaryBrown
                        : Colors.transparent,
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accentYellow.withOpacity(0.2)
                        : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? AppColors.primaryBrown
                        : AppColors.mediumGray,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Title and badges
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? AppColors.darkBrown
                                    : AppColors.darkGray,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          if (isRecommended)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.green.withOpacity(0.3)),
                              ),
                              child: Text(
                                'מומלץ',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          if (isExperimental)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.orange.withOpacity(0.3)),
                              ),
                              child: Text(
                                'ניסיוני',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? AppColors.primaryBrown
                              : AppColors.mediumGray,
                          fontWeight: FontWeight.w500,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accentYellow.withOpacity(0.1)
                    : AppColors.lightGray.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.darkGray,
                  height: 1.4,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
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

  Widget _buildCustomCheckbox({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: value ? AppColors.lightYellow : AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value
              ? AppColors.accentYellow
              : AppColors.lightBrown.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: CheckboxListTile(
        title: Row(
          children: [
            Icon(
              icon,
              color: value ? AppColors.primaryBrown : AppColors.mediumGray,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: value ? AppColors.darkBrown : AppColors.mediumGray,
              ),
              textAlign: TextAlign.start,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryBrown,
        checkColor: Colors.white,
        controlAffinity: ListTileControlAffinity.trailing,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
