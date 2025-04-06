import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserCurrentLocation extends StatefulWidget {
  const UserCurrentLocation({super.key});

  @override
  State<UserCurrentLocation> createState() => _UserCurrentLocationState();
}

class _UserCurrentLocationState extends State<UserCurrentLocation> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          Position userPosition = await userLocation();
          final GoogleMapController controller = await _controller.future;
          await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(userPosition.latitude, userPosition.longitude),
            tilt: 59.440717697143555,
            zoom: 19.151926040649414,
          )));
        },
        label: const Text('My Location'),
        icon: const Icon(Icons.location_history),
      ),
    );
  }

  Future<Position> userLocation() async {
    await Geolocator.requestPermission().then((onValue){

    }).onError((e,stackTrace){

    });
    return Geolocator.getCurrentPosition();
  }
}
