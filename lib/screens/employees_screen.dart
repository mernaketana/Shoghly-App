import 'package:flutter/material.dart';
import '../widgets/employees_body_widget.dart';
import '../models/employee.dart';

class EmployeesScreen extends StatelessWidget {
  static const routeName = '/employees-screen';
  const EmployeesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final employees = arguments['employees'] as List<Employee>;
    final title = arguments['title'];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 254, 247, 241),
        // drawer: MyDrawer(currentUser: currentUser),
        appBar: AppBar(
          title: Text('$title'),
          // actions: <Widget>[
          //   IconButton(onPressed: () {}, icon: const Icon(Icons.messenger)),
          //   IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          // ],
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            // if (currentUser.id == employees[index].id) {
            //   return const SizedBox();
            // }
            return EmployeesBodyWidget(
                // currentUser: currentUser,
                // rate: employees[index],
                img: employees[index].image == null
                    ? 'assets/images/placeholder.png'
                    : employees[index].image as String,
                name: '${employees[index].fname} ${employees[index].lname}',
                profession: employees[index].categordId as String,
                id: employees[index].id);
          },
          itemCount: employees.length,
        ),
      ),
    );
  }
}
