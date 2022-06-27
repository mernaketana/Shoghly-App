import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/models/image.dart';
import 'package:project/screens/add_project_screen.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/employee.dart';
// import '../providers/user.dart';
import '../providers/images.dart';
import '../screens/detailed_image_screen.dart';

class GalleryScreen extends StatefulWidget {
  static const routeName = '/gallery-screen';
  final Employee currentUser;
  const GalleryScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  ImageSource? source;
  var newWorkImage = MyImage('', [], '');

  Future _dialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          content: const Text(
            'قم باختيار مصدر الصورة',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              child: const Text('الكاميرا'),
              onPressed: () {
                _pickedImageCamera();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('المعرض'),
              onPressed: () {
                // _pickedImageGallery(userId);
                Navigator.of(context).pop();
              },
            ),
          ]),
    );
  }

  Future<void> _pickedImageCamera() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage == null) return;
      await Provider.of<Images>(context, listen: false)
          .addImage(pickedImage.path);
    } on PlatformException catch (_) {
      return;
    }
  }

  Future<void> _pickedImageGallery(String userId) async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;
      // final pickedImageFile = File(pickedImage.path);
      // setState(() {
      //   _image = pickedImage.path;
      // });
      // setState(() {
      //   if (!DUMMY_IMAGES.any((element) => element.userId == userId)) {
      //     newWorkImage =
      //         MyImage(DateTime.now().toString(), [(pickedImage.path)], userId);
      //     // var new_user_img = MyImage(
      //     //     DateTime.now().toString(), ['${pickedImage.path}'], userId);
      //     // print(newWorkImage.url);
      //     DUMMY_IMAGES.add(newWorkImage);
      //   } else {
      //     DUMMY_IMAGES
      //         .firstWhere((element) => element.userId == userId)
      //         .url!
      //         .add(pickedImage.path);
      //   }
      // });
      // widget.imagePick(pickedImageFile);
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // void _deleteImage(String url) {
  //   final item = DUMMY_IMAGES.firstWhere((element) => element.url == url);
  //   DUMMY_IMAGES.remove(item);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(AddProjectScreen.routeName),
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      appBar: AppBar(
        title: const Center(child: Text('معرضي')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: Row(
              children: const [
                Icon(
                  Icons.info,
                  size: 19,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'لحذف صورة قم بالضغط عليها مرتين ثم اختر نعم',
                  style: TextStyle(
                      color: Color.fromARGB(255, 102, 101, 101),
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Expanded(
            child: GridView(
              children: <Widget>[
                // ...DUMMY_IMAGES
                //     .firstWhere(
                //         (element) => element.userId == widget.currentUser.id)
                //     .url!
                //     .map((e) => listImages(e, context, widget.currentUser.id))
                //     .toList(),

                // SizedBox(
                //   height: 20,
                //   width: 20,
                //   child: FittedBox(
                //     child: FloatingActionButton(
                //       onPressed: () => _dialog(context, currentUser.id),
                //       child: const Icon(
                //         Icons.add,
                //       ),
                //       backgroundColor: Theme.of(context).colorScheme.primary,
                //     ),
                //   ),
                // ),
              ],
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2.7 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              padding: const EdgeInsets.all(14),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10),
          //   child: FloatingActionButton(
          //     elevation: 0,
          //     onPressed: () => _dialog(context, widget.currentUser.id),
          //     child: const Icon(Icons.add),
          //     backgroundColor: Theme.of(context).colorScheme.primary,
          //   ),
          // ),

          // SizedBox(
          //   width: 150,
          //   height: 150,
          //   child: FittedBox(
          //     child: RawMaterialButton(
          //       shape: const CircleBorder(),
          //       fillColor: Colors.red,
          //       elevation: 0.0,
          //       child: const Icon(
          //         Icons.add,
          //         color: Color.fromARGB(255, 254, 247, 241),
          //         size: 16,
          //       ),
          //       onPressed: () => _dialog(context, currentUser.id),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  InkWell listImages(String img, BuildContext context, String userId) {
    return InkWell(
      onDoubleTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
              content: const Text(
                'هل تريد حذف الصورة؟',
                textAlign: TextAlign.right,
              ),
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                TextButton(
                  child: const Text('لا'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('نعم'),
                  onPressed: () {
                    // List<String> urls = DUMMY_IMAGES
                    //     .firstWhere((element) => element.userId == userId)
                    //     .url as List<String>;

                    setState(() {
                      // urls.remove(img);

                      Navigator.of(context).pop();
                      return;
                    });
                    // Navigator.of(context).pop();
                  },
                ),
              ]),
        );
      },
      onTap: () => Navigator.of(context)
          .pushNamed(DetailedImageScreen.routeName, arguments: img),
      borderRadius: BorderRadius.circular(15),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)),
        child: img.startsWith('/data')
            ? Image.file(
                File(
                  img,
                ),
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
            : Image.network(
                img,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
