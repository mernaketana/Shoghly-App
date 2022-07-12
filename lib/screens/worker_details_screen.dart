import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/models/employee.dart';
import 'package:project/providers/favourites.dart';
import 'package:project/screens/detailed_project_screen.dart';
import 'package:project/screens/single_chat_screen.dart';
import 'package:provider/provider.dart';
import '../models/comment.dart';
import '../models/worker_project.dart';
import '../providers/project.dart';
import '../providers/worker.dart';

import '../widgets/comments.dart';

class WorkerDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;
  const WorkerDetailsScreen({Key? key, required this.arguments})
      : super(key: key);
  static const routeName = '/worker-detail-screen';

  @override
  State<WorkerDetailsScreen> createState() => _WorkerDetailsScreenState();
}

class _WorkerDetailsScreenState extends State<WorkerDetailsScreen> {
  var _isInit = true;
  var _isLoading = false;
  late Map<String, dynamic> workerProfile;
  late Employee currentWorker;
  late List<Comment> comments;
  late List<WorkerProject> projects;
  List<String> projectImages = [];
  late List<Employee> favEmployees;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      workerProfile = await Provider.of<Worker>(context, listen: false)
          .getWorker((widget.arguments["currentWorker"] as Employee).id);
      currentWorker = workerProfile['employee'];
      comments = workerProfile['workerComments'];
      projects = await Provider.of<Project>(context, listen: false)
          .getWorkerProjects(currentWorker.id);
      for (var element in projects) {
        projectImages.add(element.urls![0]);
      }
      favEmployees = await Provider.of<Favourites>(context, listen: false)
          .getAllFavourites();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  var starList = <Widget>[];
  List<Widget> createStars(double rate) {
    starList.clear();
    for (var i = 0; i < rate; i++) {
      starList.add(
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: 25,
        ),
      );
    }
    return starList;
  }

  var galleryList = <Widget>[];
  List<Widget> createGallery(List<WorkerProject> projects) {
    galleryList.clear();
    for (var i = 0; i < projects.length; i++) {
      galleryList.add(
        Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              InkWell(
                  onTap: () => Navigator.of(context).pushNamed(
                      DetailedProjectScreen.routeName,
                      arguments: projects[i].projectId!),
                  splashColor: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: CachedNetworkImage(
                        imageUrl: projects[i].urls![0],
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const SpinKitSpinningLines(color: Colors.red),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ))),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(122, 0, 0, 0)),
                height: 150,
                width: 150,
              ),
            ],
          ),
        ),
      );
    }
    return galleryList;
  }

  Future<void> favourite(String workerId) async {
    await Provider.of<Favourites>(context, listen: false)
        .addFavourite(workerId);
    _isInit = true;
    didChangeDependencies();
  }

  Future<void> unfavourite(String workerId) async {
    await Provider.of<Favourites>(context, listen: false)
        .deleteFavourite(workerId);
    _isInit = true;
    didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.arguments['currentUser'] as Employee;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: _isLoading
              ? const Center(
                  child: SpinKitSpinningLines(color: Colors.red),
                )
              : Stack(
                  children: [
                    CustomScrollView(
                        // slivers are scrollable areas on the screen
                        slivers: <Widget>[
                          SliverAppBar(
                            expandedHeight: 300,
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                                background: Hero(
                                    tag: currentWorker.id,
                                    child: currentWorker.image == ''
                                        ? Image.asset(
                                            'assets/images/placeholder.png',
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl:
                                                currentWorker.image as String,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const SpinKitSpinningLines(
                                                    color: Colors.red),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ))),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Container(
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(185, 0, 0, 0),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          bottomRight: Radius.circular(5))),
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${currentWorker.fname} ${currentWorker.lname}',
                                          softWrap: true,
                                          overflow: TextOverflow.clip,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                          textAlign: TextAlign.right,
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: 130,
                                          height: 30,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: createStars(widget
                                                .arguments["currentWorker"]
                                                .avgRate!
                                                .toDouble()),
                                          ),
                                        ),
                                      ]),
                                ),
                                Card(
                                  color: Theme.of(context).backgroundColor,
                                  elevation: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 11, vertical: 9),
                                        child: Text(
                                          'المعلومات',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 22, bottom: 14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              currentWorker.categordId
                                                  as String,
                                            ),
                                            Text(
                                              currentWorker.location,
                                            ),
                                            Text(
                                              currentWorker.address,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.phone,
                                                  size: 18,
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  currentWorker.phone
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Card(
                                  color: Theme.of(context).backgroundColor,
                                  elevation: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 11, vertical: 9),
                                        child: Text(
                                          'الالبومات',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: createGallery(projects),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Card(
                                  color: Theme.of(context).backgroundColor,
                                  elevation: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 11, vertical: 9),
                                        child: Text(
                                          'التعليقات',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(
                                          height: 200,
                                          child: Comments(
                                              userComments: comments,
                                              currentUser: currentUser,
                                              currentWorker: widget
                                                  .arguments["currentWorker"])),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5)))),
                                            onPressed: () => favEmployees.any(
                                                    (element) =>
                                                        element.id ==
                                                        (widget.arguments['currentWorker']
                                                                as Employee)
                                                            .id)
                                                ? unfavourite((widget.arguments['currentWorker'] as Employee).id)
                                                : favourite((widget.arguments['currentWorker'] as Employee).id),
                                            icon: Icon(Icons.favorite, color: favEmployees.any((element) => element.id == (widget.arguments['currentWorker'] as Employee).id) ? Color.fromARGB(255, 255, 115, 115) : Colors.white),
                                            label: Text(favEmployees.any((element) => element.id == (widget.arguments['currentWorker'] as Employee).id) ? 'ازالة من مفضلاتي' : 'اضافة لمفضلاتي')),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      if (currentUser.role == 'client')
                                        Expanded(
                                          child: ElevatedButton.icon(
                                              style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)))),
                                              onPressed: () => Navigator.of(
                                                      context)
                                                  .pushNamed(
                                                      SingleChatScreen
                                                          .routeName,
                                                      arguments: currentWorker),
                                              icon: const Icon(
                                                Icons.message,
                                                color: Colors.yellow,
                                              ),
                                              label: const Text('الدردشة')),
                                        ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ]),
                    // if (currentUser.role == 'client')
                    // Positioned(
                    //   bottom: 20,
                    //   left: 20,
                    //   child: FloatingActionButton(
                    //     backgroundColor:
                    //         const Color.fromARGB(255, 254, 247, 241),
                    //     onPressed: () => favEmployees.any((element) =>
                    //             element.id ==
                    //             (widget.arguments['currentWorker']
                    //                     as Employee)
                    //                 .id)
                    //         ? unfavourite((widget.arguments['currentWorker']
                    //                 as Employee)
                    //             .id)
                    //         : favourite((widget.arguments['currentWorker']
                    //                 as Employee)
                    //             .id),
                    //     child: Icon(Icons.favorite,
                    //         color: favEmployees.any((element) =>
                    //                 element.id ==
                    //                 (widget.arguments['currentWorker']
                    //                         as Employee)
                    //                     .id)
                    //             ? Colors.red
                    //             : Colors.grey),
                    //   ),
                    // )
                  ],
                ),
        ));
  }
}
