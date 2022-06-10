import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../models/employee.dart';
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
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text(
    'شغلي',
    style: TextStyle(
        color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 247, 241),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = const ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                        hintText: 'ابحث عن احد العمال بإسمه ...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
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
      body: Padding(
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
