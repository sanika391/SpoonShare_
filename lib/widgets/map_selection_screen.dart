import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSelectionScreen extends StatefulWidget {
  const MapSelectionScreen({super.key});

  @override
  _MapSelectionScreenState createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    var location = Location();
    try {
      _currentLocation = await location.getLocation();
      if (_mapController != null) {
        _updateCameraPosition(_currentLocation!.latitude!, _currentLocation!.longitude!);
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _updateCameraPosition(double latitude, double longitude) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 12.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location on Map'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
            if (_currentLocation != null) {
              _updateCameraPosition(_currentLocation!.latitude!, _currentLocation!.longitude!);
            }
          });
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194), // Default location (San Francisco)
          zoom: 12.0,
        ),
        onTap: (LatLng location) {
          // Handle the tapped location
          Navigator.of(context).pop(location);
        },
      ),
    );
  }
}
