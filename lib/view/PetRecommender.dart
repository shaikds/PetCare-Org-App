import 'package:flutter/material.dart';
import 'package:flutter_login/model/Pet.dart';
import 'package:flutter_login/view/TopPetsScreen.dart';
import 'package:flutter_login/view/TopPetsScreen.dart';
import 'package:flutter_login/view/TopPetsScreen.dart';
import 'package:flutter_login/viewmodel/PetsViewModel.dart';

import 'TopPetsScreen.dart';

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

  _PetRecommenderScreenState(List<Pet> pets);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'חיה בהתאמה אישית',
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('מין',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl),
              CheckboxListTile(
                title: const Text('זכר',
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.rtl),
                value: _isMale,
                onChanged: (value) {
                  setState(() {
                    _isMale = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('נקבה',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.start),
                value: _isFemale,
                onChanged: (value) {
                  setState(() {
                    _isFemale = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              Text('גיל מקסימלי',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl),
              Slider(
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
              Text(
                '${_maxAge.toStringAsFixed(1)}',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text('רמת אנרגיה מינימלית',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl),
              Slider(
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
              Text(
                '$_minEnergyLevel/5',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'תיאור',
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // TODO: Find top 3 matches based on user preferences
                  petViewModel.findTopMatches(widget.pets, _isMale, _isFemale,
                      _maxAge.toInt(), _minEnergyLevel, _description);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetOptionsScreen(
                        petOptions: petViewModel!.filteredPets,
                      ),
                    ),
                  );
                },
                child: Text('התאימו לי חיות'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
