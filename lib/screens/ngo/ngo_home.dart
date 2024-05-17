// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoonshare/screens/ngo/ngo_information.dart';
import 'package:spoonshare/screens/ngo/verify_donated_food.dart';
import 'package:spoonshare/screens/ngo/verify_shared_food.dart';
import 'package:spoonshare/screens/ngo/volunteer_management.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';
import 'package:spoonshare/widgets/snackbar.dart';

class NGOHomeScreen extends StatefulWidget {
  const NGOHomeScreen({Key? key}) : super(key: key);

  @override
  State<NGOHomeScreen> createState() => _NGOHomeScreenState();
}

class _NGOHomeScreenState extends State<NGOHomeScreen> {
  String? organization;
  String? role;
  bool isLoading = true;
  bool isVerified = false;
  Map<String, dynamic>? ngoData;

  @override
  void initState() {
    super.initState();
    fetchOrganization();
  }

  Future<void> fetchOrganization() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      organization = prefs.getString('organisation');
      role = prefs.getString('role');
      if (organization != null) {
        await checkVerificationStatus(organization!);
        if (!isVerified) {
          await fetchNGOData(organization!);
        }
      }
    } catch (e) {
      showErrorSnackbar(context, 'Error fetching organization: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> checkVerificationStatus(String organization) async {
    try {
      CollectionReference<Map<String, dynamic>> ngosCollection =
          FirebaseFirestore.instance.collection('ngos');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await ngosCollection.where('ngoName', isEqualTo: organization).get();

      if (querySnapshot.docs.isNotEmpty) {
        isVerified = querySnapshot.docs.first['verified'] ?? false;
      }
    } catch (e) {
      showErrorSnackbar(context, "Error checking verification status: $e");
    }
  }

  Future<void> fetchNGOData(String organization) async {
    try {
      CollectionReference<Map<String, dynamic>> ngosCollection =
          FirebaseFirestore.instance.collection('ngos');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await ngosCollection.where('ngoName', isEqualTo: organization).get();

      if (querySnapshot.docs.isNotEmpty) {
        ngoData = querySnapshot.docs.first.data();
      }
    } catch (e) {
      showErrorSnackbar(context, "Error fetching NGO data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isVerified
              ? SingleChildScrollView(
                  child: _buildVerifiedContent(),
                )
              : _buildUnverifiedContent(),
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
              title: 'Volunteer Management',
              description: 'Manage volunteers for various activities.',
              icon: Icons.group,
              page: const VolunteerManageScreen(),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context: context,
              title: 'NGO Information Management',
              description: 'Manage NGO information and profile.',
              icon: Icons.business,
              page: const NGOProfileScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnverifiedContent() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
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
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Colors.black12,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            ),
            if (ngoData != null)
              Container(
                padding: const EdgeInsets.only(
                    top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
                height: 320,
                width: 360,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NGO Name: ${ngoData!['ngoName']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mobile No: ${ngoData!['mobileNo']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Email: ${ngoData!['email']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Description: ${ngoData!['description']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Address: ${ngoData!['address']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'LinkedIn: ${ngoData!['linkedin']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        if (!isVerified) const SizedBox(height: 4),
                        const Text(
                          'Please wait until you get verified',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
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
