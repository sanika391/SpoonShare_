import 'package:flutter/material.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                // Add onTap functionality
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {
                // Add onTap functionality
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.library_books),
              title: const Text('Terms & Conditions'),
              onTap: () {
                // Add onTap functionality
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report Problem'),
              onTap: () {
                // Add onTap functionality
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Log out'),
              onTap: () {
                // Add onTap functionality
              },
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Container(
              width: double.infinity,
              height: 69,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 8,
                    offset: Offset(0, -4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}