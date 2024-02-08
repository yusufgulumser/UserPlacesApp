import 'package:uuid/uuid.dart';
import 'dart:io';

const uuid = Uuid();

class PlaceLocation {
  PlaceLocation(
      {required this.latitude, required this.longitude, required this.address});
  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place(
      {required this.title,
      required this.image,
      required this.location,
      String? id})
      : id = id ?? uuid.v4();

  final String id;
  final String title;
  PlaceLocation location;
  File image;
}
