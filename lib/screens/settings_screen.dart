import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';

import '../dummy_data.dart';
import '../models/employee.dart';
import '../providers/auth.dart';
import '../providers/user.dart';
import '../widgets/user_image_picker.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings-screen';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickedDate = TextEditingController();
  String? _dropdownVal;
  String? _dropdownValCat;
  String? _userImage;
  final _categories = DUMMY_CATEGORIES.map((e) => e.title).toList();
  final _passController = TextEditingController();
  var _canEditPass = false;
  late String oldPass;
  late String newPass;
  var isLoading = false;
  final _items = [
    'بورسعيد',
    'القاهرة',
    'الاسكندرية',
    'الاسماعيلية',
    'المنصورة',
    'المنوفية'
  ];
  Map<String, String> _authData = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'password': '',
    'gender': '',
    'role': '',
    'profession': '',
    'phone': '',
    'country': '',
    'city': '',
    'line': ''
  };
  // var newUsers = Employee(
  //     image: '',
  //     categordId: '',
  //     id: '',
  //     fname: '',
  //     lname: '',
  //     email: '',
  //     password: '',
  //     phone: 0,
  //     location: '',
  //     address: '',
  //     bDate: null,
  //     role: '');

  Future<void> _submitPass() async {
    final _valid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!_valid) {
      print('invalid');
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    print(oldPass);
    print(newPass);
    await Provider.of<Auth>(context, listen: false)
        .changePassword(oldPass, newPass);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> _submitUser() async {
    final _valid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!_valid) {
      print('invalid');
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    await Provider.of<User>(context, listen: false).editUser(
        _authData["firstName"] as String,
        _authData["lastName"] as String,
        _authData["gender"] as String,
        _authData["phone"] as String,
        _authData["city"] as String,
        _authData["line"] as String);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future _datePicker() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date == null) {
        return;
      }
      setState(() {
        _pickedDate.text = DateFormat.yMd().format(date);
      });
    });
  }

  void _pickedImage(File image) {
    _userImage = image.path; //بفوروارد بالعكس
    setState(() {
      // newUsers = Employee(
      //     bDate: newUsers.bDate,
      //     categordId: newUsers.categordId,
      //     id: newUsers.id,
      //     fname: newUsers.fname,
      //     lname: newUsers.lname,
      //     email: newUsers.email,
      //     password: newUsers.password,
      //     phone: newUsers.phone,
      //     location: newUsers.location,
      //     role: newUsers.role,
      //     address: newUsers.address,
      //     image: _userImage);
      // print('imaaaaaaaaaaaaaaaaaaaaaaaaaaaaage');
      // print(newUsers.image);
    });
  }

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Employee currentUser = arguments['currentUser'];
    print('hereeeeeeeeee');
    bool editPass = arguments['editPass'];
    // print(currentUser.id);
    // print(currentUser.fname);
    // print(DUMMY_EMP.indexWhere((e) => e.id == currentUser.id));
    // print(currentUser.password);
    // _pickedDate.text =
    //     '${currentUser.bDate!.day}/${currentUser.bDate!.month}/${currentUser.bDate!.year}';
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 254, 247, 241),
        appBar: AppBar(
          title: const Text('تعديل'),
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // if (editPass && !_canEditPass)
                        //   const Text(
                        //     'ادخل الرقم السري لتتمكن من تغييره',
                        //     style: TextStyle(
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // if (editPass && !_canEditPass)
                        //   const SizedBox(
                        //     height: 14,
                        //   ),
                        // if (editPass && !_canEditPass)
                        //   TextFormField(
                        //     key: const ValueKey('canEditPass'),
                        //     obscureText: true,
                        //     validator: (e) {
                        //       if (e!.isEmpty) {
                        //         return 'يرجي ادخال الرقم السري  ';
                        //       } else {
                        //         return null;
                        //       }
                        //     },
                        //     onSaved: (e) {
                        //       // print(
                        //       //     'nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');
                        //       // print(e);
                        //       verifyPass = e!;
                        //     },
                        //     keyboardType: TextInputType.number,
                        //     decoration: InputDecoration(
                        //       prefixIcon: const Icon(
                        //         Icons.password,
                        //         color: Colors.grey,
                        //       ),
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10.0),
                        //       ),
                        //       labelText: 'الرقم السري',
                        //       // labelStyle: TextStyle(color: Colors.white)
                        //     ),
                        //   ),
                        if (editPass)
                          TextFormField(
                            key: const ValueKey('oldPass'),
                            initialValue: currentUser.email,
                            obscureText: true,
                            validator: (e) {
                              if (e!.isEmpty || e.length < 6) {
                                return 'يجب الا يفل الرقم السري عن 6 رموز';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (e) => oldPass = e as String,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'ادخل الرقم السري القديم',
                              // labelStyle: TextStyle(color: Colors.white)
                            ),

                            // style: const TextStyle(color: Colors.white),
                          ),
                        if (editPass)
                          const SizedBox(
                            height: 35,
                          ),
                        if (editPass)
                          TextFormField(
                            key: const ValueKey('newPass'),
                            validator: (e) {
                              if (e!.isEmpty || e.length < 6) {
                                return 'يجب الا يفل الرقم السري عن 6 رموز';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (e) => newPass = e as String,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.password,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'ادخل الرقم السري الجديد',
                            ),
                            controller: _passController,
                            obscureText: true,
                          ),
                        if (editPass)
                          const SizedBox(
                            height: 35,
                          ),
                        if (editPass)
                          TextFormField(
                            validator: (e) {
                              if (e != _passController.text) {
                                return 'الرقم السري غير متطابق';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.password,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'اعد ادخال الرقم السري الجديد',
                            ),
                            obscureText: true,
                          ),
                        // if (!editPass) UserImagePicker(imagePick: _pickedImage),
                        if (!editPass)
                          TextFormField(
                            key: const ValueKey('fname'),
                            initialValue: currentUser.fname,
                            validator: (e) {
                              if (e!.isEmpty) {
                                return 'يجب ادخال الاسم الاول';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (e) =>
                                _authData['firstName'] = e as String,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'الاسم الاول',
                            ),
                          ),
                        if (!editPass)
                          const SizedBox(
                            height: 20,
                          ),
                        if (!editPass)
                          TextFormField(
                            key: const ValueKey('lname'),
                            initialValue: currentUser.lname,
                            validator: (e) {
                              if (e!.isEmpty) {
                                return 'يجب ادخال الاسم الاخير';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (e) => _authData['lastName'] = e as String,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'الاسم الاخير',
                            ),
                          ),
                        if (!editPass)
                          const SizedBox(
                            height: 14,
                          ),
                        if (!editPass)
                          TextFormField(
                            initialValue: currentUser.phone.toString(),
                            key: const ValueKey('phonenum'),
                            validator: (e) {
                              if (e!.isEmpty) {
                                return 'يجب ادخال رقم الهاتف';
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.number,
                            onSaved: (e) => _authData['phone'] = e as String,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.phone_outlined,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'رقم الهاتف',
                            ),
                          ),
                        if (!editPass)
                          const SizedBox(
                            height: 14,
                          ),
                        // BIRTHDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAY
                        // TextFormField(
                        //   key: const ValueKey('bdate'),
                        //   validator: (e) {
                        //     if (e!.isEmpty) {
                        //       return 'يجب ادخال تاريخ الميلاد';
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        //   onSaved: (e) =>
                        //   newUsers = Employee(
                        //       image: newUsers.image,
                        //       categordId: newUsers.categordId,
                        //       id: newUsers.id,
                        //       fname: newUsers.fname,
                        //       lname: newUsers.lname,
                        //       email: newUsers.email,
                        //       password: newUsers.password,
                        //       phone: newUsers.phone,
                        //       location: newUsers.location,
                        //       address: newUsers.address,
                        //       role: newUsers.role,
                        //       bDate: DateFormat.yMd().parse(e as String)),
                        //   onTap: () {
                        //     FocusScope.of(context).requestFocus(FocusNode());
                        //     _datePicker();
                        //   },
                        //   controller: _pickedDate,
                        //   decoration: InputDecoration(
                        //     prefixIcon: const Icon(
                        //       Icons.date_range_outlined,
                        //       color: Colors.grey,
                        //     ),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //     ),
                        //     labelText: 'تاريخ الميلاد',
                        //     // labelStyle: TextStyle(color: Colors.white)
                        //   ),
                        //   // style: const TextStyle(color: Colors.white),
                        // ),
                        if (!editPass)
                          DropdownButtonFormField(
                              // value: currentUser.gender,
                              validator: (e) {
                                if (e == null) {
                                  return 'يجب اختيار الجنس  ';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person_outlined,
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: 'الجنس'),
                              isExpanded: true,
                              iconEnabledColor: Colors.white,
                              items: const [
                                DropdownMenuItem(
                                  child: Text('انثى'),
                                  value: 'انثى',
                                ),
                                DropdownMenuItem(
                                  child: Text('رجل'),
                                  value: 'رجل',
                                )
                              ],
                              onSaved: (String? e) =>
                                  _authData['gender'] = e as String,
                              onChanged: (newVal) {
                                _dropdownValCat = newVal as String?;
                              }),
                        if (!editPass)
                          const SizedBox(
                            height: 14,
                          ),
                        if (!editPass)
                          DropdownButtonFormField(
                              // value: currentUser.gender,
                              validator: (e) {
                                if (e == null) {
                                  return 'يجب اختيار المحافظة  ';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.location_city_outlined,
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: 'المحافظة'),
                              isExpanded: true,
                              iconEnabledColor: Colors.white,
                              items: _items
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                                  .toList(),
                              onSaved: (String? e) =>
                                  _authData['city'] = e as String,
                              onChanged: (newVal) {
                                _dropdownVal = newVal as String?;
                              }),
                        if (!editPass)
                          const SizedBox(
                            height: 14,
                          ),
                        if (!editPass)
                          TextFormField(
                            initialValue: currentUser.address,
                            key: const ValueKey('address'),
                            validator: (e) {
                              if (e!.isEmpty) {
                                return 'يجب ادخال العنوان ';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (e) => _authData['line'] = e as String,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.home,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'العنوان',
                              // labelStyle: TextStyle(color: Colors.white)
                            ),
                            // style: const TextStyle(color: Colors.white),
                          ),
                        if (!editPass)
                          if (currentUser.role == 'worker')
                            const SizedBox(
                              height: 14,
                            ),
                        if (!editPass)
                          if (currentUser.role == 'worker')
                            DropdownButtonFormField(
                                value: currentUser.role,
                                validator: (e) {
                                  if (e == null) {
                                    return 'يجب اختيار الحرفة  ';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.work_outline,
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    labelText: 'الحرفة '),
                                isExpanded: true,
                                iconEnabledColor: Colors.white,
                                items: _categories
                                    .map((e) => DropdownMenuItem(
                                          child: Text(e),
                                          value: e,
                                        ))
                                    .toList(),
                                onSaved: (String? e) =>
                                    _authData['profession'] = e as String,
                                onChanged: (newVal) {
                                  _dropdownValCat = newVal as String?;
                                }),
                        ////////////////////////////////////////////////////////////////////
                        if (!editPass)
                          const SizedBox(
                            height: 20,
                          ),
                        // if (!editPass)
                        //   TextFormField(
                        //     initialValue: currentUser.lname,
                        //     key: const ValueKey('lname'),
                        //     validator: (e) {
                        //       if (e!.isEmpty) {
                        //         return 'يجب ادخال الاسم الاخير';
                        //       } else {
                        //         return null;
                        //       }
                        //     },
                        //     onSaved: (e) => newUsers = Employee(
                        //         bDate: newUsers.bDate,
                        //         image: newUsers.image,
                        //         categordId: newUsers.categordId,
                        //         id: newUsers.id,
                        //         fname: newUsers.fname,
                        //         lname: e ?? newUsers.lname,
                        //         email: newUsers.email,
                        //         password: newUsers.password,
                        //         phone: newUsers.phone,
                        //         location: newUsers.location,
                        //         address: newUsers.address,
                        //         role: newUsers.role),
                        //     decoration: InputDecoration(
                        //       prefixIcon: const Icon(
                        //         Icons.person,
                        //         color: Colors.grey,
                        //       ),
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10.0),
                        //       ),
                        //       labelText: 'الاسم الاخير',
                        //     ),
                        //   ),
                        // if (!editPass)
                        //   const SizedBox(
                        //     height: 20,
                        //   ),
                        // if (!editPass)
                        //   TextFormField(
                        //     initialValue: currentUser.phone.toString(),
                        //     key: const ValueKey('phonenum'),
                        //     validator: (e) {
                        //       if (e!.isEmpty) {
                        //         return 'يجب ادخال رقم الهاتف';
                        //       } else {
                        //         return null;
                        //       }
                        //     },
                        //     keyboardType: TextInputType.number,
                        //     onSaved: (e) => newUsers = Employee(
                        //         bDate: newUsers.bDate,
                        //         image: newUsers.image,
                        //         categordId: newUsers.categordId,
                        //         id: newUsers.id,
                        //         fname: newUsers.fname,
                        //         lname: newUsers.lname,
                        //         phone:
                        //             e == null ? newUsers.phone : int.parse(e),
                        //         email: newUsers.email,
                        //         password: newUsers.password,
                        //         location: newUsers.location,
                        //         address: newUsers.address,
                        //         role: newUsers.role),
                        //     decoration: InputDecoration(
                        //       prefixIcon: const Icon(
                        //         Icons.phone_enabled_outlined,
                        //         color: Colors.grey,
                        //       ),
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10.0),
                        //       ),
                        //       labelText: 'رقم الهاتف',
                        //     ),
                        //   ),
                        // if (!editPass)
                        //   const SizedBox(
                        //     height: 20,
                        //   ),
                        // if (!editPass)
                        //   // TextFormField(
                        //   //   // initialValue: currentUser.bDate.toString(),
                        //   //   key: const ValueKey('bdate'),
                        //   //   validator: (e) {
                        //   //     if (e!.isEmpty && currentUser.bDate == null) {
                        //   //       return 'يجب ادخال تاريخ الميلاد';
                        //   //     } else {
                        //   //       return null;
                        //   //     }
                        //   //   },
                        //   //   onSaved: (e) {
                        //   //     // print('HEREEEEEEEEEEEEEEEEEEEEEEEEEEEe');
                        //   //     // print(e);
                        //   //     // print(_pickedDate.text);
                        //   //     // print(newUsers.bDate);
                        //   //     newUsers = Employee(
                        //   //         image: newUsers.image,
                        //   //         categordId: newUsers.categordId,
                        //   //         id: newUsers.id,
                        //   //         fname: newUsers.fname,
                        //   //         lname: newUsers.lname,
                        //   //         email: newUsers.email,
                        //   //         password: newUsers.password,
                        //   //         phone: newUsers.phone,
                        //   //         location: newUsers.location,
                        //   //         address: newUsers.address,
                        //   //         role: newUsers.role,
                        //   //         bDate: e == ''
                        //   //             ? newUsers.bDate
                        //   //             : DateFormat.yMd().parse(e!));
                        //   //     // print(
                        //   //     //     'BDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDdd');
                        //   //     // print(newUsers.bDate);
                        //   //   },
                        //   //   onTap: () {
                        //   //     FocusScope.of(context).requestFocus(FocusNode());
                        //   //     _datePicker();
                        //   //   },
                        //   //   controller: _pickedDate,
                        //   //   decoration: InputDecoration(
                        //   //     prefixIcon: const Icon(
                        //   //       Icons.date_range_outlined,
                        //   //       color: Colors.grey,
                        //   //     ),
                        //   //     border: OutlineInputBorder(
                        //   //       borderRadius: BorderRadius.circular(10.0),
                        //   //     ),
                        //   //     labelText: 'تاريخ الميلاد',
                        //   //   ),
                        //   // ),

                        // if (!editPass)
                        //   const SizedBox(
                        //     height: 20,
                        //   ),
                        // if (!editPass)
                        //   DropdownButtonFormField(
                        //       validator: (e) {
                        //         // ignore: unnecessary_null_comparison
                        //         if (e == null && currentUser.location == null) {
                        //           return 'يجب اختيار المحافظة  ';
                        //         } else {
                        //           return null;
                        //         }
                        //       },
                        //       decoration: InputDecoration(
                        //           prefixIcon: const Icon(
                        //             Icons.location_city_outlined,
                        //             color: Colors.grey,
                        //           ),
                        //           border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(10.0),
                        //           ),
                        //           labelText: 'المحافظة'
                        //           // style: const TextStyle(color: Colors.white)

                        //           // labelStyle: TextStyle(color: Colors.white)
                        //           ),
                        //       isExpanded: true,
                        //       iconEnabledColor: Colors.white,
                        //       hint: _dropdownVal == null
                        //           ? Text(
                        //               currentUser.location,
                        //             )
                        //           : Text(
                        //               _dropdownVal as String,
                        //             ),
                        //       items: _items
                        //           .map((e) => DropdownMenuItem(
                        //                 child: Text(e),
                        //                 value: e,
                        //               ))
                        //           .toList(),
                        //       onSaved: (String? e) => newUsers = Employee(
                        //           bDate: newUsers.bDate,
                        //           image: newUsers.image,
                        //           categordId: newUsers.categordId,
                        //           id: newUsers.id,
                        //           fname: newUsers.fname,
                        //           lname: newUsers.lname,
                        //           email: newUsers.email,
                        //           password: newUsers.password,
                        //           phone: newUsers.phone,
                        //           location: e ?? currentUser.location,
                        //           address: newUsers.address,
                        //           role: newUsers.role),
                        //       onChanged: (newVal) {
                        //         // print(
                        //         //     'neeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeew');
                        //         // print(newVal);
                        //         setState(() {
                        //           // print('nowwwwwwwwwwwwwwwwwwwwwwwwwwwww');
                        //           // _dropdownVal = newVal as String?;
                        //           // print(_dropdownVal);
                        //           newUsers = Employee(
                        //               bDate: newUsers.bDate,
                        //               image: newUsers.image,
                        //               categordId: newUsers.categordId,
                        //               id: newUsers.id,
                        //               fname: newUsers.fname,
                        //               lname: newUsers.lname,
                        //               email: newUsers.email,
                        //               password: newUsers.password,
                        //               phone: newUsers.phone,
                        //               location: _dropdownVal as String,
                        //               address: newUsers.address,
                        //               role: newUsers.role);
                        //           // print(newUsers.location);
                        //         });
                        //       }),
                        // if (!editPass)
                        //   const SizedBox(
                        //     height: 20,
                        //   ),
                        // if (!editPass)
                        //   TextFormField(
                        //     key: const ValueKey('address'),
                        //     initialValue: currentUser.address,
                        //     validator: (e) {
                        //       if (e!.isEmpty) {
                        //         return 'يجب ادخال العنوان ';
                        //       } else {
                        //         return null;
                        //       }
                        //     },
                        //     onSaved: (e) => newUsers = Employee(
                        //         bDate: newUsers.bDate,
                        //         image: newUsers.image,
                        //         categordId: newUsers.categordId,
                        //         id: newUsers.id,
                        //         fname: newUsers.fname,
                        //         lname: newUsers.lname,
                        //         phone: newUsers.phone,
                        //         email: newUsers.email,
                        //         password: newUsers.password,
                        //         location: newUsers.location,
                        //         address:
                        //             e == '' ? currentUser.address : e as String,
                        //         role: newUsers.role),
                        //     decoration: InputDecoration(
                        //       prefixIcon: const Icon(
                        //         Icons.home,
                        //         color: Colors.grey,
                        //       ),
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10.0),
                        //       ),
                        //       labelText: 'العنوان',
                        //       // labelStyle: TextStyle(color: Colors.white)
                        //     ),
                        //     // style: const TextStyle(color: Colors.white),
                        //   ),
                        // if (!editPass)
                        //   if (currentUser.role == 'worker')
                        //     const SizedBox(
                        //       height: 20,
                        //     ),
                        // if (!editPass)
                        //   if (currentUser.role == 'worker')
                        //     DropdownButtonFormField(
                        //         validator: (e) {
                        //           if (e == null) {
                        //             return 'يجب اختيار الحرفة  ';
                        //           } else {
                        //             return null;
                        //           }
                        //         },
                        //         decoration: InputDecoration(
                        //             prefixIcon: const Icon(
                        //               Icons.work_outline,
                        //               color: Colors.grey,
                        //             ),
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             labelText: 'الحرفة'
                        //             // style: const TextStyle(color: Colors.white)

                        //             // labelStyle: TextStyle(color: Colors.white)
                        //             ),
                        //         isExpanded: true,
                        //         iconEnabledColor: Colors.white,
                        //         hint: _dropdownValCat == null
                        //             ? Text(
                        //                 currentUser.categordId as String,
                        //               )
                        //             : Text(
                        //                 _dropdownValCat as String,
                        //               ),
                        //         items: _categories
                        //             .map((e) => DropdownMenuItem(
                        //                   child: Text(e),
                        //                   value: e,
                        //                 ))
                        //             .toList(),
                        //         onSaved: (String? e) => newUsers = Employee(
                        //             bDate: newUsers.bDate,
                        //             image: newUsers.image,
                        //             categordId: e ?? currentUser.categordId,
                        //             id: newUsers.id,
                        //             fname: newUsers.fname,
                        //             lname: newUsers.lname,
                        //             email: newUsers.email,
                        //             password: newUsers.password,
                        //             phone: newUsers.phone,
                        //             location: newUsers.location,
                        //             address: newUsers.address,
                        //             role: newUsers.role),
                        //         onChanged: (newVal) {
                        //           setState(() {
                        //             _dropdownValCat = newVal as String?;
                        //             newUsers = Employee(
                        //                 bDate: newUsers.bDate,
                        //                 image: newUsers.image,
                        //                 categordId: _dropdownValCat,
                        //                 id: newUsers.id,
                        //                 fname: newUsers.fname,
                        //                 lname: newUsers.lname,
                        //                 email: newUsers.email,
                        //                 password: newUsers.password,
                        //                 phone: newUsers.phone,
                        //                 location: newUsers.location,
                        //                 address: newUsers.address,
                        //                 role: newUsers.role);
                        //           });
                        //         }),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () =>
                                      editPass ? _submitPass() : _submitUser(),
                                  child: const Text(
                                    'تم',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.red),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white)),
                                ),
                        ),
                        // ElevatedButton(
                        //   onPressed: _submit,
                        //   child: const Text(
                        //     'تم',
                        //     style: TextStyle(fontWeight: FontWeight.bold),
                        //   ),
                        //   style: ButtonStyle(
                        //       backgroundColor:
                        //           MaterialStateProperty.all(Colors.white),
                        //       foregroundColor:
                        //           MaterialStateProperty.all(Colors.black)),
                        // ),
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }
}

class MainSettingsScreen extends StatelessWidget {
  const MainSettingsScreen({Key? key, required this.currentUser})
      : super(key: key);
  final Employee currentUser;

  @override
  Widget build(BuildContext context) {
    // print(currentUser.gender);
    return Column(
      children: [
        Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10)),
          child: ListTile(
              tileColor: const Color.fromARGB(255, 254, 247, 241),
              title: const Text('تعديل حسابي'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.of(context).pushNamed(
                  SettingsScreen.routeName,
                  arguments: {'currentUser': currentUser, 'editPass': true})),
        ),
        Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10)),
          child: ListTile(
              tileColor: const Color.fromARGB(255, 254, 247, 241),
              title: const Text('تعديل معلوماتي'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.of(context).pushNamed(
                  SettingsScreen.routeName,
                  arguments: {'currentUser': currentUser, 'editPass': false})),
        ),
        Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10)),
          child: ListTile(
              tileColor: const Color.fromARGB(255, 254, 247, 241),
              title: const Text('تسجيل الخروج'),
              trailing: const Icon(Icons.logout),
              onTap: () {
                // Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logOut();
              }),
        ),
      ],
    );
  }
}
