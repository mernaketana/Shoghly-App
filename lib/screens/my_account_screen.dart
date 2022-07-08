import 'package:flutter/material.dart';
import 'package:project/models/comment.dart';
import 'package:project/widgets/my_account_body.dart';
import '../models/employee.dart';

class MyAccountScreen extends StatelessWidget {
  static const routeName = '/my-account-screen';
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 247, 241),
      appBar: AppBar(
        title: const Center(child: Text('حسابي الشخصي')),
      ),
      body: const SingleChildScrollView(
        child: Center(child: MyAccountBody()),
      ),
    );
  }
}
