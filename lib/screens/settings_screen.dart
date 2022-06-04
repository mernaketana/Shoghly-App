import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';

import '../dummy_data.dart';
import '../models/employee.dart';
import '../providers/auth.dart';
import '../widgets/user_image_picker.dart';
import 'categories_screen.dart';

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
  String verifyPass = '';
  final _items = [
    'بورسعيد',
    'القاهرة',
    'الاسكندرية',
    'الاسماعيلية',
    'المنصورة',
    'المنوفية'
  ];
  var newUsers = Employee(
      image: '',
      categordId: '',
      id: '',
      fname: '',
      lname: '',
      email: '',
      password: '',
      phone: 0,
      location: '',
      address: '',
      bDate: null,
      role: '');

  Future<void> _submit() async {
    // print(index);
    final _valid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!_valid) {
      // print('invalid');
      return;
    }
    _formKey.currentState!.save();
    await Provider.of<Auth>(context).changePassword(newUsers.password);
    // print('valid');

    // // var userIndex = DUMMY_EMP.indexWhere((e) => e.id == newUsers.id);
    // print(newUsers.role);
    // print(newUsers.id);
    // print(newUsers.image);
    // print(newUsers.location);
    // print(newUsers.id);
    // print(newUsers.bDate);
    // print('loooooooooooooooooooooooooooooooooooo');
    // print(newUsers.password);
    // print(newUsers.email);
    // print(DUMMY_EMP.indexWhere((e) => e.id == newUsers.id));

    Navigator.of(context).pushReplacementNamed(CategoriesScreen.routeName);
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
      newUsers = Employee(
          bDate: newUsers.bDate,
          categordId: newUsers.categordId,
          id: newUsers.id,
          fname: newUsers.fname,
          lname: newUsers.lname,
          email: newUsers.email,
          password: newUsers.password,
          phone: newUsers.phone,
          location: newUsers.location,
          role: newUsers.role,
          address: newUsers.address,
          image: _userImage);
      // print('imaaaaaaaaaaaaaaaaaaaaaaaaaaaaage');
      // print(newUsers.image);
    });
  }

  // faaultyyyyyyyyyyyyyyyyyyyyyyyyyy

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Employee currentUser = arguments['currentUser'];
    print('hereeeeeeeeee');
    print(currentUser.password);
    bool editPass = arguments['editPass'];
    int currentIndex = DUMMY_EMP.indexWhere((e) => e.id == currentUser.id);
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
                            key: const ValueKey('email'),
                            initialValue: currentUser.email,
                            validator: (e) {
                              if (e!.isEmpty || !e.contains('@')) {
                                return 'يرجي ادخال بريد الكتروني صحيح';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (e) => newUsers = Employee(
                                id: currentUser.id,
                                image: currentUser.image,
                                fname: currentUser.fname,
                                lname: currentUser.lname,
                                email: e ?? currentUser.email,
                                password: currentUser.password,
                                phone: currentUser.phone,
                                location: currentUser.location,
                                address: currentUser.address,
                                role: currentUser.role,
                                bDate: currentUser.bDate,
                                categordId: currentUser.categordId),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'البريد الالكتروني',
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
                            key: const ValueKey('password'),
                            validator: (e) {
                              if (e!.isEmpty || e.length < 6) {
                                return 'يجب الا يفل الرقم السري عن 6 رموز';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (e) => newUsers = Employee(
                                id: newUsers.id,
                                image: newUsers.image,
                                fname: newUsers.fname,
                                lname: newUsers.lname,
                                email: newUsers.email,
                                password: e ?? currentUser.password,
                                phone: newUsers.phone,
                                location: newUsers.location,
                                address: newUsers.address,
                                role: newUsers.role,
                                bDate: newUsers.bDate,
                                categordId: newUsers.categordId),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.password,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'ادخل الرقم السري',
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
                              labelText: 'اعد ادخال الرقم السري',
                            ),
                            obscureText: true,
                          ),
                        if (!editPass) UserImagePicker(imagePick: _pickedImage),
                        if (!editPass)
                          const SizedBox(
                            height: 20,
                          ),
                        if (!editPass)
                          TextFormField(
                            initialValue: currentUser.fname,
                            key: const ValueKey('fname'),
                            validator: (e) {
                              if (e!.isEmpty) {
                                return 'يجب ادخال الاسم الاول';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (e) => newUsers = Employee(
                                bDate: currentUser.bDate,
                                image: newUsers.image != ''
                                    ? newUsers.image
                                    : currentUser.image,
                                id: currentUser.id,
                                fname: e ?? currentUser.fname,
                                lname: currentUser.lname,
                                email: currentUser.email,
                                password: currentUser.password,
                                phone: currentUser.phone,
                                location: currentUser.location,
                                address: currentUser.address,
                                categordId: currentUser.categordId,
                                role: currentUser.role),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
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
                            initialValue: currentUser.lname,
                            key: const ValueKey('lname'),
                            validator: (e) {
                              if (e!.isEmpty) {
                                return 'يجب ادخال الاسم الاخير';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (e) => newUsers = Employee(
                                bDate: newUsers.bDate,
                                image: newUsers.image,
                                categordId: newUsers.categordId,
                                id: newUsers.id,
                                fname: newUsers.fname,
                                lname: e ?? newUsers.lname,
                                email: newUsers.email,
                                password: newUsers.password,
                                phone: newUsers.phone,
                                location: newUsers.location,
                                address: newUsers.address,
                                role: newUsers.role),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
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
                            height: 20,
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
                            onSaved: (e) => newUsers = Employee(
                                bDate: newUsers.bDate,
                                image: newUsers.image,
                                categordId: newUsers.categordId,
                                id: newUsers.id,
                                fname: newUsers.fname,
                                lname: newUsers.lname,
                                phone:
                                    e == null ? newUsers.phone : int.parse(e),
                                email: newUsers.email,
                                password: newUsers.password,
                                location: newUsers.location,
                                address: newUsers.address,
                                role: newUsers.role),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.phone_enabled_outlined,
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
                            height: 20,
                          ),
                        if (!editPass)
                          TextFormField(
                            // initialValue: currentUser.bDate.toString(),
                            key: const ValueKey('bdate'),
                            validator: (e) {
                              if (e!.isEmpty && currentUser.bDate == null) {
                                return 'يجب ادخال تاريخ الميلاد';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (e) {
                              // print('HEREEEEEEEEEEEEEEEEEEEEEEEEEEEe');
                              // print(e);
                              // print(_pickedDate.text);
                              // print(newUsers.bDate);
                              newUsers = Employee(
                                  image: newUsers.image,
                                  categordId: newUsers.categordId,
                                  id: newUsers.id,
                                  fname: newUsers.fname,
                                  lname: newUsers.lname,
                                  email: newUsers.email,
                                  password: newUsers.password,
                                  phone: newUsers.phone,
                                  location: newUsers.location,
                                  address: newUsers.address,
                                  role: newUsers.role,
                                  bDate: e == ''
                                      ? newUsers.bDate
                                      : DateFormat.yMd().parse(e!));
                              // print(
                              //     'BDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDdd');
                              // print(newUsers.bDate);
                            },
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _datePicker();
                            },
                            controller: _pickedDate,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.date_range_outlined,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'تاريخ الميلاد',
                            ),
                          ),

                        if (!editPass)
                          const SizedBox(
                            height: 20,
                          ),
                        if (!editPass)
                          DropdownButtonFormField(
                              validator: (e) {
                                // ignore: unnecessary_null_comparison
                                if (e == null && currentUser.location == null) {
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
                                  labelText: 'المحافظة'
                                  // style: const TextStyle(color: Colors.white)

                                  // labelStyle: TextStyle(color: Colors.white)
                                  ),
                              isExpanded: true,
                              iconEnabledColor: Colors.white,
                              hint: _dropdownVal == null
                                  ? Text(
                                      currentUser.location,
                                    )
                                  : Text(
                                      _dropdownVal as String,
                                    ),
                              items: _items
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                                  .toList(),
                              onSaved: (String? e) => newUsers = Employee(
                                  bDate: newUsers.bDate,
                                  image: newUsers.image,
                                  categordId: newUsers.categordId,
                                  id: newUsers.id,
                                  fname: newUsers.fname,
                                  lname: newUsers.lname,
                                  email: newUsers.email,
                                  password: newUsers.password,
                                  phone: newUsers.phone,
                                  location: e ?? currentUser.location,
                                  address: newUsers.address,
                                  role: newUsers.role),
                              onChanged: (newVal) {
                                // print(
                                //     'neeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeew');
                                // print(newVal);
                                setState(() {
                                  // print('nowwwwwwwwwwwwwwwwwwwwwwwwwwwww');
                                  // _dropdownVal = newVal as String?;
                                  // print(_dropdownVal);
                                  newUsers = Employee(
                                      bDate: newUsers.bDate,
                                      image: newUsers.image,
                                      categordId: newUsers.categordId,
                                      id: newUsers.id,
                                      fname: newUsers.fname,
                                      lname: newUsers.lname,
                                      email: newUsers.email,
                                      password: newUsers.password,
                                      phone: newUsers.phone,
                                      location: _dropdownVal as String,
                                      address: newUsers.address,
                                      role: newUsers.role);
                                  // print(newUsers.location);
                                });
                              }),
                        if (!editPass)
                          const SizedBox(
                            height: 20,
                          ),
                        if (!editPass)
                          TextFormField(
                            key: const ValueKey('address'),
                            initialValue: currentUser.address,
                            validator: (e) {
                              if (e!.isEmpty) {
                                return 'يجب ادخال العنوان ';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (e) => newUsers = Employee(
                                bDate: newUsers.bDate,
                                image: newUsers.image,
                                categordId: newUsers.categordId,
                                id: newUsers.id,
                                fname: newUsers.fname,
                                lname: newUsers.lname,
                                phone: newUsers.phone,
                                email: newUsers.email,
                                password: newUsers.password,
                                location: newUsers.location,
                                address:
                                    e == '' ? currentUser.address : e as String,
                                role: newUsers.role),
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
                              height: 20,
                            ),
                        if (!editPass)
                          if (currentUser.role == 'worker')
                            DropdownButtonFormField(
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
                                    labelText: 'الحرفة'
                                    // style: const TextStyle(color: Colors.white)

                                    // labelStyle: TextStyle(color: Colors.white)
                                    ),
                                isExpanded: true,
                                iconEnabledColor: Colors.white,
                                hint: _dropdownValCat == null
                                    ? Text(
                                        currentUser.categordId as String,
                                      )
                                    : Text(
                                        _dropdownValCat as String,
                                      ),
                                items: _categories
                                    .map((e) => DropdownMenuItem(
                                          child: Text(e),
                                          value: e,
                                        ))
                                    .toList(),
                                onSaved: (String? e) => newUsers = Employee(
                                    bDate: newUsers.bDate,
                                    image: newUsers.image,
                                    categordId: e ?? currentUser.categordId,
                                    id: newUsers.id,
                                    fname: newUsers.fname,
                                    lname: newUsers.lname,
                                    email: newUsers.email,
                                    password: newUsers.password,
                                    phone: newUsers.phone,
                                    location: newUsers.location,
                                    address: newUsers.address,
                                    role: newUsers.role),
                                onChanged: (newVal) {
                                  setState(() {
                                    _dropdownValCat = newVal as String?;
                                    newUsers = Employee(
                                        bDate: newUsers.bDate,
                                        image: newUsers.image,
                                        categordId: _dropdownValCat,
                                        id: newUsers.id,
                                        fname: newUsers.fname,
                                        lname: newUsers.lname,
                                        email: newUsers.email,
                                        password: newUsers.password,
                                        phone: newUsers.phone,
                                        location: newUsers.location,
                                        address: newUsers.address,
                                        role: newUsers.role);
                                  });
                                }),
                        const SizedBox(
                          height: 20,
                        ),
                        if (_canEditPass)
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => _submit(),
                              child: const Text(
                                'تم',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                            ),
                          ),
                        if (!_canEditPass)
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // print('paaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaass');
                                // print(verifyPass);
                                final _valid =
                                    _formKey.currentState!.validate();
                                FocusScope.of(context).unfocus();
                                if (!_valid) {
                                  // print('invalid');
                                  return;
                                }
                                _formKey.currentState!.save();
                                if (verifyPass == currentUser.password) {
                                  setState(() {
                                    _canEditPass = true;
                                  });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: AlertDialog(
                                              title:
                                                  const Text('رقم السر خاطئ'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: const Text('حسنا'))
                                              ],
                                            ),
                                          ));
                                }
                              },
                              child: const Text(
                                'تم',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white)),
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
    print(currentUser.password);
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
