import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/worker_project.dart';
import '../screens/detailed_image_screen.dart';
import '../widgets/splash_screen.dart';
import '../providers/project.dart';

class DetailedProjectScreen extends StatefulWidget {
  static const routeName = '/detailed-project-screen';
  final Map<String, dynamic> arguments;
  const DetailedProjectScreen({Key? key, required this.arguments})
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
          .getWorkerProject(widget.arguments['projectId']);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  void delete(String projectId) async {
    await Provider.of<Project>(context, listen: false)
        .deleteProject(projectId)
        .then((value) => Navigator.of(context).pop());
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
                      ),
                      if (widget.arguments['canEdit'])
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          child: ElevatedButton.icon(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)))),
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        actionsAlignment:
                                            MainAxisAlignment.start,
                                        title: const Text(
                                          'هل انت متأكد؟ لا يمكنك استرجاع المشروع بعد حذفه.',
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                delete(widget
                                                    .arguments['projectId']);
                                                Navigator.of(ctx).pop();
                                              },
                                              child: const Text(
                                                'نعم',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ))
                                        ],
                                      )),
                              icon: const Icon(
                                Icons.delete,
                              ),
                              label: const Text('حذف')),
                        ),
                    ])),
          );
  }
}
