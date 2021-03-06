import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../providers/chat.dart';
import '../providers/favourites.dart';
import '../providers/images.dart';
import '../providers/user.dart';
import '../screens/add_project_screen.dart';
import '../screens/detailed_image_screen.dart';
import '../screens/detailed_project_screen.dart';
import '../screens/single_chat_screen.dart';
import './screens/detailed_auth_screen.dart';
import './screens/worker_details_screen.dart';
import './screens/choice_screen.dart';
import './screens/auth_screen.dart';
import './screens/employees_screen.dart';
import './screens/page_controller_screen.dart';
import './providers/auth.dart';
import './providers/project.dart';
import './providers/review.dart';
import './providers/worker.dart';
import './widgets/settings_body_widget.dart';
import './widgets/splash_screen.dart';

void main() async {
  await dotenv.load();
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
