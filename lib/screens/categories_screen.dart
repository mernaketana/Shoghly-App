import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/widgets/employees_body_widget.dart';
import 'package:provider/provider.dart';
import '../dummy_data.dart';
import '../models/employee.dart';
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
  var searchOpen = false;
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
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
      _searchBool = true;
      searchOpen = false;
    });
    employees =
        await Provider.of<User>(context, listen: false).search(text, city);
    setState(() {
      _isLoading = false;
      _isInit = true;
    });
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchOpen = true;
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = ListTile(
                    leading: IconButton(
                        onPressed: () =>
                            _search(_textController.text, searchCity),
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        )),
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
                    searchOpen = false;
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: customSearchBar,
        ),
      ),
      body: _isLoading
          ? Center(
              child: SpinKitSpinningLines(
                  color: Theme.of(context).colorScheme.primary),
            )
          : searchOpen
              ? Container(
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(15),
                  child: DropdownButtonFormField(
                      value: currentUser.location,
                      validator: (e) {
                        if (e == null) {
                          return 'يجب اختيار المحافظة  ';
                        } else {
                          return null;
                        }
                      },
                      alignment: Alignment.centerRight,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.location_city_outlined,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'اختر المحافظة'),
                      isExpanded: true,
                      iconEnabledColor: Colors.white,
                      items: CITIES
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onSaved: (String? e) {
                        searchCity = e as String;
                        _search(_textController.text, searchCity);
                      },
                      onChanged: (newVal) {
                        searchCity = newVal as String;
                        _search(_textController.text, searchCity);
                      }),
                )
              : _searchBool
                  ? employees.isEmpty
                      ? Center(
                          child: Text(
                          'لا يوجد عامل بهذا الاسم في $searchCity',
                          style: const TextStyle(fontSize: 20),
                        ))
                      : ListView.builder(
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
