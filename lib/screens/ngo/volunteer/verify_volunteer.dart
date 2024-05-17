// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spoonshare/screens/ngo/volunteer_management.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';
import 'package:spoonshare/widgets/snackbar.dart';

class verifyVolunteer extends StatefulWidget {
  const verifyVolunteer({Key? key}) : super(key: key);

  @override
  _verifyVolunteerState createState() => _verifyVolunteerState();
}

class _verifyVolunteerState extends State<verifyVolunteer> {
  late Stream<QuerySnapshot> _volunteerStream;

  @override
  void initState() {
    super.initState();
    _volunteerStream = const Stream.empty();
    _initializevolunteerStream();
  }

  void _initializevolunteerStream() {
    _volunteerStream = FirebaseFirestore.instance
        .collection('volunteers')
        .where('verified', isEqualTo: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Volunteer'),
        backgroundColor: const Color(0xFFFF9F1C),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'DM Sans',
            fontSize: 18,
            fontWeight: FontWeight.w700),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _volunteerStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          var volunteerDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: volunteerDocs.length,
            itemBuilder: (context, index) {
              Object? volunteerData = volunteerDocs[index].data();
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => volunteerDetailsPage(
                          volunteerDoc: volunteerDocs[index]),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  color: const Color(0xFFFF9F1C),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      (volunteerData as Map?)?['fullName'] ?? 'No Venue',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      volunteerData?['address'] ?? 'No Address',
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'DM Sans',
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class volunteerDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot volunteerDoc;

  const volunteerDetailsPage({Key? key, required this.volunteerDoc})
      : super(key: key);

  String formatBirthdayTimestamp(Timestamp birthdayTimestamp) {
    // Convert Firestore Timestamp to DateTime
    DateTime birthday = birthdayTimestamp.toDate();

    // Format the DateTime object to the desired date format
    String formattedBirthday =
        '${birthday.day}/${birthday.month}/${birthday.year}';

    return formattedBirthday;
  }

  @override
  Widget build(BuildContext context) {
    Object? volunteerData = volunteerDoc.data();
    return Scaffold(
      appBar: AppBar(
        title: Text((volunteerData as Map?)?['fullName'] ?? 'No Venue'),
        backgroundColor: const Color(0xFFFF9F1C),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'DM Sans',
            fontSize: 18,
            fontWeight: FontWeight.w700),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 500,
              margin: const EdgeInsets.symmetric(vertical: 40),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color: Colors.black.withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 20),
                      child: Text(
                        'FullName: ${volunteerData!['fullName'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Email: ${volunteerData['email'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Mobile: ${volunteerData['mobileNo'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Gender: ${volunteerData['gender'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Birthday: ${formatBirthdayTimestamp(volunteerData['birthday'] ?? '')}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Occupation: ${volunteerData['occupation'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'linkedin/Instagram: ${volunteerData['linkedin'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'address: ${volunteerData['address'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () =>
                            _verifyvolunteer(volunteerDoc, context),
                        child: const Text('Verify'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () =>
                            _deletevolunteer(volunteerDoc, context),
                        child: const Text('Don\'t Verify'),
                      ),
                    ],
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

// Function to handle verification logic
Future<void> _verifyvolunteer(
    DocumentSnapshot volunteerDoc, BuildContext context) async {
  try {
    await FirebaseFirestore.instance
        .collection('volunteers')
        .doc(volunteerDoc.id)
        .update({'verified': true});
    showSuccessSnackbar(context, 'volunteer verified successfully');
   Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const VolunteerManageScreen(),
        ),
      );  } catch (e) {
    showErrorSnackbar(context, 'Error verifying volunteer');
  }
}

// Function to handle deletion logic
Future<void> _deletevolunteer(
    DocumentSnapshot volunteerDoc, BuildContext context) async {
  try {
    await FirebaseFirestore.instance
        .collection('volunteers')
        .doc(volunteerDoc.id)
        .delete();
    showSuccessSnackbar(context, 'volunteer deleted successfully');
    Navigator.pop(context);
  } catch (e) {
    showErrorSnackbar(context, 'Error deleting volunteer');
  }
}
