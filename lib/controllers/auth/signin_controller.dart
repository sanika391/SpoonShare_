// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:spoonshare/screens/home/home.dart';
import 'package:spoonshare/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signIn({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    if (!_isValidInputEmail(email, context) ||
        !_isValidInputPassword(password, context)) {
      return;
    }

    try {
      // Sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Check if email is verified

      /*  if (userCredential.user!.emailVerified) {
        _showSuccessSnackbar(context, 'Signup successful');
        // Navigate to the desired screen (e.g., Onboarding)
       
        }
        */
//else {

      /* If email is not verified, provide an option to resend the verification email
        _showEmailVerificationDialog(context);
      }*/
      // Load user details and save locally
      await _loadAndSaveUserLocally(userCredential.user!);

      // Show success message
      _showSuccessSnackbar(context, 'Signin successful');
    } catch (e) {
      // Show error message
      _showErrorSnackbar(context, "Error: $e");
    }
  }

  Future<void> signInWithGoogle(BuildContext? context) async {
    try {
      // Trigger Google Sign In
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        // Google sign-in canceled
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Sign in to Firebase with Google credentials
      final OAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(googleAuthCredential);

      // Load and save user details
      await _loadAndSaveUserLocally(userCredential.user!);

      // Show success message
      _showSuccessSnackbar(context, 'Google Signin successful');

      // You can navigate to the desired screen after successful signup
      Navigator.pushReplacement(
        context!,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } catch (e) {
      // Show error message
      _showErrorSnackbar(context, "Error: $e");
    }
  }

Future<void> _loadAndSaveUserLocally(User user) async {
  try {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    if (userDoc.exists) {
      String fullName = userDoc['fullName'];
      String contactNumber = userDoc['contactNumber'];
      String profileImageUrl = userDoc['profileImageUrl'];
      String role = userDoc['role'];
      String organisation = userDoc['organisation'];

      await _saveUserLocally(fullName, user.email!, contactNumber, role, profileImageUrl, organisation);
    } else {
      throw Exception("User document does not exist");
    }
  } catch (e) {
    throw Exception("Error loading user data from Firestore: $e");}
}

  Future<void> _saveUserLocally(
    String fullName, String email, String contactNumber, String role, String ProfileImageUrl, String organisation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fullName', fullName);
    prefs.setString('email', email);
    prefs.setString('contactNumber', contactNumber);
    prefs.setString('profileImageUrl', ProfileImageUrl);
    prefs.setString("role", role);
    prefs.setString("organisation", organisation);
  }

  void _showEmailVerificationDialog(BuildContext? context) {
    // Show a dialog with an option to resend the verification email
    showDialog(
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Verification'),
          content: const Text(
            'Please verify your email by clicking the verification link sent to your email address. If you haven\'t received the email, you can resend it.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Resend verification email
                await _auth.currentUser!.sendEmailVerification();
                Navigator.pop(context);
                _showSuccessSnackbar(context, 'Verification email resent');
              },
              child: const Text('Resend Email'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool _isValidInputEmail(String email, BuildContext? context) {
    if (!RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
        .hasMatch(email)) {
      _showErrorSnackbar(context, 'Invalid Email');
      return false;
    }
    return true;
  }

  bool _isValidInputPassword(String password, BuildContext? context) {
    if (password.isEmpty || password.length < 6) {
      _showErrorSnackbar(context, 'Invalid Password');
      return false;
    }
    return true;
  }

  void _showErrorSnackbar(BuildContext? context, String message) {
    if (context != null) {
      showErrorSnackbar(context, message);
    }
  }

  void _showSuccessSnackbar(BuildContext? context, String message) {
    if (context != null) {
      showSuccessSnackbar(context, message);
    }
  }
}
