// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';
import 'package:spoonshare/widgets/snackbar.dart';

class VerifySharedFood extends StatefulWidget {
  const VerifySharedFood({Key? key}) : super(key: key);

  @override
  _VerifySharedFoodState createState() => _VerifySharedFoodState();
}

class _VerifySharedFoodState extends State<VerifySharedFood> {
  late Stream<QuerySnapshot> _foodStream;

  @override
  void initState() {
    super.initState();
    _foodStream = const Stream.empty();
    _initializeFoodStream();
  }

  void _initializeFoodStream() {
    _foodStream = FirebaseFirestore.instance
        .collection('food')
        .doc('sharedfood')
        .collection('foodData')
        .where('verified', isEqualTo: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Shared Free Food'),
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
      body: FutureBuilder<Position>(
        future: Geolocator.getCurrentPosition(),
        builder: (context, positionSnapshot) {
          if (positionSnapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          } else if (positionSnapshot.hasError) {
            return Text('Error: ${positionSnapshot.error}');
          }

          Position userLocation = positionSnapshot.data!;

          return StreamBuilder<QuerySnapshot>(
            stream: _foodStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              var foodDocs = snapshot.data!.docs;
     
              // Sort the food documents based on distance
              foodDocs.sort((a, b) {
                GeoPoint foodALocation = a['location'];
                GeoPoint foodBLocation = b['location'];

                double distanceA = Geolocator.distanceBetween(
                  userLocation.latitude,
                  userLocation.longitude,
                  foodALocation.latitude,
                  foodALocation.longitude,
                );

                double distanceB = Geolocator.distanceBetween(
                  userLocation.latitude,
                  userLocation.longitude,
                  foodBLocation.latitude,
                  foodBLocation.longitude,
                );

                return distanceA.compareTo(distanceB);
              });

              return ListView.builder(
                itemCount: foodDocs.length,
                itemBuilder: (context, index) {
                  Object? foodData = foodDocs[index].data();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FoodDetailsPage(foodDoc: foodDocs[index]),
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
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              (foodData as Map?)?['imageUrl'] ?? ''),
                          radius: 30,
                        ),
                        title: Text(
                          (foodData)?['venue'] ?? 'No Venue',
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'DM Sans',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          foodData?['address'] ?? 'No Address',
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
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class FoodDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot foodDoc;

  const FoodDetailsPage({Key? key, required this.foodDoc}) : super(key: key);

  String _formatDate(String date) {
    final inputFormat = DateFormat('yyyy-MM-dd');
    final outputFormat = DateFormat('dd-MM-yyyy');
    final formattedDate = outputFormat.format(inputFormat.parse(date));
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    Object? foodData = foodDoc.data();
    return Scaffold(
      appBar: AppBar(
        title: Text((foodData as Map?)?['venue'] ?? 'No Venue'),
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
          children: [
            Container(
              width: double.infinity,
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
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    )),
                    child: Image.network(
                      foodData!['imageUrl'] ?? '',
                      height: 250,
                      width: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Venue: ${foodData['venue'] ?? ''}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Uploaded By: ${foodData['fullName'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Location: ${foodData['address'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Community: ${foodData['community'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Food Type: ${foodData['foodType'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  if (foodData['dailyActive'] ?? false)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Availability: Daily',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      border: TableBorder.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: _buildCell('From'),
                            ),
                            TableCell(
                              child: _buildCell('To'),
                            ),
                          ],
                        ),
                        if (!(foodData['dailyActive'] ?? false))
                          TableRow(
                            children: [
                              TableCell(
                                child: _buildCell(
                                    _formatDate('${foodData['date'] ?? ''}')),
                              ),
                              TableCell(
                                child: _buildCell(
                                    _formatDate('${foodData['toDate'] ?? ''}')),
                              ),
                            ],
                          ),
                        TableRow(
                          children: [
                            TableCell(
                              child: _buildCell('${foodData['time'] ?? ''}'),
                            ),
                            TableCell(
                              child: _buildCell('${foodData['toTime'] ?? ''}'),
                            ),
                          ],
                        ),
                      ],
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
                        onPressed: () => _verifyFood(foodDoc, context),
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
                        onPressed: () => _deleteFood(foodDoc, context),
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
Future<void> _verifyFood(DocumentSnapshot foodDoc, BuildContext context) async {
  try {
    await FirebaseFirestore.instance
        .collection('food')
        .doc('sharedfood')
        .collection('foodData')
        .doc(foodDoc.id)
        .update({'verified': true});
    showSuccessSnackbar(context, 'Food verified successfully');
    Navigator.pop(context);
  } catch (e) {
    showErrorSnackbar(context, 'Error verifying food');
  }
}

// Function to handle deletion logic
Future<void> _deleteFood(DocumentSnapshot foodDoc, BuildContext context) async {
  try {
    await FirebaseFirestore.instance
        .collection('food')
        .doc('sharedfood')
        .collection('foodData')
        .doc(foodDoc.id)
        .delete();
    showSuccessSnackbar(context, 'Food deleted successfully');
    Navigator.pop(context);
  } catch (e) {
    showErrorSnackbar(context, 'Error deleting food');
  }
}

Widget _buildCell(String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
