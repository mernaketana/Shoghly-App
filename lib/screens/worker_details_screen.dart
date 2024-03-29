import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/employee.dart';
import '../models/comment.dart';
import '../models/worker_project.dart';
import '../screens/detailed_project_screen.dart';
import '../screens/single_chat_screen.dart';
import '../providers/favourites.dart';
import '../providers/auth.dart';
import '../providers/project.dart';
import '../providers/worker.dart';
import '../widgets/comments.dart';

// ignore: must_be_immutable
class WorkerDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;
  bool? editAndDelete;
  WorkerDetailsScreen({Key? key, required this.arguments, this.editAndDelete})
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
        projectImages.add(element.urls![0] ?? 'assets/images/placeholder.png');
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
          child: InkWell(
              onTap: () => Navigator.of(context)
                      .pushNamed(DetailedProjectScreen.routeName, arguments: {
                    'projectId': projects[i].projectId!,
                    'canEdit': false
                  }),
              splashColor: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(15),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: CachedNetworkImage(
                    imageUrl:
                        projects[i].urls![0] ?? 'assets/images/placeholder.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SpinKitSpinningLines(
                        color: Theme.of(context).colorScheme.primary),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ))),
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

  _launchCaller(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.arguments['currentUser'] as Employee;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: _isLoading
              ? Center(
                  child: SpinKitSpinningLines(
                      color: Theme.of(context).colorScheme.primary),
                )
              : CustomScrollView(slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Hero(
                            tag: currentWorker.id,
                            child: currentWorker.image == null
                                ? Image.asset(
                                    'assets/images/placeholder.png',
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: currentWorker.image as String,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        SpinKitSpinningLines(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ))),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5))),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${currentWorker.fname} ${currentWorker.lname}',
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                      fontSize: 20),
                                  textAlign: TextAlign.right,
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 130,
                                  height: 30,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: widget.arguments["currentWorker"]
                                                .avgRate ==
                                            null
                                        ? createStars(0)
                                        : createStars(widget
                                            .arguments["currentWorker"].avgRate!
                                            .toDouble()),
                                  ),
                                ),
                              ]),
                        ),
                        Card(
                          color: Theme.of(context).backgroundColor,
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      currentWorker.categordId as String,
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
                                    TextButton.icon(
                                      icon: const Icon(
                                        Icons.phone,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                      label: Text(
                                        '0${currentWorker.phone.toString()}',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      onPressed: () => _launchCaller(
                                          "tel:0${currentWorker.phone.toString()}"),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              if (projects.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Center(
                                    child: Text(
                                      'لا يوجد البومات',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ),
                              if (projects.isNotEmpty)
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      currentWorker:
                                          widget.arguments["currentWorker"])),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              if (currentUser.role == 'client')
                                Expanded(
                                  child: ElevatedButton.icon(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5)))),
                                      onPressed: () => favEmployees.any((element) =>
                                              element.id ==
                                              (widget.arguments['currentWorker']
                                                      as Employee)
                                                  .id)
                                          ? unfavourite((widget.arguments['currentWorker'] as Employee).id)
                                          : favourite((widget.arguments['currentWorker'] as Employee).id),
                                      icon: Icon(Icons.favorite, color: favEmployees.any((element) => element.id == (widget.arguments['currentWorker'] as Employee).id) ? Colors.red : Colors.white),
                                      label: Text(favEmployees.any((element) => element.id == (widget.arguments['currentWorker'] as Employee).id) ? 'ازالة من مفضلاتي' : 'اضافة لمفضلاتي')),
                                ),
                              const SizedBox(
                                width: 5,
                              ),
                              if (currentUser.role == 'client')
                                Expanded(
                                  child: ElevatedButton.icon(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5)))),
                                      onPressed: () {
                                        final token = Provider.of<Auth>(context,
                                                listen: false)
                                            .token;
                                        Navigator.of(context).pushNamed(
                                            SingleChatScreen.routeName,
                                            arguments: {
                                              "userId": currentWorker.id,
                                              "userImage": currentWorker.image,
                                              "userFirstName":
                                                  currentWorker.fname,
                                              "userLastName":
                                                  currentWorker.lname,
                                              "token": token
                                            });
                                      },
                                      icon: const Icon(
                                        Icons.message,
                                        color: Colors.amber,
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
        ));
  }
}
