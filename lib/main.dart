import 'package:flutter/material.dart';
import 'package:project/providers/images.dart';
import 'package:project/providers/user.dart';
import 'package:project/screens/add_project_screen.dart';
import 'package:project/screens/detailed_image_screen.dart';
import 'package:project/widgets/settings_body_widget.dart';
import 'package:provider/provider.dart';
import './screens/detailed_auth_screen.dart';
import './screens/worker_details_screen.dart';
import './screens/choice_screen.dart';
import './screens/auth_screen.dart';
import './screens/employees_screen.dart';
import './screens/controller_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './providers/auth.dart';
import 'providers/project.dart';
import 'providers/review.dart';
import 'providers/worker.dart';
import 'widgets/splash_screen.dart';

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
        ],
        child: Consumer<Auth>(
            builder: ((context, value, _) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    backgroundColor: const Color.fromARGB(255, 254, 247, 241),
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
                    ChoicesScreen.routeName: (context) => const ChoicesScreen(),
                    DetailedAuthScreen.routeName: (context) =>
                        const DetailedAuthScreen(),
                    DetailedImageScreen.routeName: (context) =>
                        const DetailedImageScreen(),
                    SettingsBody.routeName: (context) => const SettingsBody(),
                    AddProjectScreen.routeName: (context) =>
                        const AddProjectScreen(),
                  },
                ))));
  }
}
