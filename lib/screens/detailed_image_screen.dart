import 'package:flutter/material.dart';
import 'dart:io';

class DetailedImageScreen extends StatelessWidget {
  static const routeName = '/detailed-image-screen';
  const DetailedImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 247, 241),
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: image.substring(32, 52),
              child: image.startsWith('/data')
                  ? Image.file(
                      File(
                        image,
                      ),
                    )
                  : Image.network(image)),
        ),
        onTap: () => Navigator.of(context).pop(),
      ),
    );
  }
}
