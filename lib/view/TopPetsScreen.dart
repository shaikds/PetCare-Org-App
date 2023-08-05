import 'package:flutter/material.dart';
import 'package:flutter_login/PetCard.dart';
import 'package:flutter_login/model/Pet.dart';
import 'package:flutter_login/view/PetDetailsScreen.dart'; // Replace with your Pet model

class PetOptionsScreen extends StatefulWidget {
  final List<Pet> petOptions;

  const PetOptionsScreen({Key? key, required this.petOptions})
      : super(key: key);

  @override
  _PetOptionsScreenState createState() => _PetOptionsScreenState();
}

class _PetOptionsScreenState extends State<PetOptionsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate loading data (replace with your actual data loading logic)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Options'),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
      : GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 1,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    ),
    itemCount: widget.petOptions.length,
    itemBuilder: (context, index) {
    return PetCard(
    pet: widget.petOptions[index],
    onTap: () {
    //TODO : Handle the tap event for the pet card

    // You can navigate to a details screen or perform any other action here
    print('Tapped on pet ${widget.petOptions[index].name}');
    // Navigate to the PetDetailsScreen when the card is tapped
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => PetDetailsScreen(pet: widget.petOptions[index]),
    ),
    );
    },
    );
    },
    ),
    );
  }
}
