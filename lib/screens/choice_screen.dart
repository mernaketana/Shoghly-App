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
        backgroundColor: const Color.fromARGB(255, 254, 247, 241),
        body: Padding(
            padding: const EdgeInsets.only(top: 70),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircleAvatar(
                        child: Text('2'),
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      CircleAvatar(
                        child: Text('1'),
                        backgroundColor: Colors.red,
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
                                // print(role);
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
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
                              // print(role);
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
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
                              : MaterialStateProperty.all(Colors.red),
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

//     final currentUser =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     print(currentUser);
//     return Scaffold(
//       backgroundColor: Colors.red,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           choice(context, true, Icons.account_box, 'اكمل كمستخدم',
//               currentUser['userEmail'], currentUser['userPass'], Colors.amber),
//           choice(context, false, Icons.assignment_ind, 'اكمل كعامل',
//               currentUser['userEmail'], currentUser['userPass'], Colors.blue),
//         ],
//       ),
//     );
//   }

//   Flexible choice(BuildContext context, bool isUser, IconData icon,
//       String choiceText, String email, String pass, Color color) {
//     return Flexible(
//       fit: FlexFit.tight,
//       child: InkWell(
//         onTap: () => Navigator.of(context)
//             .pushNamed(DetailedAuthScreen.routeName, arguments: {
//           'isUser': isUser,
//           'userEmail': email,
//           'userPass': pass
//         }),
//         child: Container(
//           color: color,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 size: 150,
//                 color: Colors.white,
//               ),
//               Text(
//                 choiceText,
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
