import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/screens/employees_screen.dart';
import 'package:project/widgets/employees_body_widget.dart';
import 'package:provider/provider.dart';

import '../dummy_data.dart';
import '../models/employee.dart';
import '../providers/auth.dart';
import '../providers/user.dart';
import '../widgets/categories_body_widget.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categories-screen';
  const CategoriesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late String searchCity;
  final _textController = TextEditingController();
  var _isLoading = false;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text(
    'شغلي',
    style: TextStyle(
        color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
  );
  late Employee currentUser;
  var _isInit = true;
  var code = '';
  final formKey = GlobalKey<FormState>();
  var _searchBool = false;
  List<Employee> employees = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final userId = Provider.of<User>(context, listen: false).userId;
      currentUser = await Provider.of<User>(context).getUser(userId);
      searchCity = currentUser.location;
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  Future<void> _search(String text, String city) async {
    print('here i am');
    print(text);
    print(city);
    setState(() {
      _isLoading = true;
    });
    setState(() {
      _searchBool = true;
    });
    employees =
        await Provider.of<User>(context, listen: false).search(text, city);
    print(employees.length);
    setState(() {
      _isLoading = false;
    });
    setState(() {
      _isInit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 247, 241),
      appBar: AppBar(
        actions: [
          if (customIcon.icon == Icons.cancel)
            DropdownButtonHideUnderline(
              child: DropdownButton(
                  elevation: 0,
                  icon: const Icon(
                    Icons.add_location_alt,
                    color: Colors.white,
                    size: 25,
                  ),
                  items: CITIES
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (dynamic city) => searchCity = city as String),
            ),
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = ListTile(
                    leading: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: TextField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      controller: _textController,
                      onSubmitted: (_) =>
                          _search(_textController.text, searchCity),
                      decoration: const InputDecoration(
                        hintText: 'ابحث عن احد العمال...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  setState(() {
                    _isInit = true;
                    _searchBool = false;
                  });
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text(
                    'شغلي',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  );
                }
              });
            },
            icon: customIcon,
          )
        ],
        elevation: 0,
        backgroundColor: Colors.red,
        title: Center(
          child: customSearchBar,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitSpinningLines(color: Colors.red),
            )
          : _searchBool
              ? ListView.builder(
                  itemBuilder: (context, index) => EmployeesBodyWidget(
                      currentWorker: employees[index],
                      currentUser: currentUser),
                  itemCount: employees.length,
                )
              : Padding(
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
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2.7 / 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    padding: const EdgeInsets.all(25),
                  ),
                ),
      // Center(
      //     child: Directionality(
      //         textDirection: TextDirection.rtl,
      //         child: AlertDialog(
      //           title: const Text(
      //               'برجاء ادخال الكود الذي تم بعثه الى حسابك الشخصي للتجقق من الحساب'),
      //           content: TextFormField(
      //             key: const ValueKey('code'),
      //             onChanged: (e) {
      //               code = e;
      //               print(e);
      //             },
      //             keyboardType: TextInputType.number,
      //             decoration: InputDecoration(
      //               border: OutlineInputBorder(
      //                 borderRadius: BorderRadius.circular(10.0),
      //               ),
      //             ),
      //           ),
      //           actions: [
      //             TextButton(
      //                 onPressed: () {
      //                   if (code == '') {
      //                     showDialog(
      //                         context: context,
      //                         builder: (context) => Directionality(
      //                               textDirection: TextDirection.rtl,
      //                               child: AlertDialog(
      //                                 title: const Text(
      //                                     'يجب عليك ادخال الكود'),
      //                                 actions: [
      //                                   TextButton(
      //                                       onPressed: () =>
      //                                           Navigator.of(context)
      //                                               .pop(),
      //                                       child: const Text(
      //                                         'حسنا',
      //                                         style: TextStyle(
      //                                             color: Colors.black,
      //                                             fontSize: 18),
      //                                       ))
      //                                 ],
      //                               ),
      //                             ));
      //                   }
      //                   if (formKey.currentState!.validate()) {
      //                     verifyEmail(code);
      //                   }
      //                 },
      //                 child: const Text(
      //                   'تم',
      //                   style: TextStyle(
      //                       color: Colors.black, fontSize: 18),
      //                 ))
      //           ],
      //         )))
    );
  }
}
