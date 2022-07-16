import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:project/providers/chat.dart';
import 'package:project/providers/favourites.dart';
import 'package:project/providers/images.dart';
import 'package:project/providers/user.dart';
import 'package:project/screens/add_project_screen.dart';
import 'package:project/screens/detailed_image_screen.dart';
import 'package:project/screens/detailed_project_screen.dart';
import 'package:project/screens/single_chat_screen.dart';
import 'package:project/widgets/settings_body_widget.dart';
import 'package:provider/provider.dart';
import './screens/detailed_auth_screen.dart';
import './screens/worker_details_screen.dart';
import './screens/choice_screen.dart';
import './screens/auth_screen.dart';
import './screens/employees_screen.dart';
import 'screens/page_controller_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './providers/auth.dart';
import 'providers/project.dart';
import 'providers/review.dart';
import 'providers/worker.dart';
import 'widgets/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:native_notify/native_notify.dart';

void main() async {
  await dotenv.load();
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // NotificationSettings settings = await firebaseMessaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     sound: true,
  //     criticalAlert: false,
  //     provisional: false,
  //     carPlay: false);
  // FirebaseMessaging.onMessage.listen((message) {
  //   print(message.data);
  // });
  // FirebaseMessaging.onBackgroundMessage(FirebaseMessagingBackgroundHandler);
  // String id = await FirebaseInstallations.instance.getId();
  // print(id);
  // print('user granted permission ${settings.authorizationStatus}');
  WidgetsFlutterBinding.ensureInitialized();
  NativeNotify.initialize(1119, 'wLzxM3KpqXUF1xxgw5Lb7r', null, null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          ChangeNotifierProvider(
            create: (context) => Project(),
          ),
          ChangeNotifierProxyProvider<Auth, Project>(
            create: (context) => Project(),
            update: (context, auth, notifier) => notifier!..recieveToken(auth),
          ),
          ChangeNotifierProvider(
            create: (context) => Favourites(),
          ),
          ChangeNotifierProxyProvider<Auth, Favourites>(
            create: (context) => Favourites(),
            update: (context, auth, notifier) => notifier!..recieveToken(auth),
          ),
          ChangeNotifierProvider(
            create: (context) => Chat(),
          ),
          ChangeNotifierProxyProvider<Auth, Chat>(
            create: (context) => Chat(),
            update: (context, auth, notifier) => notifier!..recieveToken(auth),
          ),
        ],
        child: Consumer<Auth>(
            builder: ((context, value, _) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    fontFamily: 'ReadexPro',
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    colorScheme: const ColorScheme.light(
                      primary: Color(
                        0xFF104fa2,
                      ),
                    ).copyWith(secondary: Colors.grey),
                    iconTheme: const IconThemeData(color: Colors.white),
                    textTheme: const TextTheme(
                        bodyText1: TextStyle(color: Colors.white)),
                    textButtonTheme: TextButtonThemeData(
                        style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    )),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))))),
                  ),
                  home: value.isAuth
                      ? const PageControllerScreen()
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
                      DetailedProjectScreen.routeName: (ctx) =>
                          DetailedProjectScreen(
                              arguments:
                                  settings.arguments as Map<String, dynamic>),
                      SingleChatScreen.routeName: (ctx) => SingleChatScreen(
                          arguments:
                              settings.arguments as Map<String, dynamic>),
                      AddProjectScreen.routeName: (ctx) => AddProjectScreen(
                          arguments: settings.arguments as Map<String, dynamic>)
                    };
                    WidgetBuilder? builder = routes[settings.name];
                    return MaterialPageRoute(builder: (ctx) => builder!(ctx));
                  },
                  routes: {
                    ChoicesScreen.routeName: (context) => const ChoicesScreen(),
                    DetailedAuthScreen.routeName: (context) =>
                        const DetailedAuthScreen(),
                    DetailedImageScreen.routeName: (context) =>
                        const DetailedImageScreen(),
                    SettingsBody.routeName: (context) => const SettingsBody(),
                  },
                ))));
  }
}
