import 'package:flutter/material.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class FoodDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const FoodDetailsScreen({required this.data, Key? key}) : super(key: key);

  Future<void> _launchMaps(String location) async {
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$location',
    );
    await launchUrl(uri);
  }

  String _formatDate(String date) {
    final inputFormat = DateFormat('yyyy-MM-dd');
    final outputFormat = DateFormat('dd-MM-yyyy');
    final formattedDate = outputFormat.format(inputFormat.parse(date));
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Food Details:',
        ),
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
            Padding(
              padding: const EdgeInsets.all(0),
              child: Text(
                '${data['venue'] ?? ''}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Colors.black.withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                      data['imageUrl'] ?? '',
                      height: 250,
                      width: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Venue: ${data['venue'] ?? ''}',
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
                      'Uploaded By: ${data['fullName'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Location: ${data['address'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Community: ${data['community'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Food Type: ${data['foodType'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  if (data['dailyActive'] ?? false)
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
                        if (!(data['dailyActive'] ?? false))
                          TableRow(
                            children: [
                              TableCell(
                                child: _buildCell(
                                    _formatDate('${data['date'] ?? ''}')),
                              ),
                              TableCell(
                                child: _buildCell(
                                    _formatDate('${data['toDate'] ?? ''}')),
                              ),
                            ],
                          ),
                        TableRow(
                          children: [
                            TableCell(
                              child: _buildCell('${data['time'] ?? ''}'),
                            ),
                            TableCell(
                              child: _buildCell('${data['toTime'] ?? ''}'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ElevatedButton(
                      onPressed: () => _launchMaps(data['address']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9F1C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Get Directions'),
                    ),
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
}
