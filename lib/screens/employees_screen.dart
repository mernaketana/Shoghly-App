import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/dummy_data.dart';
import 'package:project/providers/worker.dart';
import 'package:provider/provider.dart';
import '../widgets/employees_body_widget.dart';
import '../models/employee.dart';

class EmployeesScreen extends StatefulWidget {
  static const routeName = '/employees-screen';
  final Map<String, dynamic> arguments;
  const EmployeesScreen({Key? key, required this.arguments}) : super(key: key);

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  var _isLoading = false;
  List<Employee> employees = [];
  String _city = '';

  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     for (var i = 0; i < CITIES.length; i++) {
  //       await Provider.of<Worker>(context, listen: false)
  //           .getWorkers(CITIES[i], widget.arguments['title']);
  //     }
  //     employees = Provider.of<Worker>(context, listen: false).employees;
  //     print(employees);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  //   _isInit = false;
  // }

  void getWorkers(String city) async {
    print('HEREEEEEEEEEEEEE');
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Worker>(context, listen: false)
        .getWorkers(city, widget.arguments['title']);
    employees = Provider.of<Worker>(context, listen: false).employees;
    print(employees);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Do I come here?');
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 254, 247, 241),
        appBar: AppBar(
          title: Text('${widget.arguments['title']}'),
        ),
        body: _isLoading
            ? const Center(
                child: SpinKitSpinningLines(color: Colors.red),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  // if (currentUser.id == employees[index].id) {
                  //   return const SizedBox();
                  // }
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.all(15),
                        child: DropdownButtonFormField(
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
                              _city = e as String;
                              getWorkers(_city);
                            },
                            onChanged: (newVal) {
                              _city = newVal as String;
                              getWorkers(_city);
                            }),
                      ),
                      if (employees.isNotEmpty)
                        EmployeesBodyWidget(
                            currentUser: widget.arguments['currentUser'],
                            currentWorker: employees
                                .where((element) =>
                                    element.categordId ==
                                    widget.arguments['title'])
                                .toList()[index]),
                    ],
                  );
                },
                itemCount: employees.isNotEmpty
                    ? employees
                        .where((element) =>
                            element.categordId == widget.arguments['title'])
                        .toList()
                        .length
                    : 1,
              ),
      ),
    );
  }
}
