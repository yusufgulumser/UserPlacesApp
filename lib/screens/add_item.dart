import 'package:favorite_places/models/places.dart';
import 'package:favorite_places/providers/add_place_provider.dart';
import 'package:favorite_places/widgets/inputImage.dart';
import 'package:favorite_places/widgets/inputLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  void _savePlace() {
    final enteredPlace = _titleController.text;

    if (enteredPlace.isEmpty || _selectedImage == null) {
      return;
    }
    ref
        .read(addPlacesProvider.notifier)
        .addPlace(enteredPlace, _selectedImage!, _selectedLocation!);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a place'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Form(
              child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                controller: _titleController,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              const SizedBox(
                height: 10,
              ),
              InputImage(
                onPickImage: (image) {
                  _selectedImage = image;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              InputLocation(
                onPickLocation: (location) {
                  _selectedLocation = location;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(onPressed: _savePlace, child: const Text('submit'))
            ],
          )),
        ),
      ),
    );
  }
}
