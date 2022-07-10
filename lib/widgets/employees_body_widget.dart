import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../screens/worker_details_screen.dart';
import '../models/employee.dart';

class EmployeesBodyWidget extends StatelessWidget {
  final Employee currentWorker;
  final Employee currentUser;
  const EmployeesBodyWidget({
    Key? key,
    required this.currentWorker,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var starList = <Widget>[];
    List<Widget> createStars(double rate) {
      starList.clear();
      for (var i = 0; i < rate; i++) {
        // print(i);
        starList.add(
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 17,
          ),
        );
      }
      return starList;
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Hero(
        tag: currentWorker.id,
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
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                        child: currentWorker.image == ''
                            ? Image.asset(
                                'assets/images/placeholder.png',
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: currentWorker.image!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const SpinKitSpinningLines(
                                        color: Colors.red),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )),
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
                              '${currentWorker.fname} ${currentWorker.lname}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                              '${currentWorker.location} , ${currentWorker.address}'),
                          SizedBox(
                            width: 100,
                            height: 30,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: currentWorker.avgRate == null
                                  ? []
                                  : createStars(
                                      currentWorker.avgRate!.toDouble()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () => Navigator.of(context)
              .pushNamed(WorkerDetailsScreen.routeName, arguments: {
            'currentWorker': currentWorker,
            'currentUser': currentUser
          }),
        ),
      ),
    );
  }
}
