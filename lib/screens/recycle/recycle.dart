import 'package:flutter/material.dart';
import 'package:spoonshare/screens/recycle/pickup_food.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';

class RecycleScreen extends StatelessWidget {
  const RecycleScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recycle Food ♻',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Lora',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: ShapeDecoration(
                            color: Colors.black.withOpacity(0.08),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 42,
                          height: 42,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFF9F1C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.notifications),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 298,
                        height: 179,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/recycle.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const SizedBox(
                        width: 282,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'The Most Reliable & Efficient ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Lora',
                                  fontWeight: FontWeight.bold,
                                  height: 0,
                                ),
                              ),
                              TextSpan(
                                text: 'Waste Disposal Service',
                                style: TextStyle(
                                  color: Color(0xFF06D801),
                                  fontSize: 32,
                                  fontFamily: 'Lora',
                                  fontWeight: FontWeight.bold,
                                  height: 0,
                                ),
                              ),
                              TextSpan(
                                text: '.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Lora',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const SizedBox(
                        width: 282,
                        child: Text(
                          'We are committed to providing you with the best waste disposal service. We are reliable, efficient and always on time.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 1.50,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const RecycleFoodScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 200,
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: ShapeDecoration(
                            color: const Color(0xFF06D801),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'REQUEST PICKUP',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                  letterSpacing: 1.95,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
