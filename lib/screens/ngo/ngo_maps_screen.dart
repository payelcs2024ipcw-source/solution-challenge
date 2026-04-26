import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NgoMapScreen extends StatefulWidget {
  const NgoMapScreen({super.key});

  @override
  State<NgoMapScreen> createState() => _NgoMapScreenState();
}

class _NgoMapScreenState extends State<NgoMapScreen> {
  Set<Marker> markers = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNeedsOnMap();
  }

  Future<void> loadNeedsOnMap() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('community_needs')
          .get();

      final newMarkers = <Marker>{};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final lat = data['latitude'] ?? 28.6139;
        final lng = data['longitude'] ?? 77.2090;

        newMarkers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: data['category'] ?? 'Need',
              snippet: data['description'] ?? '',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              data['urgency'] == 'high'
                  ? BitmapDescriptor.hueRed
                  : data['urgency'] == 'medium'
                      ? BitmapDescriptor.hueOrange
                      : BitmapDescriptor.hueGreen,
            ),
          ),
        );
      }

      // Add sample markers if Firestore empty
      if (true) {
        newMarkers.addAll([
          Marker(
            markerId: const MarkerId('sample1'),
            position: const LatLng(28.7041, 77.1025),
            infoWindow: const InfoWindow(
              title: 'Medical Need',
              snippet: 'North Delhi — HIGH urgency',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
          Marker(
            markerId: const MarkerId('sample2'),
            position: const LatLng(28.5245, 77.1855),
            infoWindow: const InfoWindow(
              title: 'Education Need',
              snippet: 'South Delhi — MEDIUM urgency',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            ),
          ),
          Marker(
            markerId: const MarkerId('sample3'),
            position: const LatLng(28.6562, 77.3410),
            infoWindow: const InfoWindow(
              title: 'Food Need',
              snippet: 'East Delhi — HIGH urgency',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        ]);
      }

      setState(() {
        markers = newMarkers;
        isLoading = false;
      });
    } catch (e) {
      print('Map error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Needs Map'),
        backgroundColor: const Color(0xFF534AB7),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(28.6139, 77.2090),
              zoom: 11,
            ),
            markers: markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(children: [
                    Icon(Icons.location_on, color: Colors.red, size: 16),
                    SizedBox(width: 4),
                    Text('High', style: TextStyle(fontSize: 12)),
                  ]),
                  Row(children: [
                    Icon(Icons.location_on, color: Colors.orange, size: 16),
                    SizedBox(width: 4),
                    Text('Medium', style: TextStyle(fontSize: 12)),
                  ]),
                  Row(children: [
                    Icon(Icons.location_on, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text('Low', style: TextStyle(fontSize: 12)),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}