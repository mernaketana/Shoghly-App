import 'package:flutter/material.dart';
import 'package:project/screens/detailed_image_screen.dart';
import 'package:project/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import './screens/gallery_screen.dart';
import './screens/detailed_auth_screen.dart';
import './screens/worker_details_screen.dart';
import './screens/choice_screen.dart';
import './screens/auth_screen.dart';
import './screens/employees_screen.dart';
import './screens/categories_screen.dart';
import './screens/my_account_screen.dart';
import 'providers/Auth.dart';

void main() {
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
          // ChangeNotifierProxyProvider<Auth, Products>(
          //   create: (context) => Products(),
          //   update: (context, auth, previousProduct) =>
          //       previousProduct!..recieveToken(auth, previousProduct.items),
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
                  routes: {
                    '/': (context) => const AuthScreen(),
                    CategoriesScreen.routeName: (context) =>
                        const CategoriesScreen(),
                    EmployeesScreen.routeName: (context) =>
                        const EmployeesScreen(),
                    ChoicesScreen.routeName: (context) => const ChoicesScreen(),
                    DetailedAuthScreen.routeName: (context) =>
                        const DetailedAuthScreen(),
                    WorkerDetailsScreen.routeName: (context) =>
                        const WorkerDetailsScreen(),
                    MyAccountScreen.routeName: (context) =>
                        const MyAccountScreen(),
                    GalleryScreen.routeName: (context) => const GalleryScreen(),
                    DetailedImageScreen.routeName: (context) =>
                        const DetailedImageScreen(),
                    SettingsScreen.routeName: (context) =>
                        const SettingsScreen(),
                  },
                ))));
  }
}

          
          
          
          
        //   MaterialApp(
        //         title: 'My Shop',
        //         theme: ThemeData(
        //           pageTransitionsTheme: PageTransitionsTheme(builders: {
        //             TargetPlatform.android: CustomPageTransitionBuilder(),
        //             TargetPlatform.iOS: CustomPageTransitionBuilder(),
        //           }),
        //           fontFamily: 'lato',
        //           colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
        //               .copyWith(secondary: Colors.white54),
        //         ),
        //         home: value.isAuth
        //             ? const ProductsOverviewScreen()
        //             : FutureBuilder(
        //                 future: value.tryAutoLogIn(),
        //                 builder: (context, snapshot) =>
        //                     snapshot.connectionState == ConnectionState.waiting
        //                         ? const SplashScreen()
        //                         : const AuthScreen(),
        //               ),
        //         debugShowCheckedModeBanner: false,
        //         routes: {
        //           ProductsOverviewScreen.routeName: (context) =>
        //               const ProductsOverviewScreen(),
        //           ProductDetailScreen.routeName: (context) =>
        //               const ProductDetailScreen(),
        //           CartScreen.routeName: (context) => const CartScreen(),
        //           OrdersScreen.routeName: (context) => const OrdersScreen(),
        //           UserProductsScreen.routeName: (context) =>
        //               const UserProductsScreen(),
        //           EditAddProductScreen.routeName: (context) =>
        //               const EditAddProductScreen(),
        //           AuthScreen.routeName: (context) => const AuthScreen(),
        //         },
        //       )),
        // ));
    
    
    
    
    
   