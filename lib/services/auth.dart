// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoonshare/screens/auth/signin.dart';
import 'package:spoonshare/widgets/snackbar.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if the user is authenticated
  Future<bool> isAuthenticated() async {
    return _auth.currentUser != null;
  }

  // Sign out the user
  Future<void> signOut(BuildContext context) async {
    try {
      await _clearLocalUserData();
      await _auth.signOut();

      showSuccessSnackbar(context, "Sign Out Successful");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    } catch (e) {
      print('Error during logout: $e');
      showErrorSnackbar(context, "Sign Out Failed");
    }
  }

  // Clear local user data from shared preferences
  Future<void> _clearLocalUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
