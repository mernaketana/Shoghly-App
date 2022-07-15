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
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 52,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(backgroundImg,
                    color: Theme.of(context).colorScheme.primary, size: 50),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).colorScheme.primary),
            )
          ],
        ));
  }
}
