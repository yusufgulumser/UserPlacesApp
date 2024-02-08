import 'package:favorite_places/models/places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as spath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'dart:io';

Future<Database> _getDatabase() async {
  final databPath = await sql.getDatabasesPath();
  final datab = await sql.openDatabase(
    path.join(databPath, 'Userplaces.db'),
    onCreate: (datab, version) {
      return datab.execute(
          'CREATE TABLE userPlaces(id TEXT PRIMARY KEY, title TEXT, img TEXT, latitude REAL, longitude REAL, address TEXT)');
    },
    version: 1,
  );
  return datab;
}

class AddPlacesNotifier extends StateNotifier<List<Place>> {
  AddPlacesNotifier() : super(const []);

  Future<void> loadData() async {
    final databa = await _getDatabase();
    final data = await databa.query('userPlaces');
    final userplaces = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['img'] as String),
            location: PlaceLocation(
              latitude: row['latitude'] as double,
              longitude: row['longitude'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();

    state = userplaces;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final aDir = await spath.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final dbimage = await image.copy('${aDir.path}/$filename');

    final newPlace = Place(title: title, image: dbimage, location: location);

    final datab = await _getDatabase();
    datab.insert('userPlaces', {
      'id': newPlace.id,
      'title': newPlace.title,
      'img': newPlace.image.path,
      'latitude': newPlace.location.latitude,
      'longitude': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [newPlace, ...state];
  }
}

final addPlacesProvider = StateNotifierProvider<AddPlacesNotifier, List<Place>>(
    (ref) => AddPlacesNotifier());
