import 'package:flutter/material.dart';
import 'package:project/widgets/my_account_body.dart';

class MyAccountScreen extends StatelessWidget {
  static const routeName = '/my-account-screen';
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Center(child: Text('حسابي الشخصي')),
      ),
      body: const SingleChildScrollView(
        child: Center(child: MyAccountBody()),
      ),
    );
  }
}
