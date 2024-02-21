// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:spoonshare/screens/auth/signin.dart';
import 'package:spoonshare/services/forgot_password.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';
import 'package:spoonshare/widgets/loader.dart';
import 'package:spoonshare/widgets/snackbar.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ForgotPasswordService _forgotPasswordService = ForgotPasswordService();
  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordScreen({Key? key}) : super(key: key);

  void _onSubmitClick(BuildContext context) async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      showErrorSnackbar(context, 'Please enter your email.');
      return;
    }
    RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );

    if (!emailRegex.hasMatch(email)) {
      showErrorSnackbar(context, 'Please enter a valid email.');
      return;
    }

    try {
      showLoadingDialog(context);
      await _forgotPasswordService.resetPassword(email);
      showSuccessSnackbar(context, 'Password reset email sent successfully.');
    } catch (e) {
      showErrorSnackbar(context, ('Error: $e'));
    } finally {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: const Color(0xFFFF9F1C),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'DM Sans',
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 40,
          margin: const EdgeInsets.all(40.0),
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Reset your password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  letterSpacing: -0.53,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter your registered email below',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  letterSpacing: -0.29,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 55,
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                ),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 57,
                decoration: const ShapeDecoration(
                  color: Color(0xFFFBDE3F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () => _onSubmitClick(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFFBDE3F), // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        letterSpacing: -0.37,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 215,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Remember the password? ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                            letterSpacing: -0.29,
                          ),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            height: 1.2,
                            letterSpacing: -0.29,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
