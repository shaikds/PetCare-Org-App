import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login/model/Pet.dart';
import 'package:flutter_login/view/ManagerScreen.dart';
import 'package:flutter_login/viewmodel/PetsViewModel.dart'; // Import the Pet model class

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onTap;

  const PetCard({super.key, required this.pet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManagerScreen(pet: pet)),
          );
        }
      },
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(
            top: 10.0, right: 4.0, left: 4.0, bottom: 2.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                pet.photos!.first,
                // Replace this with the actual URL of the pet's photo
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${pet.gender}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${pet.age / 2}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${pet.size}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
