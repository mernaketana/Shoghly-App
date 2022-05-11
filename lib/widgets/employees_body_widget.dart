import 'dart:io';

import 'package:flutter/material.dart';
import '../screens/worker_details_screen.dart';
import '../models/employee.dart';

class EmployeesBodyWidget extends StatelessWidget {
  final String img;
  final String name;
  final String profession;
  final String id;
  final Employee currentUser;
  const EmployeesBodyWidget(
      {Key? key,
      required this.img,
      required this.name,
      required this.profession,
      required this.id,
      required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Hero(
        tag: id,
        child: GestureDetector(
          child: Card(
            color: const Color.fromARGB(255, 254, 247, 241),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                        child: img.startsWith('/data')
                            ? Image.file(File(img))
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(profession),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () => Navigator.of(context).pushNamed(
              WorkerDetailsScreen.routeName,
              arguments: {'workerId': id, 'currentUser': currentUser}),
        ),
      ),
    );
  }
}
