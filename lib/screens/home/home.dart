import 'package:flutter/material.dart';
import 'package:spoonshare/screens/home/home_page.dart';
import 'package:spoonshare/models/users/user.dart';
import 'package:spoonshare/screens/onboarding.dart';
import 'package:spoonshare/widgets/random_quotes.dart';

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
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/spoonshare_launcher.png',
                      width: 150, height: 150),
                  const SizedBox(height: 20),
                  Text(
                    'Food Sharing Quote: ${RandomQuotes.getRandomFoodSharingQuote()}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
