import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class OfflineBranchesScreen extends StatefulWidget {
  const OfflineBranchesScreen({super.key});

  @override
  State<OfflineBranchesScreen> createState() => _OfflineBranchesScreenState();
}

class _OfflineBranchesScreenState extends State<OfflineBranchesScreen> {
  Position? _currentPosition;

  // Branch locations (random places in Bangladesh)
  final List<LatLng> branches = [
    LatLng(23.8103, 90.4125), // Dhaka
    LatLng(22.3569, 91.7832), // Chittagong
    LatLng(24.8777, 91.8849), // Sylhet
    LatLng(23.7261, 90.3950), // Narayanganj
    LatLng(22.0046, 89.2187), // Khulna
    LatLng(24.3641, 88.6241), // Rajshahi
    LatLng(23.1992, 89.2412), // Barishal
    LatLng(23.1713, 91.7353), // Comilla
    LatLng(23.8820, 91.2840), // Cox's Bazar
    LatLng(24.3694, 88.6310), // Bogura
  ];

  // Get current location
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Branches'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to settings page
          },
        ),
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          initialZoom: 10.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
              ),
              ...branches.map((location) => Marker(
                width: 80.0,
                height: 80.0,
                point: location,
                child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
              )).toList(),
            ],
          ),
        ],
      ),
    );
  }
}