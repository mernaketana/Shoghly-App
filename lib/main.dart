import 'package:flutter/material.dart';
import 'package:project/screens/detailed_image_screen.dart';
import 'package:project/screens/settings_screen.dart';
import './screens/gallery_screen.dart';
import './screens/detailed_auth_screen.dart';
import './screens/worker_details_screen.dart';
import './screens/choice_screen.dart';
import './screens/auth_screen.dart';
import './screens/employees_screen.dart';
import './screens/categories_screen.dart';
import './screens/my_account_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
            .copyWith(secondary: Colors.grey),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))))),
      ),
      routes: {
        '/': (context) => const AuthScreen(),
        CategoriesScreen.routeName: (context) => const CategoriesScreen(),
        EmployeesScreen.routeName: (context) => const EmployeesScreen(),
        ChoicesScreen.routeName: (context) => const ChoicesScreen(),
        DetailedAuthScreen.routeName: (context) => const DetailedAuthScreen(),
        WorkerDetailsScreen.routeName: (context) => const WorkerDetailsScreen(),
        MyAccountScreen.routeName: (context) => const MyAccountScreen(),
        GalleryScreen.routeName: (context) => const GalleryScreen(),
        DetailedImageScreen.routeName: (context) => const DetailedImageScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
      },
    );
  }
}
