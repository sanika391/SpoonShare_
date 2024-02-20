// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:spoonshare/controllers/auth/signup_controller.dart';
import 'package:spoonshare/screens/auth/signin.dart';
import 'package:spoonshare/screens/home/home.dart';
import 'package:spoonshare/widgets/loader.dart';
import 'package:spoonshare/widgets/snackbar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController _signUpController = SignUpController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  final SignUpController signUpController = SignUpController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height + 40,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 146,
                      padding: const EdgeInsets.only(
                        top: 4,
                      ),
                      decoration: const BoxDecoration(color: Color(0xFFFF9F1C)),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SpoonShare',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontFamily: 'Lora',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.12,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Nourishing Lives, Creating Smiles!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 275,
                  height: 69,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Join the movement!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Lora',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        width: 275,
                        child: Text(
                          'Explore nearby food or join us to make a difference!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.800000011920929),
                            fontSize: 14,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 218,
                  height: 38,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      signUpController.signUpWithGoogle(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/google.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'CONTINUE WITH GOOGLE',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 296,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: 12,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputField(
                      label: 'Full Name',
                      controller: _fullNameController,
                    ),
                    const SizedBox(height: 16),
                    InputField(label: 'Email', controller: _emailController),
                    const SizedBox(height: 16),
                    InputField(
                        label: 'Contact Number',
                        controller: _contactNumberController),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Password',
                      isPassword: true,
                      controller: _passwordController,
                      isPasswordVisible: _isPasswordVisible,
                      togglePasswordVisibility: () {
                        _togglePasswordVisibility();
                      },
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Confirm Password',
                      isPassword: true,
                      controller: _confirmPasswordController,
                      isPasswordVisible: _isConfirmPasswordVisible,
                      togglePasswordVisibility: () {
                        _toggleConfirmPasswordVisibility();
                      },
                    ),
                  ],
                ),
                Container(
                  margin:
                      const EdgeInsets.only(top: 10), // Add margin to the top
                  child: SizedBox(
                    width: 296,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'By signing up, you confirm that you have read and agreed to SpoopShare’s ',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 11,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          const TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                              height: 0,
                            ),
                          ),
                          TextSpan(
                            text: ' & ',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 11,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          const TextSpan(
                            text: 'Terms',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 20.0), // Adjust the top margin as needed
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SignInScreen()), // Replace LoginScreen with the actual screen you want to navigate to
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an account?',
                            style: TextStyle(
                              color:
                                  Colors.black.withOpacity(0.699999988079071),
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                          const TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                          const TextSpan(
                            text: 'Log in',
                            style: TextStyle(
                              color: Color(0xFFFF9F1C),
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Show loading indicator
                    showLoadingDialog(context);

                    try {
                      // Perform signup asynchronously
                      await _signUpController.signUp(
                        fullName: _fullNameController.text,
                        email: _emailController.text,
                        contactNumber: _contactNumberController.text,
                        password: _passwordController.text,
                        confirmPassword: _confirmPasswordController.text,
                        context: context,
                      );

                      // Hide loading indicator
                      Navigator.of(context).pop(); // Pop the loading dialog

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    } catch (e) {
                      // Handle any exceptions during signup
                      print("Signup failed: $e");

                      // Hide loading indicator
                      Navigator.of(context).pop(); // Pop the loading dialog

                      // You can customize this part based on your requirements
                      showErrorSnackbar(
                          context, 'Signup failed. Please try again.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9F1C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const SizedBox(
                    width: 312,
                    height: 45,
                    child: Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.36,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }
}

class InputField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;
  final bool? isPasswordVisible;
  final VoidCallback? togglePasswordVisibility;

  const InputField({
    Key? key,
    required this.label,
    this.isPassword = false,
    required this.controller,
    this.isPasswordVisible,
    this.togglePasswordVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: const Color(0x4CFF9F1C),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword && isPasswordVisible != true,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: Colors.black.withOpacity(0.38),
                  fontSize: 14,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                  leadingDistribution: TextLeadingDistribution.even,
                  letterSpacing: 1.2,
                ),
                border: InputBorder.none,
                suffixIcon: isPassword && togglePasswordVisibility != null
                    ? IconButton(
                        icon: Icon(
                          isPasswordVisible!
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: togglePasswordVisibility,
                      )
                    : null,
              ),
            ),
          ),
          const Text(
            '*', // Asterisk symbol
            style: TextStyle(
              color: Color(0x99F20F0F),
              fontSize: 14,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
