import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/models/employee.dart';
import 'package:project/screens/gallery_screen.dart';
import 'package:project/screens/settings_screen.dart';
import 'package:project/widgets/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../providers/auth.dart';
import '../models/image.dart';
import '../providers/images.dart';
import '../providers/user.dart';
import '../screens/my_account_screen.dart';
import '../widgets/categories_body_widget.dart';
import '../dummy_data.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categories-screen';
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  ImageSource? source;
  var newWorkImage = MyImage('', [], '');
  late Employee currentUser;
  int _selectedPageIndex = 0;
  var _isLoading = false;
  var _isInit =
      true; //we implement this so that we make sure didChangeDependencies executes only one time

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      // print('didchange categories');
      Provider.of<User>(context).getUser().then((_) {
        currentUser =
            Provider.of<User>(context, listen: false).currentUser as Employee;
        // print(currentUser.id);
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  void onTap(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Future _dialog(BuildContext context, String userId) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          content: const Text(
            'قم باختيار مصدر الصورة',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              child: const Text('الكاميرا'),
              onPressed: () {
                _pickedImageCamera(userId);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('المعرض'),
              onPressed: () {
                _pickedImageGallery(userId);
                Navigator.of(context).pop();
              },
            ),
          ]),
    );
    // Navigator.of(context).pop();
  }

  Future<void> _pickedImageCamera(String userId) async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage == null) return;
      await Provider.of<Images>(context, listen: false)
          .addImage(pickedImage.path);
      // final pickedImageFile = File(pickedImage.path);
      // setState(() {
      //   _image = pickedImage.path;
      // });
      // setState(() {
      //   if (!DUMMY_IMAGES.any((element) => element.userId == userId)) {
      //     newWorkImage =
      //         MyImage(DateTime.now().toString(), [(pickedImage.path)], userId);
      //     // for (var i in DUMMY_IMAGES) {
      //     //   // print(i.userId);
      //     //   // print(i.url);
      //     //   // print(i.id);
      //     // }
      //     // print('me');
      //     // var new_user_img = MyImage(
      //     //     DateTime.now().toString(), ['${pickedImage.path}'], userId);
      //     // print(newWorkImage.url);
      //     DUMMY_IMAGES.add(newWorkImage);
      //   } else {
      //     // print('or me');
      //     DUMMY_IMAGES
      //         .firstWhere((element) => element.userId == userId)
      //         .url!
      //         .add(pickedImage.path);
      //   }
      // });
      // widget.imagePick(pickedImageFile);
    } on PlatformException catch (_) {
      return;
      // ignore: avoid_print
      // print(e);
    }
  }

  Future<void> _pickedImageGallery(String userId) async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;
      // final pickedImageFile = File(pickedImage.path);
      // setState(() {
      //   _image = pickedImage.path;
      // });
      setState(() {
        if (!DUMMY_IMAGES.any((element) => element.userId == userId)) {
          newWorkImage =
              MyImage(DateTime.now().toString(), [(pickedImage.path)], userId);
          // var new_user_img = MyImage(
          //     DateTime.now().toString(), ['${pickedImage.path}'], userId);
          // print(newWorkImage.url);
          DUMMY_IMAGES.add(newWorkImage);
        } else {
          DUMMY_IMAGES
              .firstWhere((element) => element.userId == userId)
              .url!
              .add(pickedImage.path);
        }
      });
      // widget.imagePick(pickedImageFile);
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // void showModalBottomSheetFunction() {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: 100,
  //         color: const Color.fromARGB(255, 254, 247, 241),
  //         child: Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               TextButton(
  //                 child: const Text('تعديل معلومات حسابي '),
  //                 onPressed: () {
  //                   setState(() {
  //                     _settings == 4;
  //                     print(_settings);
  //                   });
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //               TextButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       _settings == 5;
  //                     });
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text('تعديل معلوماتي الشخصية'))
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _workerPages = [
      _isLoading ? Container() : MyAccountScreen(currentUser: currentUser),
      _isLoading
          ? Container()
          : categoriesScreen(
              currentUser: currentUser,
            ),
      _isLoading ? Container() : GalleryScreen(currentUser: currentUser),
      _isLoading
          ? Container()
          : MainSettingsScreen(
              currentUser: currentUser,
            ),
    ];
    final List<Widget> _userPages = [
      _isLoading ? Container() : MyAccountScreen(currentUser: currentUser),
      _isLoading ? Container() : categoriesScreen(currentUser: currentUser),
      _isLoading
          ? Container()
          : MainSettingsScreen(
              currentUser: currentUser,
            ),
    ];
    // print(currentUser.role);

    return _isLoading
        ? const SplashScreen()
        : Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: const Color.fromARGB(255, 254, 247, 241),
              // drawer: MyDrawer(currentUser: currentUser),
              floatingActionButton: currentUser.role == 'worker'
                  ? _selectedPageIndex == 2
                      ? FloatingActionButton(
                          onPressed: () => _dialog(context, currentUser.id),
                          child: const Icon(Icons.add),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        )
                      : null
                  : null,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.red,
                title: const Center(
                  child: Text(
                    'شغلي',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // actions: const [
                //   // IconButton(onPressed: () {}, icon: const Icon(Icons.messenger)),
                //   // SingleChildScrollView(
                //   //   child: PopupMenuButton(
                //   //       icon: const Icon(Icons.notifications),
                //   //       itemBuilder: (BuildContext context) {
                //   //         List<PopupMenuItem> commentsList = [];
                //   //         print(comments.length);
                //   //         for (var i = 0; i < comments.length; i++) {
                //   //           print(i);
                //   //           var user = DUMMY_EMP
                //   //               .firstWhere((e) => e.id == comments[i].userId);
                //   //           commentsList.add(PopupMenuItem(
                //   //               child: ListTile(
                //   //             leading: Container(
                //   //               height: 20,
                //   //               width: 20,
                //   //               decoration: BoxDecoration(
                //   //                   borderRadius: BorderRadius.circular(10)),
                //   //               child: CircleAvatar(
                //   //                   maxRadius: 10,
                //   //                   backgroundImage: user.image != null
                //   //                       ? user.image!.startsWith('/data')
                //   //                           ? FileImage(File(user.image as String))
                //   //                           : NetworkImage(user.image as String)
                //   //                               as ImageProvider<Object>
                //   //                       : const AssetImage(
                //   //                           'assets/images/placeholder.png')),
                //   //             ),
                //   //             title: Text('${user.fname} ${user.lname}'),
                //   //             subtitle: Text(comments[i].comment),
                //   //           )));
                //   //         }
                //   //         print(commentsList);
                //   //         return commentsList;
                //   //       }),
                //   // )
                // ],
              ),
              body: _isLoading
                  ? const CircularProgressIndicator()
                  :
                  // _workerPages[1],
                  currentUser.role == 'worker'
                      ? _workerPages[_selectedPageIndex]
                      : _userPages[_selectedPageIndex],
              bottomNavigationBar: BottomNavigationBar(
                // fixedColor: Colors.red,
                type: BottomNavigationBarType.fixed,
                // fixedColor: Colors.white,
                backgroundColor: Colors.red,
                selectedItemColor: Colors.white,
                unselectedItemColor: const Color.fromARGB(170, 219, 219, 219),
                items:
                    // [
                    //   BottomNavigationBarItem(
                    //       icon: Icon(Icons.account_circle), label: 'حسابي'),
                    //   BottomNavigationBarItem(
                    //       icon: Icon(Icons.category), label: 'الحرف'),
                    //   BottomNavigationBarItem(
                    //       icon: Icon(Icons.settings), label: 'الاعدادات'),
                    // ],
                    currentUser.role == 'worker'
                        ? const [
                            BottomNavigationBarItem(
                                icon: Icon(Icons.account_circle),
                                label: 'حسابي'),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.category), label: 'الحرف'),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.photo_library),
                                label: 'معرضي'),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.settings), label: 'الاعدادات'),
                          ]
                        : const [
                            BottomNavigationBarItem(
                                icon: Icon(Icons.account_circle),
                                label: 'حسابي'),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.category), label: 'الحرف'),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.settings), label: 'الاعدادات'),
                          ],
                onTap: onTap,
                currentIndex: _selectedPageIndex,
              ),
            ));
  }
}

