import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/models/worker_project.dart';
import 'package:project/providers/project.dart';
import 'package:project/widgets/images_gallery_widget.dart';
import 'package:provider/provider.dart';
import 'package:nine_grid_view/nine_grid_view.dart';
import '../providers/images.dart';
import '../widgets/user_image_picker.dart';

class AddProjectScreen extends StatefulWidget {
  static const routeName = '/add-project-screen';
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _form = GlobalKey<FormState>();
  String _albumTitle = '';
  var _isLoading = false;
  var _savedProject = WorkerProject('', []);
  ImageSource? source;
  File? _image;

  Future<void> _pickedImageCamera() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedImage == null) return;
      setState(() {
        _isLoading = true;
      });
      String userImage = await Provider.of<Images>(context, listen: false)
          .addImage(pickedImage.path);
      var _finalProjectUrlList = _savedProject.urls;
      _finalProjectUrlList!.add(userImage);
      _savedProject = WorkerProject(_savedProject.desc, _finalProjectUrlList);
      setState(() {
        _isLoading = false;
      });
      print('Here in user image picker');
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
      setState(() {
        _isLoading = true;
      });
      String userImage = await Provider.of<Images>(context, listen: false)
          .addImage(pickedImage.path);
      var _finalProjectUrlList = _savedProject.urls;
      _finalProjectUrlList!.add(userImage);
      _savedProject = WorkerProject(_savedProject.desc, _finalProjectUrlList);
      setState(() {
        _isLoading = false;
      });
      print('Here in user image picker');
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> _saveProject() async {
    final _isValid = _form.currentState?.validate();
    if (!_isValid!) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Project>(context, listen: false)
          .addProject(_savedProject);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('An error occured'),
                content: const Text('Something went wrong'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok')),
                ],
              ));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اضافة البوم'),
        ),
        body: _isLoading
            ? const Center(child: SpinKitSpinningLines(color: Colors.red))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Form(
                              key: _form,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'عنوان الالبوم',
                                      ),
                                      onSaved: (e) => _albumTitle = e as String,
                                      validator: (e) {
                                        if (e!.isEmpty) {
                                          return 'برجاء كتابة عنوان الالبوم';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      decoration: const InputDecoration(
                                        labelText: 'تفاصيل المشروع',
                                      ),
                                      onSaved: (e) => _savedProject =
                                          WorkerProject(
                                              e as String, _savedProject.urls),
                                      validator: (e) {
                                        if (e!.isEmpty) {
                                          return 'برجاء كتابة عنوان الالبوم';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                    style: const ButtonStyle(),
                                    onPressed: _pickedImageCamera,
                                    icon: const Icon(Icons.camera_alt),
                                    label: const Text('الكاميرا')),
                                const SizedBox(width: 15),
                                TextButton.icon(
                                    style: const ButtonStyle(),
                                    onPressed: _pickedImageGallery,
                                    icon: const Icon(Icons.image),
                                    label: const Text('المعرض')),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // ImagesGallery(images: _savedProject.urls!)
                            // NineGridView(
                            //   height: 500, width: 500,
                            //   margin: const EdgeInsets.all(10),
                            //   padding: const EdgeInsets.all(5),
                            //   space: 10,
                            //   type: NineGridType
                            //       .normal, //NineGridType.weChat, NineGridType.weiBo
                            //   itemCount: _savedProject.urls!.length,
                            //   itemBuilder: (BuildContext context, int index) {
                            //     return CachedNetworkImage(
                            //       height: 20,
                            //       width: 20,
                            //       fit: BoxFit.cover,
                            //       imageUrl: _savedProject.urls![index],
                            //       placeholder: (context, url) =>
                            //           CircularProgressIndicator(),
                            //       errorWidget: (context, url, error) =>
                            //           Icon(Icons.error),
                            //     );
                            //   },
                            // )
                            // SizedBox(
                            //   height: 500,
                            //   child: ListView.builder(
                            //     itemBuilder: (context, index) {
                            //       return Padding(
                            //         padding: const EdgeInsets.all(5),
                            //         child: InkWell(
                            //           onTap: () {},
                            //           splashColor:
                            //               Theme.of(context).colorScheme.primary,
                            //           borderRadius: BorderRadius.circular(15),
                            //           child: Image.network(
                            //             _savedProject.urls![index],
                            //             height: 250,
                            //             width: double.infinity,
                            //             fit: BoxFit.cover,
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //     itemCount: _savedProject.urls!.length,
                            //   ),
                            // )
                            SizedBox(
                              height: 500,
                              child: GridView(
                                children: <Widget>[
                                  ..._savedProject.urls!
                                      .map((e) => InkWell(
                                            onTap: () {},
                                            splashColor:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                e,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ],
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  mainAxisExtent: 130,
                                  maxCrossAxisExtent: 190,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 30),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    height: 90,
                    child: ElevatedButton.icon(
                        onPressed: _saveProject,
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'تـــم',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
                  ),
                ],
              ),
      ),
    );
  }
}
