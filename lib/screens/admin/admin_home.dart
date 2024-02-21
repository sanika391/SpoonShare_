// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:spoonshare/models/users/user.dart';
import 'package:spoonshare/screens/admin/ngo_management.dart';
import 'package:spoonshare/screens/admin/verify_donated_food.dart';
import 'package:spoonshare/screens/admin/verify_recycle_food.dart';
import 'package:spoonshare/screens/admin/verify_shared_food.dart';
import 'package:spoonshare/screens/profile/user_profile.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';
import 'package:spoonshare/widgets/snackbar.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String? fullName;
  String? email;
  String? contactNumber;
  String? role;
  String? organization;
  bool isLoading = true;

  // UserProfile instance
  final UserProfile _userProfile = UserProfile();

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      await _userProfile.loadUserProfile();
      role = _userProfile.getRole();
      fullName = _userProfile.getFullName();
      email = _userProfile.getEmail();
      contactNumber = _userProfile.getContactNumber();
      organization = _userProfile.getOrganisation();
    } catch (e) {
      showErrorSnackbar(context, 'Error fetching user profile: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildVerifiedContent(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildVerifiedContent() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello👋 $organization',
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lora',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      role ?? '',
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
            const SizedBox(height: 32),
            _buildCard(
              context: context,
              title: 'Verify Shared Free Food',
              description: 'Verify shared free food items from donors.',
              icon: Icons.fastfood,
              page: const VerifySharedFood(),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context: context,
              title: 'Verify Donated Free Food',
              description: 'Verify donated free food items from contributors.',
              icon: Icons.volunteer_activism,
              page: const VerifyDonatedFood(),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context: context,
              title: 'Verify Recycle Food',
              description: 'Verify Recycle food items for recycling.',
              icon: Icons.recycling,
              page: const VerifyRecycleFood(),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context: context,
              title: 'NGO Management',
              description: 'Manage NGO for various activities.',
              icon: Icons.group,
              page: const NGOManageScreen(),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context: context,
              title: 'Admin Information Management',
              description: 'Manage Admin information and profile.',
              icon: Icons.business,
              page: UserProfileScreen(
                name: fullName ?? '',
                role: 'Admin',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCard({
  required String title,
  required String description,
  required IconData icon,
  required BuildContext context, // Add context parameter
  required Widget page, // Add page parameter
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
