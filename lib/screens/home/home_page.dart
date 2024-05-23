import 'package:flutter/material.dart';
import 'package:spoonshare/screens/dashboard/dashboard_home.dart';
import 'package:spoonshare/screens/donate/donate_page.dart';
import 'package:spoonshare/screens/home/initial_home_content.dart';
import 'package:spoonshare/screens/profile/user_profile.dart';
import 'package:spoonshare/screens/recycle/recycle.dart';
import 'package:spoonshare/widgets/maps_widget.dart';

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

  late final List<Widget> _widgetOptions = <Widget>[
    InitialHomeContent(name: widget.name, role: widget.role),
    DashboardHomePage(role: widget.role),
    const DonatePage(),
    const RecycleScreen(),
    UserProfileScreen(name: widget.name, role: widget.role)
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home,color: Color(0xFFFF9F1C),), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard,color: Color(0xFFFF9F1C),), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle,color: Color(0xFFFF9F1C),), label: 'Donate'),
          BottomNavigationBarItem(icon: Icon(Icons.recycling,color: Colors.green,), label: 'Recycle'),
          BottomNavigationBarItem(icon: Icon(Icons.person,color: Color(0xFFFF9F1C),), label: 'Profile'),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped, 
        selectedIconTheme: const IconThemeData(color: Color(0xFFFF9F1C)),
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color.fromARGB(255, 71, 69, 69),
        unselectedItemColor: const Color.fromARGB(255, 71, 69, 69),
        showUnselectedLabels: true,
      ),
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
