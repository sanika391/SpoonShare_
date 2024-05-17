// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:spoonshare/screens/home/home_page.dart';
import 'package:spoonshare/models/users/user.dart';
import 'package:spoonshare/onboarding.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProfile userProfile = UserProfile();

    return FutureBuilder<void>(
      future: userProfile.loadUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!userProfile.isAuthenticated()) {
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Onboarding()),
              );
            });
          }

          String name = userProfile.getFullName();
          String role = userProfile.getRole();

          return userProfile.isAuthenticated()
              ? Scaffold(
                  body: Center(
                    child: HomePage(name: name, role: role),
                  ),
                )
              : Container();
        } else {
          // Request location permissions
          _requestLocationPermissions(context);

          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.symmetric(horizontal: 77),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(color: Color(0xFFFF9F1C)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 130,
                                height: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/spoonshare.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'SpoonShare',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'Lora',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.96,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Nourishing Lives, Creating Smiles!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  // Function to request location permissions
  Future<void> _requestLocationPermissions(BuildContext context) async {
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus.isDenied) {
      // Handle case where user denies location permissions
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location Permission Required'),
            content: const Text(
                'This app requires access to your location in order to function properly.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => openAppSettings(),
                child: const Text('Settings'),
              ),
            ],
          );
        },
      );
    }
  }
}
