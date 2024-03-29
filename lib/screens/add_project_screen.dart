import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/worker_project.dart';
import '../providers/project.dart';
import '../providers/images.dart';
import '../screens/detailed_image_screen.dart';

class AddProjectScreen extends StatefulWidget {
  static const routeName = '/add-project-screen';
  final Map<String, dynamic> arguments;
  const AddProjectScreen({Key? key, required this.arguments}) : super(key: key);

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _savedProject = WorkerProject(desc: '', urls: []);
  ImageSource? source;

  Future<void> _pickedImageCamera() async {
    try {
      final picker = ImagePicker();
      final pickedImage =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      if (pickedImage == null) return;
      setState(() {
        _isLoading = true;
      });
      String userImage = await Provider.of<Images>(context, listen: false)
          .addImage(pickedImage.path);
      var _finalProjectUrlList = _savedProject.urls;
      _finalProjectUrlList!.add(userImage);
      _savedProject =
          WorkerProject(desc: _savedProject.desc, urls: _finalProjectUrlList);
      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> _pickedImageGallery() async {
    try {
      final picker = ImagePicker();
      final pickedImage =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (pickedImage == null) return;
      setState(() {
        _isLoading = true;
      });
      String userImage = await Provider.of<Images>(context, listen: false)
          .addImage(pickedImage.path);
      var _finalProjectUrlList = _savedProject.urls;
      _finalProjectUrlList!.add(userImage);
      _savedProject =
          WorkerProject(desc: _savedProject.desc, urls: _finalProjectUrlList);
      setState(() {
        _isLoading = false;
      });
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
      if (widget.arguments['canEdit']) {
        await Provider.of<Project>(context, listen: false)
            .editProject(_savedProject);
      } else {
        await Provider.of<Project>(context, listen: false)
            .addProject(_savedProject);
      }
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
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Text('اضافة البوم'),
        ),
        body: _isLoading
            ? Center(
                child: SpinKitSpinningLines(
                    color: Theme.of(context).colorScheme.primary))
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
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  decoration: const InputDecoration(
                                    labelText: 'تفاصيل المشروع',
                                  ),
                                  onSaved: (e) => _savedProject = WorkerProject(
                                      desc: e as String,
                                      urls: _savedProject.urls),
                                  validator: (e) {
                                    if (e!.isEmpty) {
                                      return 'برجاء كتابة تفاصيل المشروع';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary)),
                                      onPressed: _pickedImageCamera,
                                      icon: const Icon(Icons.camera_alt),
                                      label: const Text('الكاميرا')),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: TextButton.icon(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                      ),
                                      onPressed: _pickedImageGallery,
                                      icon: const Icon(Icons.image),
                                      label: const Text('المعرض')),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 500,
                              child: GridView(
                                children: <Widget>[
                                  ..._savedProject.urls!
                                      .map((e) => InkWell(
                                            onTap: () => Navigator.of(context)
                                                .pushNamed(
                                                    DetailedImageScreen
                                                        .routeName,
                                                    arguments: e),
                                            splashColor:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl: e,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      SpinKitSpinningLines(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                )),
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
