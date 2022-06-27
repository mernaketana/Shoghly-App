import 'package:flutter/material.dart';
import 'package:project/screens/detailed_image_screen.dart';
import 'dart:io';

class ImagesGallery extends StatefulWidget {
  final List<String> images;
  const ImagesGallery({Key? key, required this.images}) : super(key: key);

  @override
  State<ImagesGallery> createState() => _ImagesGalleryState();
}

class _ImagesGalleryState extends State<ImagesGallery> {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: SingleChildScrollView(
        child: SizedBox(
          height: 150,
          child: ListView.builder(
              itemCount: widget.images.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                    height: 150,
                    width: 150,
                    margin: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                          DetailedImageScreen.routeName,
                          arguments: widget.images[index]),
                      child: Hero(
                        tag: widget.images[index].substring(32, 52),
                        child: widget.images[index].startsWith('/data')
                            ? Image.file(
                                File(
                                  widget.images[index],
                                ),
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                widget.images[index],
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    color: const Color.fromARGB(247, 0, 0, 0),
                  )),
        ),
      ),
    );
  }
}
