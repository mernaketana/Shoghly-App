import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/models/comment.dart';
import 'package:project/models/employee.dart';
import 'package:project/screens/chat_screen.dart';
import 'package:project/screens/favourites_screen.dart';
import 'package:project/screens/gallery_screen.dart';
import 'package:project/screens/settings_screen.dart';
import 'package:project/widgets/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/image.dart';
import '../providers/user.dart';
import '../providers/worker.dart';
import '../screens/my_account_screen.dart';
import 'categories_screen.dart';

class PageControllerScreen extends StatefulWidget {
  const PageControllerScreen({Key? key}) : super(key: key);

  @override
  State<PageControllerScreen> createState() => _PageControllerScreenState();
}

class _PageControllerScreenState extends State<PageControllerScreen> {
  ImageSource? source;
  var newWorkImage = MyImage('', [], '');
  late Employee currentUser;
  late List<Comment> comments;
  int _selectedPageIndex = 0;
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final userId = Provider.of<User>(context, listen: false).userId;
      await Provider.of<User>(context)
          .getUser(userId)
          .then((value) => currentUser = value);
      if (currentUser.role == 'worker') {
        print('I am a worker');
        final workerProfile = await Provider.of<Worker>(context, listen: false)
            .getWorker((userId));
        comments = workerProfile['workerComments'];
        print(comments);
      }
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  void onTap(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // Future<void> getCurrentUser(BuildContext context) async {
  //   _isLoading = true;
  //   final userId = Provider.of<User>(context, listen: false).userId;
  //   await Provider.of<User>(context, listen: false)
  //       .getUser(userId)
  //       .then((value) => currentUser = value);
  //   _isLoading = false;
  // }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = _isLoading
        ? []
        : currentUser.role == 'worker'
            ? const [
                MyAccountScreen(),
                CategoriesScreen(),
                GalleryScreen(),
                ChatScreen(),
                MainSettingsScreen(),
              ]
            : const [
                MyAccountScreen(),
                CategoriesScreen(),
                FavouritesScreen(),
                ChatScreen(),
                MainSettingsScreen(),
              ];

    final List<BottomNavigationBarItem> _items = _isLoading
        ? []
        : currentUser.role == 'worker'
            ? const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle), label: 'حسابي'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.category), label: 'الحرف'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.photo_library), label: 'معرضي'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat), label: 'المحادثات'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'الاعدادات'),
              ]
            : const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle), label: 'حسابي'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.category), label: 'الحرف'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: 'المفضلات'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat), label: 'المحادثات'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'الاعدادات'),
              ];

    return _isLoading
        ? const SplashScreen()
        : Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: _isLoading
                  ? const Center(child: SpinKitSpinningLines(color: Colors.red))
                  : _pages[_selectedPageIndex],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.red,
                selectedItemColor: Colors.white,
                unselectedItemColor: const Color.fromARGB(170, 219, 219, 219),
                items: _items,
                onTap: onTap,
                currentIndex: _selectedPageIndex,
              ),
            ));
  }
}
