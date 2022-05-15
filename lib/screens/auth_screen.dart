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
        backgroundColor: const Color.fromARGB(255, 254, 247, 241),
        body: Center(
          child: Stack(children: [
            // ClipPath(
            //   clipper: Background(),
            //   child: Container(
            //     color: Colors.white,
            //   ),
            // ),
            Positioned(
              top: 80,
              right: 2,
              left: 2,
              child: Image.asset('assets/images/auth.gif'),
            ),
            Positioned(
                top: deviceSize.height / 3.002,
                right: deviceSize.width / 200,
                left: deviceSize.width / 200,
                child: const AuthForm())
          ]),
        ),
      ),
    );
  }
}
