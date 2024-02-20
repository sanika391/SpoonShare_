import 'package:flutter/material.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';

class NGOProfileScreen extends StatelessWidget {
  const NGOProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NGO Profile Screen"),
        backgroundColor: Colors.orange,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.bold,
        ),
      ),
      body: const Center(
        child: Text("NGO Profile Screen"),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
