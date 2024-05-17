// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:spoonshare/screens/home/home.dart';
import 'package:spoonshare/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signUp({
    required String fullName,
    required String email,
    required String contactNumber,
    required String password,
    required String confirmPassword,
    String? profileImageUrl,
    String? role,
    String? organisation,
    BuildContext? context,
  }) async {
    if (!_isValidInput(fullName, 'Full Name', context) ||
        !_isValidInputEmail(email, context) ||
        !_isValidInputContactNumber(contactNumber, context) ||
        !_isValidInputPassword(password, context) ||
        !_arePasswordsMatching(password, confirmPassword, context)) {
      return;
    }

    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user details to Firestore
      if (userCredential.user != null) {
        // Save user details to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'fullName': fullName,
          'email': email,
          'contactNumber': contactNumber,
          'profileImageUrl': profileImageUrl ??
              "https://github.com/shuence/AdventureSquad/blob/main/user.png",
          'role': role ?? "Individual",
          'organisation': organisation ?? "",
        });

        // Save user details locally using SharedPreferences
        await _saveUserLocally(fullName, email, contactNumber,
            profileImageUrl ?? "", role ?? "Individual", organisation ?? "");

        // Show success message
        _showSuccessSnackbar(context, 'Signup successful');

        // Send email verification
        await userCredential.user!.sendEmailVerification();
      } else {
        // Handle the case where userCredential.user is null
        _showErrorSnackbar(context, 'Error: User data is null');
      }
    } catch (e) {
      // Show error message
      _showErrorSnackbar(context, "Error: $e");
    }
  }

  Future<void> signUpWithGoogle(BuildContext? context) async {
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

      // Fetch additional details from Google Sign-In
      String fullName = userCredential.user?.displayName ?? '';
      String email = userCredential.user?.email ?? '';
      String contactNumber = '';
      String profileImageUrl = userCredential.user?.photoURL ?? '';
      String? role;
      String? organisation;

      // Save user details to Firestore (modify as needed)
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'fullName': fullName,
        'email': email,
        'contactNumber': contactNumber,
        'profileImageUrl': profileImageUrl,
        'role': role ?? "Individual",
        'organisation': organisation ?? "",
      });
      await _saveUserLocally(fullName, email, contactNumber, profileImageUrl,
          role ?? "Individual", organisation ?? "");

      // Show success message
      _showSuccessSnackbar(context, 'Google Signup successful');

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

  Future<void> _saveUserLocally(
      String fullName,
      String email,
      String contactNumber,
      String profileImageUrl,
      String role,
      String organisation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fullName', fullName);
    prefs.setString('email', email);
    prefs.setString('contactNumber', contactNumber);
    prefs.setString('profileImageUrl', profileImageUrl);
    prefs.setString('role', role);
    prefs.setString('organisation', organisation);
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

  bool _isValidInput(String value, String field, BuildContext? context) {
    if (value.isEmpty) {
      _showErrorSnackbar(context, 'Invalid $field');
      return false;
    }
    return true;
  }

  bool _isValidInputEmail(String email, BuildContext? context) {
    if (!RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
        .hasMatch(email)) {
      _showErrorSnackbar(context, 'Invalid Email');
      return false;
    }
    return true;
  }

  bool _isValidInputContactNumber(String contactNumber, BuildContext? context) {
    if (contactNumber.isEmpty ||
        contactNumber.length != 10 ||
        !isNumeric(contactNumber)) {
      _showErrorSnackbar(context, 'Invalid Contact Number');
      return false;
    }
    return true;
  }

  bool isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }

  bool _isValidInputPassword(String password, BuildContext? context) {
    if (password.isEmpty || password.length < 6) {
      _showErrorSnackbar(context, 'Invalid Password');
      return false;
    }
    return true;
  }

  bool _arePasswordsMatching(
      String password, String confirmPassword, BuildContext? context) {
    if (password != confirmPassword) {
      _showErrorSnackbar(context, 'Passwords do not match');
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
