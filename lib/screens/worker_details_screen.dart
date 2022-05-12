import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  // int rate(List<Comment> rates) {
  //   double sum = 0;
  //   for (var i = 0; i < rates.length; i++) {
  //     sum += (rates[i].rate!) / (rates.length - 1);
  //   }
  //   return sum.round();
  // }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final id = arguments['workerId'];
    final currentUser = arguments['currentUser'] as Employee;
    final user = DUMMY_EMP.firstWhere((e) => e.id == id);
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
                    child: Column(
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
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(user.location),
                          )
                        ]),
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
