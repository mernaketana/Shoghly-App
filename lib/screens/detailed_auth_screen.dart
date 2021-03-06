import 'package:flutter/material.dart';

import '../widgets/detailed_auth_form.dart';

class DetailedAuthScreen extends StatefulWidget {
  const DetailedAuthScreen({Key? key}) : super(key: key);
  static const routeName = '/detailed-auth-screen';

  @override
  State<DetailedAuthScreen> createState() => _DetailedAuthScreenState();
}

class _DetailedAuthScreenState extends State<DetailedAuthScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Padding(
            padding: const EdgeInsets.only(top: 70),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        child: const Text('2'),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      const CircleAvatar(
                        child: Text('1'),
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                  DetailedAuthForm(
                    role: arguments['role'],
                    userEmail: arguments['userEmail'],
                    userPass: arguments['userPass'],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
