import 'package:flutter/material.dart';
import 'package:project/screens/employees_screen.dart';
import 'package:provider/provider.dart';

import '../dummy_data.dart';
import '../models/employee.dart';
import '../providers/user.dart';
import '../widgets/categories_body_widget.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categories-screen';
  const CategoriesScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final Employee currentUser;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late String searchCity;
  final _textController = TextEditingController();
  var _isLoading = false;
  final _items = [
    'بورسعيد',
    'القاهرة',
    'الاسكندرية',
    'الاسماعيلية',
    'المنصورة',
    'المنوفية'
  ];
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text(
    'شغلي',
    style: TextStyle(
        color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
  );

  Future<void> _search(String text, String city) async {
    print('here i am');
    print(text);
    print(city);
    setState(() {
      _isLoading = true;
    });
    final List<Employee> employees =
        await Provider.of<User>(context, listen: false).search(text, city);
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushNamed(EmployeesScreen.routeName,
        arguments: {'employees': employees, 'title': 'نتائج البحث'});
    print(employees[3].image);
  }

  @override
  Widget build(BuildContext context) {
    searchCity = widget.currentUser.location;
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
                  items: _items
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
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(6),
              child: GridView(
                children: <Widget>[
                  ...DUMMY_CATEGORIES
                      .map((e) => CategoriesBodyWidget(
                          backgroundImg: e.img,
                          title: e.title,
                          currentUser: widget.currentUser))
                      .toList(),
                ],
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2.7 / 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                padding: const EdgeInsets.all(25),
              ),
            ),
    );
  }
}
