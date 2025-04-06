import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddressName extends StatefulWidget {
  const AddressName({super.key});

  @override
  State<AddressName> createState() => _AddressNameState();
}

class _AddressNameState extends State<AddressName> {
  String locationName = 'Enter Coordinate';

  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  Future<String> _getAddressFromCoordinates() async {
    double lat = double.parse(latitudeController.text.trim());
    double long = double.parse(longitudeController.text.trim());
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, long);
    if (placeMarks.isNotEmpty) {
      Placemark place = placeMarks[0];
      setState(() {
        locationName = '${place.name}, ${place.locality}, ${place.country}';
      });
    } else {
      setState(() {
        locationName = 'Location not found';
      });
    }
    return locationName;
  }

  Future<void> _getCoordinateFromAddress() async {
    String address = locationController.text.trim();

    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        double lat = locations.first.latitude;
        double lng = locations.first.longitude;

        setState(() {
          locationName = 'Lat: $lat, Lng: $lng';
        });
      } else {
        setState(() {
          locationName = '';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(locationName, style: TextStyle(fontSize: 18)),

            SizedBox(height: 20),

            TypeAheadField<Location>(
              suggestionsCallback: (pattern) async {
                if (pattern.isEmpty) return [];
                try {
                  return await locationFromAddress(pattern);
                } catch (_) {
                  return [];
                }
              },
              itemBuilder: (context, Location suggestion) {
                return FutureBuilder<List<Placemark>>(
                  future: placemarkFromCoordinates(suggestion.latitude, suggestion.longitude),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ListTile(title: Text('Loading...'));
                    } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return const ListTile(title: Text('Unknown location'));
                    } else {
                      final place = snapshot.data!.first;
                      return ListTile(
                        title: Text('${place.name}, ${place.locality}, ${place.country}'),
                      );
                    }
                  },
                );
              },

              onSelected: (Location suggestion) async {
                List<Placemark> placemarks = await placemarkFromCoordinates(
                  suggestion.latitude,
                  suggestion.longitude,
                );

                if (placemarks.isNotEmpty) {
                  Placemark place = placemarks[0];
                  setState(() {
                    locationController.text =
                    '${place.name}, ${place.locality}, ${place.country}';

                    latitudeController.text = suggestion.latitude.toString();
                    longitudeController.text = suggestion.longitude.toString();

                    locationName =
                    '${place.name}, ${place.locality}, ${place.country}\nLat: ${suggestion.latitude}, Lng: ${suggestion.longitude}';
                  });
                }
              },
              builder: (context, controller, focusNode) {
                if(locationName!='Enter Coordinate'&& controller.text != locationName.toString()){
                  controller.text = locationName.toString();
                }else{
                  print(controller.text);
                }
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Enter address',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),


            SizedBox(height: 40),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: latitudeController,
                    decoration: InputDecoration(hintText: 'Latitude'),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: longitudeController,
                    decoration: InputDecoration(hintText: 'Longitude'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _getCoordinateFromAddress,
              child: Text('Find from Address'),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: _getAddressFromCoordinates,
              child: Text('Find from Coordinates'),
            ),
          ],
        ),
      ),
    );
  }
}
