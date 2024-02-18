import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as Codec;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart' as location;
import 'package:permission_handler/permission_handler.dart';
import 'package:spoonshare/screens/fooddetails/food_details.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';

class MapsWidget extends StatefulWidget {
  @override
  _MapsWidgetState createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  late GoogleMapController mapController;
  List<Marker> markers = [];
  location.LocationData? currentLocation;
  late BitmapDescriptor customMarkerIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    _requestLocationPermission();
  }

// Function to request location permissions
  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();

    if (status == PermissionStatus.granted) {
      _getCurrentLocation();
    } else if (status == PermissionStatus.denied) {
      print("Location permission denied");
    } else if (status == PermissionStatus.permanentlyDenied) {
      print("Location permission permanently denied");
      openAppSettings();
    }
  }

  // Function to get the current location
  Future<void> _getCurrentLocation() async {
    location.LocationData locationData =
        await location.Location().getLocation();
    setState(() {
      currentLocation = locationData;
    });
  }

  void _navigateToFoodDetails(BuildContext context, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailsScreen(data: data),
      ),
    );
  }

  // Function to load the custom marker icon
  Future<void> _loadCustomMarker() async {
    // Load the custom marker icon from assets
    Uint8List markerIcon =
        await getBytesFromAsset('assets/images/marker_icon.png', 100);
    customMarkerIcon = BitmapDescriptor.fromBytes(markerIcon);
  }

  void _initializeMap() {
    FirebaseFirestore.instance
        .collection('food')
        .doc('sharedfood')
        .collection('foodData')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        double lat = doc['lat'];
        double lng = doc['lng'];
        String venue = doc['venue'];

        // Create a default info window
        InfoWindow infoWindow = InfoWindow(
          title: venue,
          snippet: "click here for more details",
          onTap: () => _navigateToFoodDetails(
              context, doc.data() as Map<String, dynamic>),
        );

        // Create a marker with the default info window
        Marker marker = Marker(
          markerId: MarkerId('$lat,$lng'),
          position: LatLng(lat, lng),
          infoWindow: infoWindow,
          icon: customMarkerIcon,
        );

        // Add the marker to the markers list
        markers.add(marker);
      });

      // Update the UI to reflect the changes
      setState(() {});
    });
  }

  // Function to get bytes from asset
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec.Codec codec = await Codec.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: width);
    Codec.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: Codec.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation != null
          ? Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Map View Shared Food',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
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
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: MediaQuery.of(context).size.width - 16,
                    height: MediaQuery.of(context).size.height - 170,
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                        _initializeMap();
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          currentLocation!.latitude!,
                          currentLocation!.longitude!,
                        ),
                        zoom: 12.0,
                      ),
                      markers: Set<Marker>.of(markers),
                      myLocationEnabled:
                          true, // Enable the "My Location" button
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
