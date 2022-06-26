import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:project/widgets/settings_body_widget.dart';
import 'package:provider/provider.dart';

import '../dummy_data.dart';
import '../models/employee.dart';
import '../providers/auth.dart';
import '../providers/user.dart';
import '../widgets/user_image_picker.dart';

class MainSettingsScreen extends StatelessWidget {
  const MainSettingsScreen({Key? key, required this.currentUser})
      : super(key: key);
  final Employee currentUser;

  @override
  Widget build(BuildContext context) {
    // print(currentUser.gender);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 247, 241),
      appBar: AppBar(
        title: const Center(child: Text('الاعدادات')),
      ),
      body: Column(
        children: [
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)),
            child: ListTile(
                tileColor: const Color.fromARGB(255, 254, 247, 241),
                title: const Text('تعديل حسابي'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.of(context).pushNamed(
                    SettingsBody.routeName,
                    arguments: {'currentUser': currentUser, 'editPass': true})),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)),
            child: ListTile(
                tileColor: const Color.fromARGB(255, 254, 247, 241),
                title: const Text('تعديل معلوماتي'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.of(context)
                        .pushNamed(SettingsBody.routeName, arguments: {
                      'currentUser': currentUser,
                      'editPass': false
                    })),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)),
            child: ListTile(
                tileColor: const Color.fromARGB(255, 254, 247, 241),
                title: const Text('تعطيل الحساب'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {}),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)),
            child: ListTile(
                tileColor: const Color.fromARGB(255, 254, 247, 241),
                title: const Text('تسجيل الخروج'),
                trailing: const Icon(Icons.logout),
                onTap: () {
                  // Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<Auth>(context, listen: false).logOut();
                }),
          ),
        ],
      ),
    );
  }
}
