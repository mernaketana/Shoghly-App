import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/images.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(String pickedImage) imagePick;
  const UserImagePicker({Key? key, required this.imagePick}) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  ImageSource? source;
  File? _image;
  var _isLoading = false;

// void _pickedImage() async{
//   final picker = ImagePicker();
//   final pickedImage = await picker.pickImage(source: ImageSource.camera);
//   final pickedImageFile = File(pickedImage.path);
// }

  Future<void> _pickedImageCamera() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedImage == null) return;
      final pickedImageFile = File(pickedImage.path);
      setState(() {
        _isLoading = true;
      });
      final pickedImageUrl = await Provider.of<Images>(context, listen: false)
          .addImage(pickedImage.path);
      setState(() {
        _isLoading = false;
      });
      print('Here in user image picker');
      print(pickedImageUrl);
      setState(() {
        _image = pickedImageFile;
      });
      widget.imagePick(pickedImageUrl);
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> _pickedImageGallery() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage == null) return;
      final pickedImageFile = File(pickedImage.path);
      setState(() {
        _isLoading = true;
      });
      final pickedImageUrl = await Provider.of<Images>(context, listen: false)
          .addImage(pickedImage.path);
      setState(() {
        _isLoading = false;
      });
      setState(() {
        _image = pickedImageFile;
      });
      widget.imagePick(pickedImageUrl);
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        !_isLoading
            ? CircleAvatar(
                radius: 40,
                // ignore: unnecessary_null_comparison
                backgroundImage: _image != null
                    ? FileImage(_image as File)
                    : const AssetImage('assets/images/placeholder.png')
                        as ImageProvider<Object>?,
              )
            : const CircularProgressIndicator(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
                style: const ButtonStyle(
                    // foregroundColor: MaterialStateProperty.all(Colors.white)
                    ),
                onPressed: _pickedImageCamera,
                icon: const Icon(Icons.camera_alt),
                label: const Text('الكاميرا')),
            const SizedBox(width: 15),
            TextButton.icon(
                style: const ButtonStyle(
                    // foregroundColor: MaterialStateProperty.all(Colors.white)
                    ),
                onPressed: _pickedImageGallery,
                icon: const Icon(Icons.image),
                label: const Text('المعرض')),
          ],
        ),
      ],
    );
  }
}
