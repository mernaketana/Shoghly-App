import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project/models/employee.dart';
import '../models/comment.dart';
import '../widgets/images_gallery_widget.dart';

import '../widgets/comments.dart';
import '../dummy_data.dart';

class WorkerDetailsScreen extends StatefulWidget {
  const WorkerDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/worker-detail-screen';

  @override
  State<WorkerDetailsScreen> createState() => _WorkerDetailsScreenState();
}

class _WorkerDetailsScreenState extends State<WorkerDetailsScreen> {
  var starList = <Widget>[];
  int rate(List<Comment> rates) {
    double sum = 0;
    for (var i = 0; i < rates.length; i++) {
      sum += (rates[i].rate!);
    }
    double avg = 0;
    // ignore: prefer_is_empty
    if (rates.length != 0) {
      avg = sum / rates.length;
    } else {
      avg = 0;
    }
    // print(avg.round());

    // print(avg.round());
    return avg.round();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final id = arguments['workerId'];
    final currentUser = arguments['currentUser'] as Employee;
    final user = DUMMY_EMP.firstWhere((e) => e.id == id);
    starList.clear();
    for (var i = 0;
        i <
            rate(DUMMY_COMMENTS
                .where((element) => element.workerId == id)
                .toList());
        i++) {
      // print(i);
      starList.add(
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: 20,
        ),
      );
      // print(starList.length);
    }

    // print(starList.length);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          // drawer: MyDrawer(isUser: user.isUser),
          // appBar: AppBar(
          //   title: const Text('شغلي'),
          //   actions: <Widget>[
          //     IconButton(onPressed: () {}, icon: const Icon(Icons.messenger)),
          //     IconButton(
          //         onPressed: () {}, icon: const Icon(Icons.notifications)),
          //   ],
          // ),
          // body: Card(
          //   margin: const EdgeInsets.all(15),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         children: <Widget>[
          //           Container(
          //             alignment: Alignment.center,
          //             height: 170,
          //             width: 170,
          //             child: Image.network(
          //               user.image as String,
          //               fit: BoxFit.cover,
          //               width: double.infinity,
          //             ),
          //           ),
          //           const SizedBox(
          //             width: 20,
          //           ),
          //           Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: <Widget>[
          //               Text(user.name),
          //               Text(user.location),
          //               Text(user.categordId as String),
          //               // rate
          //             ],
          //           ),
          //           // IconButton(
          //           //     onPressed: () {}, icon: const Icon(Icons.favorite))
          //         ],
          //       ),
          //     ],
          //   ),
          // )
          body: CustomScrollView(// slivers are scrollable areas on the screen
              slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                tag: user.id,
                child: user.image!.startsWith('/data')
                    ? Image.file(
                        File(user.image as String),
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        user.image as String,
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
                            '${user.fname} ${user.lname}',
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
                              children: DUMMY_COMMENTS
                                          .where((element) =>
                                              element.workerId == id)
                                          .toList() !=
                                      []
                                  ? starList
                                  : [],
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                          child: Text(
                            'المعلومات',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 22, bottom: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                user.categordId as String,
                              ),
                              Text(
                                user.location,
                              ),
                              Text(
                                user.address,
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
                                    user.phone.toString(),
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
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                          child: Text(
                            'المعرض',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        if (DUMMY_IMAGES
                            .any((element) => element.userId == user.id))
                          ImagesGallery(
                            images: DUMMY_IMAGES
                                .firstWhere(
                                    (element) => element.userId == user.id)
                                .url as List<String>,
                          )
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                          child: Text(
                            'التعليقات',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                            height: 200,
                            child: Comments(
                                items: DUMMY_COMMENTS,
                                userId: currentUser.id,
                                workerId: id)),
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
