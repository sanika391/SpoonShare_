// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spoonshare/screens/admin/ngo_management.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';
import 'package:spoonshare/widgets/snackbar.dart';

class AllNGOScreen extends StatefulWidget {
  const AllNGOScreen({Key? key}) : super(key: key);

  @override
  _AllNGOScreenState createState() => _AllNGOScreenState();
}

class _AllNGOScreenState extends State<AllNGOScreen> {
  late Stream<QuerySnapshot> _ngoStream;

  @override
  void initState() {
    super.initState();
    _ngoStream = const Stream.empty();
    _initializengoStream();
  }

  void _initializengoStream() {
    _ngoStream = FirebaseFirestore.instance
        .collection('ngos')
        .where('verified', isEqualTo: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All NGO\s'),
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
        stream: _ngoStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          var ngoDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: ngoDocs.length,
            itemBuilder: (context, index) {
              Object? ngoData = ngoDocs[index].data();
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ngoDetailsPage(ngoDoc: ngoDocs[index]),
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
                      (ngoData as Map?)?['ngoName'] ?? 'No Venue',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      ngoData?['address'] ?? 'No Address',
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

class ngoDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot ngoDoc;

  const ngoDetailsPage({Key? key, required this.ngoDoc}) : super(key: key);

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
    Object? ngoData = ngoDoc.data();
    return Scaffold(
      appBar: AppBar(
        title: Text((ngoData as Map?)?['ngoName'] ?? 'No Venue'),
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
                        'NGO Name: ${ngoData!['ngoName'] ?? ''}',
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
                      'Email: ${ngoData['email'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Mobile: ${ngoData['mobileNo'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Type: ${ngoData['type'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Incorporation Day: ${formatBirthdayTimestamp(ngoData['incorporationDay'] ?? '')}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'linkedin/Instagram: ${ngoData['linkedin'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'address: ${ngoData['address'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () => _deletengo(ngoDoc, context),
                        child: const Text('Remove NGO'),
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

// Function to handle deletion logic
Future<void> _deletengo(DocumentSnapshot ngoDoc, BuildContext context) async {
  try {
    await FirebaseFirestore.instance.collection('ngos').doc(ngoDoc.id).delete();
    showSuccessSnackbar(context, 'ngo deleted successfully');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const NGOManageScreen(),
      ),
    );
  } catch (e) {
    showErrorSnackbar(context, 'Error deleting ngo');
  }
}