// ignore: camel_case_types
class categoriesScreen extends StatelessWidget {
  const categoriesScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final Employee currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: GridView(
        children: <Widget>[
          ...DUMMY_CATEGORIES
              .map((e) => CategoriesBodyWidget(
                  backgroundImg: e.img,
                  title: e.title,
                  currentUser: currentUser))
              .toList(),
        ],
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 2.7 / 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        padding: const EdgeInsets.all(25),
      ),
    );
  }
}

// class settings extends StatelessWidget {
//   const settings({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return showModalBottomSheet(
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), //for the round edges
//     builder: (context) {
//         return Container(
//             //specify height, so that it does not fill the entire screen
//             child: Column(children: []) //what you want to have inside, I suggest using a column
//         );
//     }
//     context: context,
//     isDismissible: //boolean if you want to be able to dismiss it
//     isScrollControlled: //boolean if something does not display, try that
// );;
//   }
// }

// class notification extends StatefulWidget {
//   const notification({
//     Key? key,
//     required this.comments,
//   }) : super(key: key);

//   final List<Comment> comments;

//   @override
//   State<notification> createState() => _notificationState();
// }

// class _notificationState extends State<notification> {
//   @override
//   Widget build(BuildContext context) {
//     var _expand = false;
//     return AnimatedContainer(
//       width: 50,
//       duration: const Duration(milliseconds: 300),
//       height: 100,
//       child: SizedBox(
//         width: 50,
//         child: Column(
//           children: [
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     _expand = !_expand;
//                     print(_expand);
//                   });
//                 },
//                 icon: const Icon(Icons.notifications)),
//             AnimatedContainer(
//               width: 50,
//               duration: const Duration(milliseconds: 300),
//               height: _expand ? 100 : 0,
//               margin: const EdgeInsets.all(2),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.only(right: 60),
//                 child: ListView.builder(
//                   itemBuilder: (context, index) {
//                     var user = DUMMY_EMP.firstWhere(
//                         (e) => e.id == widget.comments[index].userId);
//                     return Expanded(
//                       child: Padding(
//                           padding: const EdgeInsets.all(6),
//                           child: ListTile(
//                             leading: Container(
//                               height: 40,
//                               width: 40,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10)),
//                               child: CircleAvatar(
//                                   maxRadius: 20,
//                                   backgroundImage: user.image != null
//                                       ? user.image!.startsWith('/data')
//                                           ? FileImage(
//                                               File(user.image as String))
//                                           : NetworkImage(user.image as String)
//                                               as ImageProvider<Object>
//                                       : const AssetImage(
//                                           'assets/images/placeholder.png')),
//                             ),
//                             title: Text('${user.fname} ${user.lname}'),
//                             subtitle: Text(widget.comments[index].comment),
//                           )),
//                     );
//                   },
//                   itemCount: widget.comments.length,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
