import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/PetCard.dart';
import 'package:flutter_login/view/PetRecommender.dart';
import 'package:flutter_login/view/ScreenAddPet.dart';
import 'package:flutter_login/model/Pet.dart';
import 'package:flutter_login/view/SignInScreen.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutter_login/viewmodel/PetsViewModel\.dart'; // Import the PetViewModel class
import 'package:provider/provider.dart';
import 'PetDetailsScreen.dart';

class HomeScreen extends StatelessWidget {
  //TODO : check IT .


  // final isFabVisible = true; //TODO : Erase it after release.

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Pet> pets = Provider.of<PetViewModel>(context).pets;
    Provider.of<PetViewModel>(context, listen: false).readPets();
    final isFabVisible = !FirebaseAuth.instance.currentUser!.isAnonymous;

    return Scaffold(
      appBar: AppBar(
        title: const Text('אמצו חיית מחמד'),
        centerTitle: true,
        elevation: 4,
        leading: const Padding(padding: EdgeInsets.only(left: 12)),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_accounts_outlined),
            onPressed: () {
              if (!isFabVisible) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              } else {
                _showSnackBar(context, 'המשתמש כבר מחובר');
              }
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return PetCard(
            pet: pets[index],
            onTap: () {
              //TODO : Handle the tap event for the pet card

              // You can navigate to a details screen or perform any other action here
              print('Tapped on pet ${pets[index].name}');
              // Navigate to the PetDetailsScreen when the card is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PetDetailsScreen(pet: pets[index]),
                ),
              );
            },
          );
        },
      ),

      //circular fab
      floatingActionButton: Visibility(
        visible: isFabVisible,
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to the new screen when FAB is clicked.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPetScreen()),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.black,
          hoverColor: Colors.white,
          highlightElevation: 30.0,
          elevation: 8.0,
          shape: const CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      //bottom bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the PetRecommenderScreen when the button is clicked
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PetRecommenderScreen(pets: pets.toList())),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            surfaceTintColor: Colors.black,
            foregroundColor: Colors.black,
            // surfaceTintColor: Colors.transparent,
            elevation: 4.0,
            shadowColor: Colors.brown,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'מצאו לי חיית מחמד',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(context, String message) {
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
        backgroundColor: Colors.brown,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
