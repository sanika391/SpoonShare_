import 'package:flutter/material.dart';
import 'package:spoonshare/screens/ngo/volunteer/all_volunteers.dart';
import 'package:spoonshare/screens/ngo/volunteer/verify_volunteer.dart';
import 'package:spoonshare/screens/volunteer/volunteer_form.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';

class VolunteerManageScreen extends StatelessWidget {
  const VolunteerManageScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Management'),
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
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildVerifiedContent(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildVerifiedContent(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCard(
              context: context,
              title: 'Verify Volunteer',
              description: 'Verify volunteers for various activities.',
              icon: Icons.group_add,
              page: const verifyVolunteer(),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context: context,
              title: 'Add Volunteer',
              description: 'Add new volunteers to the list.',
              icon: Icons.people,
              page: const VolunteerFormScreen(),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context: context,
              title: 'See All Verified Volunteers',
              description: 'View all verified volunteers.',
              icon: Icons.people,
              page: const allVolunteer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required IconData icon,
    required BuildContext context,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 4,
        color: const Color(0xFFFF9F1C),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(icon),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'DM Sans',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
