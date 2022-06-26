import 'package:flutter/material.dart';
import 'package:project/providers/images.dart';
import 'package:project/providers/user.dart';
import 'package:project/screens/detailed_image_screen.dart';
import 'package:project/screens/settings_screen.dart';
import 'package:project/widgets/settings_body_widget.dart';
import 'package:provider/provider.dart';
// import './screens/gallery_screen.dart';
import './screens/detailed_auth_screen.dart';
import './screens/worker_details_screen.dart';
import './screens/choice_screen.dart';
import './screens/auth_screen.dart';
import './screens/employees_screen.dart';
import './screens/controller_screen.dart';
import './screens/categories_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import './screens/my_account_screen.dart';
import './providers/auth.dart';
import 'providers/review.dart';
import 'providers/worker.dart';
import 'widgets/splashScreen.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (context) => Images(),
          ),
          ChangeNotifierProxyProvider<Auth, User>(
            create: (context) => User(),
            update: (context, auth, notifier) => notifier!..recieveToken(auth),
          ),
          ChangeNotifierProxyProvider<Auth, Review>(
            create: (context) => Review(),
            update: (context, auth, notifier) => notifier!..recieveToken(auth),
          ),
          ChangeNotifierProxyProvider<Auth, Images>(
            create: (context) => Images(),
            update: (context, auth, notifier) => notifier!..recieveToken(auth),
          ),
          ChangeNotifierProvider(
            create: (context) => Worker(),
          ),
          ChangeNotifierProxyProvider<Auth, Worker>(
            create: (context) => Worker(),
            update: (context, auth, notifier) => notifier!..recieveToken(auth),
          ),
          // ChangeNotifierProxyProvider<Images, Auth>(
          //   create: (context) => Auth(),
          //   update: (context, image, notifier) =>
          //       notifier!..recieveImageUrl(image),
          // ),
          // ChangeNotifierProvider(
          //   create: (context) => Cart(),
          // ),
          // ChangeNotifierProxyProvider<Auth, Orders>(
          //   create: (context) => Orders(),
          //   update: (context, auth, previousOrders) =>
          //       previousOrders!..recieveToken(auth, previousOrders.orders),
          // ),
        ],
        child: Consumer<Auth>(
            builder: ((context, value, _) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSwatch(primarySwatch: Colors.red)
                            .copyWith(secondary: Colors.grey),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))))),
                  ),
                  home: value.isAuth
                      ? const ControllerScreen()
                      : FutureBuilder(
                          future: value.tryAutoLogIn(),
                          builder: (context, snapshot) =>
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? const SplashScreen()
                                  : const AuthScreen(),
                        ),
                  onGenerateRoute: (RouteSettings settings) {
                    var routes = <String, WidgetBuilder>{
                      EmployeesScreen.routeName: (ctx) => EmployeesScreen(
                          arguments:
                              settings.arguments as Map<String, dynamic>),
                      WorkerDetailsScreen.routeName: (ctx) =>
                          WorkerDetailsScreen(
                              arguments:
                                  settings.arguments as Map<String, dynamic>),
                    };
                    WidgetBuilder? builder = routes[settings.name];
                    return MaterialPageRoute(builder: (ctx) => builder!(ctx));
                  },
                  routes: {
                    // '/': (context) => const AuthScreen(),
                    // EmployeesScreen.routeName: (context) => EmployeesScreen(),
                    ChoicesScreen.routeName: (context) => const ChoicesScreen(),
                    DetailedAuthScreen.routeName: (context) =>
                        const DetailedAuthScreen(),
                    // WorkerDetailsScreen.routeName: (context) =>
                    //     const WorkerDetailsScreen(),
                    // MyAccountScreen.routeName: (context) =>
                    //     const MyAccountScreen(),
                    // GalleryScreen.routeName: (context) => const GalleryScreen(),
                    DetailedImageScreen.routeName: (context) =>
                        const DetailedImageScreen(),
                    SettingsBody.routeName: (context) => const SettingsBody(),
                  },
                ))));
  }
}
