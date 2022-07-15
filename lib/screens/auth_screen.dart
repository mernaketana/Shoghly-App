import 'package:flutter/material.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Stack(children: [
            Positioned(
              top: deviceSize.height - 810,
              right: deviceSize.height - 865,
              left: deviceSize.height - 880,
              child: Image.asset(
                'assets/images/auth.gif',
                height: 340,
              ),
            ),
            Positioned(
                top: deviceSize.height / 2.6,
                right: deviceSize.width / 200,
                left: deviceSize.width / 200,
                child: const AuthForm())
          ]),
        ),
      ),
    );
  }
}
