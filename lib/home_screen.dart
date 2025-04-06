import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(23.810331, 90.412521),
    zoom: 12,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(23.810331, 90.412521),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  List<Marker> markerList = [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(23.8103, 90.4125),
      infoWindow: InfoWindow(
        title: 'Dhaka City Center'
      )
    ),
    Marker(
      markerId: MarkerId('2'),
      position: LatLng(23.7461, 90.3896),
        infoWindow: InfoWindow(
            title: 'Lalbagh Fort'
        )
    ),
    Marker(
      markerId: MarkerId('3'),
      position: LatLng(23.7775, 90.3994),
        infoWindow: InfoWindow(
            title: 'Ahsan Manzil'
        )
    ),
    Marker(
      markerId: MarkerId('4'),
      position: LatLng(23.8103, 90.4232),
        infoWindow: InfoWindow(
            title: 'National Museum of Bangladesh'
        )
    ),
    Marker(
      markerId: MarkerId('5'),
      position: LatLng(23.8458, 90.4210),
        infoWindow: InfoWindow(
            title: 'Bashundhara City Mall'
        )
    ),
    Marker(
      markerId: MarkerId('6'),
      position: LatLng(23.8461, 90.4139),
        infoWindow: InfoWindow(
            title: 'National Museum of Bangladesh'
        )
    ), // Dhanmondi Lake
    Marker(
      markerId: MarkerId('7'),
      position: LatLng(23.7480, 90.3801),
        infoWindow: InfoWindow(
            title: 'Dhakeshwari Temple'
        )
    ),
    Marker(
      markerId: MarkerId('8'),
      position: LatLng(23.8355, 90.4190),
        infoWindow: InfoWindow(
            title: 'Jatiyo Sangsad Bhaban'
        )
    ),
    Marker(
      markerId: MarkerId('9'),
      position: LatLng(23.8130, 90.4085),
        infoWindow: InfoWindow(
            title: 'Shahbagh'
        )
    ),
    Marker(
      markerId: MarkerId('10'),
      position: LatLng(23.762159,90.436406),
        infoWindow: InfoWindow(
            title: 'Your Places'
        )
    ),
    Marker(
      markerId: MarkerId('10'),
      position: LatLng(23.7477, 90.3770),
        infoWindow: InfoWindow(
            title: 'Bangladesh Liberation War Museum'
        )
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: _kGooglePlex,
          markers: Set<Marker>.of(markerList),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: const Text('To the lake!'),
          icon: const Icon(Icons.directions_boat),
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
