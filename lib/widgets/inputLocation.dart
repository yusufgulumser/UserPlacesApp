import 'dart:convert';

import 'package:favorite_places/models/places.dart';
import 'package:favorite_places/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class InputLocation extends StatefulWidget {
  const InputLocation({super.key, required this.onPickLocation});
  final void Function(PlaceLocation location) onPickLocation;

  @override
  State<InputLocation> createState() {
    return _InputLocationState();
  }
}

class _InputLocationState extends State<InputLocation> {
  PlaceLocation? _chosenLocation;
  String get locationImage {
    if (_chosenLocation == null) {
      return '';
    }
    final lat = _chosenLocation!.latitude;
    final lon = _chosenLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lon&key=AIzaSyCFjASk3Hout4NpQC_V49YSitJ-xvv0fzQ';
  }

  var _isLoading = false;

  void _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyCFjASk3Hout4NpQC_V49YSitJ-xvv0fzQ');
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    final addr = responseData['results'][0]['formatted_address'];

    setState(() {
      _chosenLocation = PlaceLocation(
          latitude: latitude, longitude: longitude, address: addr);
      _isLoading = false;
    });
    widget.onPickLocation(_chosenLocation!);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isLoading = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lon = locationData.longitude;

    if (lat == null || lon == null) {
      return;
    }

    _savePlace(lat, lon);
  }

  void _selectOnMap() async {
    final tempMap =
        PlaceLocation(latitude: 37.422, longitude: -122.084, address: '');
    final pickedloc = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(location: tempMap),
      ),
    );
    if (pickedloc == null) {
      return;
    }
    _savePlace(pickedloc.latitude, pickedloc.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      'No location chosen',
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
      textAlign: TextAlign.center,
    );
    if (_chosenLocation != null) {
      content = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if (_isLoading) {
      content = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
            height: 175,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
            ),
            child: content),
        Row(
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on_outlined),
              label: const Text('Get current location'),
            ),
            TextButton.icon(
                onPressed: _selectOnMap,
                icon: const Icon(Icons.map_outlined),
                label: const Text('Select on map'))
          ],
        )
      ],
    );
  }
}
