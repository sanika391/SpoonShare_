import 'package:flutter/material.dart';
import 'package:spoonshare/models/users/user.dart';
import 'package:spoonshare/screens/chat/chat_page.dart';
import 'package:spoonshare/screens/donate/donate_page.dart';
import 'package:spoonshare/screens/home/home_page.dart';
import 'package:spoonshare/screens/jobs/job_page.dart';
import 'package:spoonshare/screens/profile/user_profile.dart';
import 'package:spoonshare/widgets/maps_widget.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProfile userProfile = UserProfile();
    final String name = userProfile.getFullName();
    final String role = userProfile.getRole();

    return Container(
      width: double.infinity,
      height: 67,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F3).withOpacity(0.5),
        border: Border.all(color: const Color(0xFFF0F2F3)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.home, 'Home', Colors.black54,
              Colors.black54, HomePage(name: name, role: role)),
          _buildNavItem(context, Icons.map, 'Map', Colors.black54,
              Colors.black54, MapsWidget()),
          _buildNavItem(context, Icons.add_circle, 'Donate Food',
              Colors.black54, Colors.black54, const DonatePage()),
          _buildNavItem(context, Icons.work, 'Jobs', Colors.black54,
              Colors.black54, const JobPage()),
          _buildNavItem(
              context,
              Icons.person,
              'Profile',
              Colors.black54,
              Colors.black54,
              UserProfileScreen(
                name: name,
                role: role,
              )),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label,
      Color iconColor, Color textColor, Widget destination) {
    bool isSelected = ModalRoute.of(context)?.settings.name == label;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (isSelected) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    destination,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOutQuart;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                      position: offsetAnimation, child: child);
                },
              ),
            );
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: Colors.black,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
