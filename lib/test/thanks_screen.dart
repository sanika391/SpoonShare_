import 'package:flutter/material.dart';

class ThanksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/thankubg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/pan_image.png', // Path to the pan image
                  width: 250,
                  height: 200,
                  // You can adjust width and height as needed
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Thank you For Donating',
                  style: TextStyle(
                    color: Color(0xFFFF725E),
                    fontSize: 28,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.64,
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

