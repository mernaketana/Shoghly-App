import 'package:cached_network_image/cached_network_image.dart';
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
import '../providers/user.dart';
import '../screens/detailed_image_screen.dart';

class GalleryScreen extends StatefulWidget {
  static const routeName = '/gallery-screen';
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  ImageSource? source;
  var newWorkImage = MyImage('', [], '');
  var _isInit = true;
  var _isLoading = false;
  late List<WorkerProject> projects;
  late Employee currentUser;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final userId = Provider.of<User>(context, listen: false).userId;
      await Provider.of<User>(context)
          .getUser(userId)
          .then((value) => currentUser = value);
      projects = await Provider.of<Project>(context, listen: false)
          .getWorkerProjects(currentUser.id);
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
        onPressed: () => Navigator.of(context)
            .pushNamed(AddProjectScreen.routeName, arguments: {
          'canEdit': false,
          'currentProject': WorkerProject(desc: '', urls: [])
        }),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      appBar: AppBar(
        title: const Center(child: Text('معرضي')),
      ),
      body: _isLoading
          ? SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary)
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
                                arguments: {
                                  'projectId': projects[index].projectId!,
                                  'canEdit': true
                                }),
                            splashColor: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(15),
                            child: projects[index].urls![0] != null
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        child: CachedNetworkImage(
                                          imageUrl: projects[index].urls![0],
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              SpinKitSpinningLines(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                169, 0, 0, 0)),
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: Text('لا يوجد البومات'),
                                  ),
                          ),
                          Text(
                            projects[index].desc,
                            softWrap: true,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
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
}
