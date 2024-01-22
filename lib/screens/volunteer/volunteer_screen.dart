import 'package:flutter/material.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Volunteer Screen'),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}