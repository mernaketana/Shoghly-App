import 'dart:io';

import 'package:flutter/material.dart';
import '../dummy_data.dart';
import '../models/comment.dart';
import '../screens/worker_details_screen.dart';
import '../models/employee.dart';

class EmployeesBodyWidget extends StatelessWidget {
  final String img;
  final String name;
  final String profession;
  final String id;
  // final Employee currentUser;
  const EmployeesBodyWidget({
    Key? key,
    required this.img,
    required this.name,
    required this.profession,
    required this.id,

    // required this.currentUser
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      return avg.round();
    }

    var starList = <Widget>[];
    for (var i = 0;
        i <
            rate(DUMMY_COMMENTS
                .where((element) => element.workerId == id)
                .toList());
        i++) {
      starList.add(
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: 18,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Hero(
        tag: id,
        child: GestureDetector(
            child: Card(
              color: const Color.fromARGB(255, 254, 247, 241),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 10,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              // topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              // bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          child: img == 'assets/images/placeholder.png'
                              ? Image.asset(
                                  img,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  img,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Text(
                                name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            // Text(currentUser.location),
                            SizedBox(
                              width: 100,
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
                          ],
                        ),
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     // const Text(
                    //     //   'التقييم',
                    //     //   style: TextStyle(
                    //     //       fontSize: 14, fontWeight: FontWeight.bold),
                    //     // ),
                    //     // const Text(
                    //     //   ':',
                    //     //   style: TextStyle(
                    //     //       fontSize: 12, fontWeight: FontWeight.bold),
                    //     // ),
                    //     // const SizedBox(
                    //     //   width: 2,
                    //     // ),

                    //   ],
                    // )

                    // Row(
                    //   children: [
                    //     const Text(
                    //       'التقييم',
                    //       style: TextStyle(
                    //           fontSize: 16, fontWeight: FontWeight.bold),
                    //     ),
                    //     const SizedBox(
                    //       width: 5,
                    //     ),
                    //     const Text(
                    //       ':',
                    //       style: TextStyle(
                    //           fontSize: 16, fontWeight: FontWeight.bold),
                    //     ),
                    //     const SizedBox(
                    //       width: 5,
                    //     ),
                    //     Text(
                    //       '${rate(DUMMY_COMMENTS.where((element) => element.workerId == id).toList())}',
                    //       style: const TextStyle(fontSize: 18),
                    //     ),
                    //     const SizedBox(
                    //       width: 5,
                    //     ),
                    //     const Icon(
                    //       Icons.star,
                    //       color: Colors.amber,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            onTap: () {}
            // Navigator.of(context).pushNamed(
            //     WorkerDetailsScreen.routeName,
            //     arguments: {'workerId': id, 'currentUser': currentUser}),
            ),
      ),
    );
  }
}
