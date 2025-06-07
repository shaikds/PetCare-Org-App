import 'package:flutter/material.dart';

import '../PetCard.dart';
import '../model/Pet.dart';
import 'PetDetailsScreen.dart';

class AppColors {
  static const Color primaryBrown = Color(0xFF8D6E63);
  static const Color lightBrown = Color(0xFFBCAAA4);
  static const Color darkBrown = Color(0xFF5D4037);
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color lightYellow = Color(0xFFFFF8E1);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF424242);
  static const Color goldColor = Color(0xFFFFD700);
  static const Color silverColor = Color(0xFFC0C0C0);
  static const Color bronzeColor = Color(0xFFCD7F32);
}

class PetOptionsScreen extends StatefulWidget {
  final List<Pet> petOptions;

  const PetOptionsScreen({Key? key, required this.petOptions})
      : super(key: key);

  @override
  _PetOptionsScreenState createState() => _PetOptionsScreenState();
}

class _PetOptionsScreenState extends State<PetOptionsScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));

    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    // Simulate loading data (replace with your actual data loading logic)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
    _animationController.forward();
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
            'ההתאמה המושלמת',
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
      body: _isLoading
          ? _buildLoadingScreen()
          : FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildWinnersDisplay(),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkBrown.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.lightYellow,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: AppColors.primaryBrown,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBrown),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'מחפשים את ההתאמות הטובות ביותר...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
    );
  }

  Widget _buildWinnersDisplay() {
    if (widget.petOptions.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
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
          children: [
            // Winners header
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 30),
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
                      color: AppColors.goldColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: AppColors.goldColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'הזוכים הגדולים!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBrown,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'החיות שהכי מתאימות לכם',
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
            // Winners podium
            if (widget.petOptions.length >= 3) _buildPodium(),
            if (widget.petOptions.length < 3) _buildSimpleList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPodium() {
    return SingleChildScrollView(child: Column(
      children: [
        // First place (center, highest)
        _buildWinnerCard(
          pet: widget.petOptions[0],
          rank: 1,
          color: AppColors.goldColor,
          height: 200,
          title: 'מקום ראשון',
          subtitle: 'ההתאמה המושלמת!',
          icon: Icons.emoji_events,
        ),
        const SizedBox(height: 20),

              // Remove Expanded here!
              _buildWinnerCard(
                pet: widget.petOptions[1],
                rank: 2,
                color: AppColors.silverColor,
                height: 200,
                title: 'מקום שני',
                subtitle: 'התאמה מעולה',
                icon: Icons.workspace_premium,
              ),
        const SizedBox(height: 20),
              _buildWinnerCard(
                pet: widget.petOptions[2],
                rank: 3,
                color: AppColors.bronzeColor,
                height: 200,
                title: 'מקום שלישי',
                subtitle: 'התאמה טובה',
                icon: Icons.military_tech,
        ),


        // Additional pets if any
        if (widget.petOptions.length > 3) ...[
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkBrown.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'התאמות נוספות',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 16),
                ...widget.petOptions.skip(3).map((pet) =>
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: PetCard(
                        pet: pet,
                        onTap: () {
                          print('Tapped on pet ${pet.name}');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PetDetailsScreen(pet: pet),
                            ),
                          );
                        },
                      ),
                    ),
                ).toList(),
              ],
            ),
          ),
        ],
      ],
    ));
  }

  Widget _buildSimpleList() {
    return Column(
      children: widget.petOptions.asMap().entries.map((entry) {
        int index = entry.key;
        Pet pet = entry.value;

        Color rankColor = index == 0 ? AppColors.goldColor :
        index == 1 ? AppColors.silverColor :
        AppColors.bronzeColor;

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: _buildWinnerCard(
            pet: pet,
            rank: index + 1,
            color: rankColor,
            height: 180,
            title: 'מקום ${_getHebrewNumber(index + 1)}',
            subtitle: index == 0 ? 'ההתאמה הטובה ביותר!' : 'התאמה מעולה',
            icon: index == 0 ? Icons.emoji_events : Icons.workspace_premium,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWinnerCard({
    required Pet pet,
    required int rank,
    required Color color,
    required double height,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        print('Tapped on pet ${pet.name}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetDetailsScreen(pet: pet),
          ),
        );
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 8,
              offset: const Offset(0, -2),
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Pet image
              Image.network(
                pet.photos!.first,
                fit: BoxFit.cover,
              ),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),

              // Rank badge (top left)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$rank',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Pet info (bottom)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Rank title
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Pet name
                      Text(
                        pet.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 4),

                      // Subtitle
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 8),

                      // Pet details
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildDetailChip(Icons.pets, pet.gender),
                            const SizedBox(width: 8),
                            _buildDetailChip(Icons.cake, '${pet.age / 2}'),
                            const SizedBox(width: 8),
                            _buildDetailChip(Icons.straighten, pet.size),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.lightYellow,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppColors.primaryBrown,
          ),
          const SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.darkBrown,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightYellow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off,
                size: 64,
                color: AppColors.primaryBrown,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'לא נמצאו התאמות',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            Text(
              'נסו לשנות את הקריטריונים שלכם',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mediumGray,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  String _getHebrewNumber(int number) {
    switch (number) {
      case 1: return 'ראשון';
      case 2: return 'שני';
      case 3: return 'שלישי';
      default: return '$number';
    }
  }
}