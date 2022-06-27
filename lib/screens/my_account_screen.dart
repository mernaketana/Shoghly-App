import 'package:flutter/material.dart';
import 'package:project/widgets/my_account_body.dart';
// import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../dummy_data.dart';
// import '../providers/user.dart';

class MyAccountScreen extends StatelessWidget {
  static const routeName = '/my-account-screen';
  final Employee currentUser;
  const MyAccountScreen({Key? key, required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var comments = DUMMY_COMMENTS
        .where(
          (e) => e.workerId == currentUser.id,
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 247, 241),
      appBar: AppBar(
        title: const Center(child: Text('حسابي الشخصي')),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: MyAccountBody(comments: comments, currentUser: currentUser)),
      ),
    );
  }
}
