import 'package:flutter/material.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';

class PickupFoodScreen extends StatelessWidget {
  const PickupFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pickup Food"),
        backgroundColor: Colors.orange,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.bold,
        ),
      ),
      body: const Center(
        child: Text("Pickup Food"),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}