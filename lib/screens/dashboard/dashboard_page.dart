import 'package:flutter/material.dart';
import 'package:spoonshare/screens/ngo/ngo_form.dart';
import 'package:spoonshare/screens/volunteer/volunteer_form.dart';

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: height/4,
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
          
              SizedBox(height: width/10),
          
              SizedBox(
                width: width,
                height: height/12,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '“Join Spoon Share Family”',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Lora',
                        fontWeight: FontWeight.bold,
                        height: 0,
                      ),
                    ),
          
                    const SizedBox(height: 5,),
          
                    SizedBox(
                      width: width,
                      child: Text(
                        'Volunteer with a Smile, Empower with Heart!',
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
          
              SizedBox(
                height: width/18,
              ),
          
              SizedBox(
                width: height,
                height: 140,
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Share Food
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const VolunteerFormScreen(),
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
                                const Text(
                                  'Become a Volunteer',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Lora',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(width: 27),
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
                                const Text(
                                  'Join us as NGO',
                                  style: TextStyle(
                                    color: Colors.black,
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
              ),
              const SizedBox(
                height: 14,
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
    );
  }
}