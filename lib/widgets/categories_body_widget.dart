import 'package:flutter/material.dart';
import '../screens/employees_screen.dart';
import '../models/employee.dart';

class CategoriesBodyWidget extends StatelessWidget {
  final IconData backgroundImg;
  final String title;
  final Employee currentUser;
  const CategoriesBodyWidget(
      {Key? key,
      required this.backgroundImg,
      required this.title,
      required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeOf = Theme.of(context);
    return InkWell(
        onTap: () => Navigator.of(context).pushNamed(EmployeesScreen.routeName,
            arguments: {'title': title, 'currentUser': currentUser}),
        splashColor: themeOf.colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 52,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color.fromARGB(255, 254, 247, 241),
                child: Icon(backgroundImg, color: Colors.red, size: 50),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 18, color: Colors.red),
            )
          ],
        ));
  }
}
