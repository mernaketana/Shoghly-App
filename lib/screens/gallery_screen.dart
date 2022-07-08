import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/models/image.dart';
import 'package:project/models/worker_project.dart';
import 'package:project/providers/project.dart';
import 'package:project/screens/add_project_screen.dart';
import 'package:project/screens/detailed_project_screen.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/employee.dart';
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
  var _isInit = true;
  var _isLoading = false;
  late List<WorkerProject> projects;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      projects = await Provider.of<Project>(context, listen: false)
          .getWorkerProjects(widget.currentUser.id);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  // Future<void> getProject(String projectId) async {
  //   await Provider.of<Project>(context, listen: false)
  //       .getWorkerProject(projectId);
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
      body: _isLoading
          ? const SpinKitSpinningLines(color: Colors.red)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          InkWell(
                              onTap: () => Navigator.of(context).pushNamed(
                                  DetailedProjectScreen.routeName,
                                  arguments: projects[index].projectId!),
                              splashColor: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    child: Image.network(
                                      projects[index].urls![0],
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            const Color.fromARGB(169, 0, 0, 0)),
                                  ),
                                  Positioned(
                                    bottom: 55,
                                    right: 5,
                                    left: 8,
                                    child: SizedBox(
                                      width: 20,
                                      height: 60,
                                      child: Text(
                                        (projects[index].urls!.length > 1)
                                            ? '+${(projects[index].urls!.length - 1)}'
                                            : '',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 25),
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          Text(
                            projects[index].desc,
                            softWrap: true,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
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
