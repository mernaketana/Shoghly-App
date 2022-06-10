import 'package:flutter/material.dart';
import 'package:project/screens/gallery_screen.dart';
import 'package:project/screens/my_account_screen.dart';
import 'package:project/screens/settings_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/controller_screen.dart';
import '../models/employee.dart';
// import 'package:provider/provider.dart';
// // import '../helpers/custom_routes.dart';
// import '../providers/auth.dart';
// import '../screens/user_products_screen.dart';
// import '../screens/orders_screen.dart';

class MyDrawer extends StatelessWidget {
  final Employee currentUser;
  const MyDrawer({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              title: const Text('مرحبا بك'),
              automaticallyImplyLeading: false,
            ), //no back button
            const Divider(),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('حسابي'),
              onTap: () => Navigator.of(context)
                  .pushNamed(MyAccountScreen.routeName, arguments: currentUser),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('الصفحة الرئيسية'),
              onTap: () => Navigator.of(context).pushReplacementNamed(
                  CategoriesScreen.routeName,
                  arguments: currentUser),
            ),
            if (currentUser.role == 'worker') const Divider(),
            if (currentUser.role == 'worker')
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('المعرض'),
                onTap: () {
                  Navigator.of(context).pushNamed(GalleryScreen.routeName,
                      arguments: currentUser);
                },
                // Navigator.of(context).pushReplacement(CustomRoute(builder: (context) => const OrdersScreen(),),)
              ),
            const Divider(),
            Settings(currentUser: currentUser),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('الخروج'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                //Provider.of<Auth>(context, listen: false).logOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final Employee currentUser;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _expand = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 380,
      duration: const Duration(milliseconds: 300),
      height: _expand ? 180 : 70,
      child: Card(
        // color: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('الاعدادات'),
              trailing: IconButton(
                icon: Icon(_expand ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expand = !_expand;
                  });
                },
              ),
            ),
            AnimatedContainer(
              width: 380,
              duration: const Duration(milliseconds: 300),
              height: _expand ? 100 : 0,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expanded(
                    //   child: TextButton(
                    //       onPressed: () => Navigator.of(context).pushNamed(
                    //               SettingsScreen.routeName,
                    //               arguments: {
                    //                 'currentUser': widget.currentUser,
                    //                 'editPass': true
                    //               }),
                    //       child: const Text(
                    //         'الحساب',
                    //         style: TextStyle(color: Colors.black),
                    //       )),
                    // ),
                    // Expanded(
                    //   child: TextButton(
                    //       onPressed: () => Navigator.of(context).pushNamed(
                    //               SettingsScreen.routeName,
                    //               arguments: {
                    //                 'currentUser': widget.currentUser,
                    //                 'editPass': false
                    //               }),
                    //       child: const Text(
                    //         'المعلومات الشخصية',
                    //         style: TextStyle(color: Colors.black),
                    //       )),
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
