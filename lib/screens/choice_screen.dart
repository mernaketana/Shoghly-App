import 'package:flutter/material.dart';
import '../screens/detailed_auth_screen.dart';

class ChoicesScreen extends StatefulWidget {
  static const routeName = '/choice-screen';
  const ChoicesScreen({Key? key}) : super(key: key);

  @override
  State<ChoicesScreen> createState() => _ChoicesScreenState();
}

class _ChoicesScreenState extends State<ChoicesScreen> {
  var _isChosenEmp = false;
  var _isChosenUser = false;
  var role = '';
  @override
  Widget build(BuildContext context) {
    var arguments =
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
                      const CircleAvatar(
                        child: Text('2'),
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      CircleAvatar(
                        child: const Text('1'),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 75,
                  ),
                  const Text(
                    'شــغــلــي',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'هل تريد الاستمرار كعامل ام كمستخدم؟',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isChosenEmp = !_isChosenEmp;
                                _isChosenUser = false;
                                if (_isChosenEmp) {
                                  role = 'worker';
                                } else {
                                  role = '';
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              radius: _isChosenEmp ? 75 : 70,
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/worker.png'),
                                radius: 70,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'عامل',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      Column(children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isChosenUser = !_isChosenUser;
                              _isChosenEmp = false;
                              if (_isChosenUser) {
                                role = 'client';
                              } else {
                                role = '';
                              }
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            radius: _isChosenUser ? 75 : 70,
                            child: const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/user.png'),
                              radius: 70,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'مستخدم',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ])
                    ],
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: role == ''
                          ? () {}
                          : () {
                              Navigator.of(context).pushReplacementNamed(
                                  DetailedAuthScreen.routeName,
                                  arguments: {
                                    'role': role,
                                    'userEmail': arguments['userEmail'],
                                    'userPass': arguments['userPass']
                                  });
                            },
                      child: const Text(
                        'استمرار',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: role == ''
                              ? MaterialStateProperty.all(Colors.grey)
                              : MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white)),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
