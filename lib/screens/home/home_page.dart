import 'package:flutter/material.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';
import 'package:spoonshare/widgets/maps_widget.dart';
import 'package:spoonshare/widgets/nearby_daily_card.dart';
import 'package:spoonshare/widgets/nearby_food_cards.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.name, required this.role})
      : super(key: key);
  final String name;
  final String role;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello👋 ${widget.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Lora',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.role,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 16,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: 1.68,
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
                    borderRadius:
                        BorderRadius.circular(15), // Added border radius
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 0; // Update selected index
                      });
                    },
                    child: Text(
                      'RECENTLY UPLOADED',
                      style: TextStyle(
                        color: selectedIndex == 0
                            ? Colors.black
                            : Colors.black.withOpacity(0.6),
                        fontSize: 14,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: 0.60,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 1; // Update selected index
                      });
                    },
                    child: Text(
                      'DAILY ACTIVE',
                      style: TextStyle(
                        color: selectedIndex == 1
                            ? Colors.black
                            : Colors.black.withOpacity(0.6),
                        fontSize: 14,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: 0.60,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 1, // Adjust the height of the line as needed
                      color: selectedIndex == 0
                          ? const Color(0xFFFF9F1C)
                          : const Color(0x28FF9F1C),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 1, // Adjust the height of the line as needed
                      color: selectedIndex == 1
                          ? const Color.fromARGB(255, 201, 141, 58)
                          : const Color(0x28FF9F1C),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: selectedIndex == 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Near By Available Foods',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: selectedIndex == 0,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    NearbyFoodCard(),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              Visibility(
                visible: selectedIndex != 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Visibility(
                      visible: selectedIndex == 1,
                      child: const NearbyDailyFoodCard(
                        dailyActive: true,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MapsWidget()));
        },
        backgroundColor: const Color(0xFFFF9F1C),
        foregroundColor: Colors.white,
        child: const Icon(Icons.location_on),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
