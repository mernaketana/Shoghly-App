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
import 'categories_screen.dart';

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({Key? key}) : super(key: key);

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  ImageSource? source;
  var newWorkImage = MyImage('', [], '');
  late Employee currentUser;
  int _selectedPageIndex = 0;
  var _isLoading = false;
  var _isInit =
      true; //we implement this so that we make sure didChangeDependencies executes only one time

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      // print('didchange categories');
      final userId = Provider.of<User>(context, listen: false).userId;
      await Provider.of<User>(context)
          .getUser(userId)
          .then((value) => currentUser = value);
      // .then((_) {
      //   currentUser =
      //       Provider.of<User>(context, listen: false).currentUser as Employee;
      //   // print(currentUser.id);
      setState(() {
        _isLoading = false;
      });
      // });
    }
    _isInit = false;
  }

  void onTap(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // Future<void> _pickedImageGallery() async {
  //   try {
  //     final picker = ImagePicker();
  //     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
  //     if (pickedImage == null) return;
  //     setState(() {
  //       if (!DUMMY_IMAGES.any((element) => element.userId == userId)) {
  //         newWorkImage =
  //             MyImage(DateTime.now().toString(), [(pickedImage.path)], userId);
  //         DUMMY_IMAGES.add(newWorkImage);
  //       } else {
  //         DUMMY_IMAGES
  //             .firstWhere((element) => element.userId == userId)
  //             .url!
  //             .add(pickedImage.path);
  //       }
  //     });
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  // }

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

  Future<void> getCurrentUser(BuildContext context) async {
    _isLoading = true;
    final userId = Provider.of<User>(context, listen: false).userId;
    await Provider.of<User>(context, listen: false)
        .getUser(userId)
        .then((value) => currentUser = value);
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _workerPages = [
      _isLoading
          ? Container()
          : RefreshIndicator(
              onRefresh: () => getCurrentUser(context),
              child: MyAccountScreen(currentUser: currentUser)),
      _isLoading
          ? Container()
          : CategoriesScreen(
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
      _isLoading ? Container() : CategoriesScreen(currentUser: currentUser),
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
              // drawer: MyDrawer(currentUser: currentUser),

              body: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : currentUser.role == 'worker'
                      ? _workerPages[_selectedPageIndex]
                      : _userPages[_selectedPageIndex],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.red,
                selectedItemColor: Colors.white,
                unselectedItemColor: const Color.fromARGB(170, 219, 219, 219),
                items: currentUser.role == 'worker'
                    ? const [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.account_circle), label: 'حسابي'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.category), label: 'الحرف'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.photo_library), label: 'معرضي'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.settings), label: 'الاعدادات'),
                      ]
                    : const [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.account_circle), label: 'حسابي'),
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
