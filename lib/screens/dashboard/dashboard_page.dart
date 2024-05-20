import 'package:flutter/material.dart';
import 'package:spoonshare/screens/ngo/ngo_form.dart';
import 'package:spoonshare/screens/volunteer/volunteer_form.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isShareFoodSelected = true;
  bool isDonateFoodSelected = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor =
        isDarkMode ? Colors.white70 : Colors.black.withOpacity(0.8);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 80,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: backgroundColor),
        child: SingleChildScrollView(
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
              const SizedBox(height: 32),
              SizedBox(
                width: 300,
                height: 69,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '“Join Spoon Share Family”',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 24,
                        fontFamily: 'Lora',
                        fontWeight: FontWeight.bold,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      width: 275,
                      child: Text(
                        'Volunteer with a Smile, Empower with Heart!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: secondaryTextColor,
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
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: 275,
                height: 140,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Share Food
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const VolunteerFormScreen(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 108,
                                height: 106,
                                decoration: const ShapeDecoration(
                                  color: Color(0xFFFF9F1C),
                                  shape: CircleBorder(),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Image.asset(
                                      "assets/images/volunteer.png"),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Become a Volunteer',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontFamily: 'Lora',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 27),
                        // Donate Food
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NGOFormScreen(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 108,
                                height: 106,
                                decoration: const ShapeDecoration(
                                  color: Color(0xFFFF9F1C),
                                  shape: CircleBorder(),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Image.asset("assets/images/ngo.png"),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Join us as NGO',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontFamily: 'Lora',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                width: 320,
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/dashboard.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
