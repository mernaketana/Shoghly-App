import 'package:flutter/material.dart';
import 'package:project/models/worker_project.dart';
import 'package:project/screens/detailed_image_screen.dart';
import 'package:project/widgets/splash_screen.dart';
import 'package:provider/provider.dart';

import '../providers/project.dart';

class DetailedProjectScreen extends StatefulWidget {
  static const routeName = '/detailed-project-screen';
  final String projectId;
  const DetailedProjectScreen({Key? key, required this.projectId})
      : super(key: key);

  @override
  State<DetailedProjectScreen> createState() => _DetailedProjectScreenState();
}

class _DetailedProjectScreenState extends State<DetailedProjectScreen> {
  var _isInit = true;
  var _isLoading = false;
  late WorkerProject project;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      project = await Provider.of<Project>(context, listen: false)
          .getWorkerProject(widget.projectId);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const SplashScreen()
        : Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                appBar: AppBar(
                  title: const Text('شغلي'),
                ),
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Card(
                                  elevation: 4,
                                  shadowColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: ListTile(
                                    title: const Text(
                                      'تفاصيل المشروع',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      project.desc,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 500,
                                  child: GridView(
                                    children: <Widget>[
                                      ...project.urls!
                                          .map((e) => InkWell(
                                                onTap: () =>
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            DetailedImageScreen
                                                                .routeName,
                                                            arguments: e),
                                                splashColor: Theme.of(context)
                                                    .primaryColor,
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
                                        horizontal: 10, vertical: 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ])),
          );
  }
}
