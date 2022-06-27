import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/models/employee.dart';
import 'package:provider/provider.dart';
import '../models/comment.dart';
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
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  var starList = <Widget>[];
  int rate(List<dynamic>? rates) {
    double sum = 0;
    for (var i = 0; i < rates!.length; i++) {
      sum += (rates[i].rate!);
    }
    double avg = 0;
    // ignore: prefer_is_empty
    if (rates.length != 0) {
      avg = sum / rates.length;
    } else {
      avg = 0;
    }
    return avg.round();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.arguments['currentUser'] as Employee;
    starList.clear();
    // for (var i = 0; i < rate(currentWorker.reviews); i++) {
    //   // print(i);
    //   starList.add(
    //     const Icon(
    //       Icons.star,
    //       color: Colors.amber,
    //       size: 20,
    //     ),
    //   );
    // }
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: _isLoading
              ? const Center(
                  child: SpinKitSpinningLines(color: Colors.red),
                )
              : CustomScrollView(// slivers are scrollable areas on the screen
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
                          : Image.network(
                              currentWorker.image as String,
                              fit: BoxFit.cover,
                            ),
                    ) // the part that we won't always see
                        ), //what is inside the appbar
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${currentWorker.fname} ${currentWorker.lname}',
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.right,
                                ),
                                SizedBox(
                                  width: 150,
                                  height: 30,
                                  child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: []
                                      // currentWorker.reviews != [] ? starList : [],
                                      ),
                                ),
                              ]),
                        ),
                        Card(
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
                                          currentWorker.phone.toString(),
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
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 11, vertical: 9),
                                child: Text(
                                  'المعرض',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              // ImagesGallery(
                              //   images:currentWorker.)
                              // )
                            ],
                          ),
                        ),
                        Card(
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
                                      currentWorker: currentWorker)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ), //delegate tells it how to renders the content of the list
                ]),
        ));
  }
}
