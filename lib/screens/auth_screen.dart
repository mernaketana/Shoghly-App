import 'package:flutter/material.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
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
            const Positioned(top: 290, right: 2, left: 2, child: AuthForm())
          ]),
        ),
      ),
    );
  }
}
