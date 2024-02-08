import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class InputImage extends StatefulWidget {
  const InputImage({super.key, required this.onPickImage});
  final void Function(File image) onPickImage;
  @override
  State<InputImage> createState() {
    return _InputImageState();
  }
}

class _InputImageState extends State<InputImage> {
  File? _selectedImage;
  void _takePic() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage == null) {
      return;
    }
    setState(
      () {
        _selectedImage = File(pickedImage.path);
      },
    );
    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        onPressed: _takePic,
        icon: const Icon(Icons.camera_alt_outlined),
        label: const Text('Take a picture'));
    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePic,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
        decoration: BoxDecoration(
            border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        )),
        height: 200,
        width: double.infinity,
        alignment: Alignment.center,
        child: content);
  }
}
