import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/employee.dart';
import 'package:project/widgets/user_image_picker.dart';
import '../screens/categories_screen.dart';
import '../dummy_data.dart';

class DetailedAuthForm extends StatefulWidget {
  final String role;
  final String userEmail;
  final String userPass;
  const DetailedAuthForm(
      {Key? key,
      required this.role,
      required this.userEmail,
      required this.userPass})
      : super(key: key);

  @override
  State<DetailedAuthForm> createState() => _DetailedAuthFormState();
}

class _DetailedAuthFormState extends State<DetailedAuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _pickedDate = TextEditingController();
  String? _dropdownVal;
  String? _dropdownValCat;
  String? _userImage;
  final _items = [
    'بورسعيد',
    'القاهرة',
    'الاسكندرية',
    'الاسماعيلية',
    'المنصورة',
    'المنوفية'
  ];
  final _categories = DUMMY_CATEGORIES.map((e) => e.title).toList();
  // var newUsers = const Employee(
  //     id: '',
  //     categordId: '',
  //     name: '',
  //     email: '',
  //     password: '',
  //     phone: 0,
  //     location: '',
  //     role: true);
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
      role: '');

  void _submit() {
    final _valid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!_valid) {
      return;
    }
    _formKey.currentState!.save();
    DUMMY_EMP.add(newUsers);
    // print(newUsers.bDate);
    // print(newUsers.bDate);
    // print(newUsers.categordId);
    // print(newUsers.email);
    // print(newUsers.id);
    // print(newUsers.role);
    // print(newUsers.location);
    // print(newUsers.name);

    Navigator.of(context)
        .pushReplacementNamed(CategoriesScreen.routeName, arguments: newUsers);
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
          categordId: newUsers.categordId,
          id: newUsers.id,
          fname: newUsers.fname,
          lname: newUsers.lname,
          email: newUsers.email,
          password: newUsers.password,
          phone: newUsers.phone,
          location: newUsers.location,
          role: newUsers.role,
          image: _userImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(40),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    UserImagePicker(imagePick: _pickedImage),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      key: const ValueKey('fname'),
                      validator: (e) {
                        if (e!.isEmpty) {
                          return 'يجب ادخال الاسم الاول';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (e) => newUsers = Employee(
                          image: newUsers.image,
                          id: DateTime.now().toString(),
                          fname: e as String,
                          lname: newUsers.lname,
                          email: widget.userEmail,
                          password: widget.userPass,
                          phone: newUsers.phone,
                          location: newUsers.location,
                          categordId: newUsers.categordId,
                          role: widget.role),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'الاسم الاول',
                        // labelStyle: TextStyle(color: Colors.white)
                      ),
                      // style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      key: const ValueKey('lname'),
                      validator: (e) {
                        if (e!.isEmpty) {
                          return 'يجب ادخال الاسم الاخير';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (e) => newUsers = Employee(
                          image: newUsers.image,
                          categordId: newUsers.categordId,
                          id: newUsers.id,
                          fname: newUsers.fname,
                          lname: e as String,
                          email: newUsers.email,
                          password: newUsers.password,
                          phone: newUsers.phone,
                          location: newUsers.location,
                          role: newUsers.role),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'الاسم الاخير',
                        // labelStyle: TextStyle(color: Colors.white)
                      ),
                      // style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    TextFormField(
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
                          image: newUsers.image,
                          categordId: newUsers.categordId,
                          id: DateTime.now().toString(),
                          fname: newUsers.fname,
                          lname: newUsers.lname,
                          phone: int.parse(e as String),
                          email: newUsers.email,
                          password: newUsers.password,
                          location: newUsers.location,
                          role: newUsers.role),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'رقم الهاتف',
                        // labelStyle: TextStyle(color: Colors.white)
                      ),
                      // style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    // TextFormField(
                    //   key: const ValueKey('lname'),
                    //   validator: (e) {
                    //     if (e!.isEmpty) {
                    //       return 'يجب ادخال الاسم الاخير';
                    //     } else {
                    //       return null;
                    //     }
                    //   },
                    //   // onSaved: (e) => _userEmail = e as String,
                    //   decoration: const InputDecoration(
                    //       labelText: 'الاسم الاخير (اللقب)',
                    //       labelStyle: TextStyle(color: Colors.white)),
                    //   style: const TextStyle(color: Colors.white),
                    // ),
                    TextFormField(
                      key: const ValueKey('bdate'),
                      validator: (e) {
                        if (e!.isEmpty) {
                          return 'يجب ادخال تاريخ الميلاد';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (e) => newUsers = Employee(
                          image: newUsers.image,
                          categordId: newUsers.categordId,
                          id: newUsers.id,
                          fname: newUsers.fname,
                          lname: newUsers.lname,
                          email: newUsers.email,
                          password: newUsers.password,
                          phone: newUsers.phone,
                          location: newUsers.location,
                          role: newUsers.role,
                          bDate: DateFormat.yMd().parse(e as String)),
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
                        // labelStyle: TextStyle(color: Colors.white)
                      ),
                      // style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    DropdownButtonFormField(
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
                        onChanged: (newVal) {
                          setState(() {
                            _dropdownVal = newVal as String?;
                            newUsers = Employee(
                                image: newUsers.image,
                                categordId: newUsers.categordId,
                                id: newUsers.id,
                                fname: newUsers.fname,
                                lname: newUsers.lname,
                                email: newUsers.email,
                                password: newUsers.password,
                                phone: newUsers.phone,
                                location: _dropdownVal as String,
                                role: newUsers.role);
                          });
                        }),
                    if (widget.role == 'worker')
                      const SizedBox(
                        height: 14,
                      ),
                    if (widget.role == 'worker')
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
                              labelText: 'مجال العمل'
                              // style: const TextStyle(color: Colors.white)

                              // labelStyle: TextStyle(color: Colors.white)
                              ),
                          isExpanded: true,
                          iconEnabledColor: Colors.white,
                          // hint: _dropdownValCat == null
                          //     ? const Text(
                          //         'مجال العمل',
                          //         // style: TextStyle(color: Colors.white),
                          //       )
                          //     : Text(
                          //         _dropdownValCat as String,
                          //         // style: const TextStyle(color: Colors.white)
                          //       ),
                          items: _categories
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (newVal) {
                            setState(() {
                              _dropdownValCat = newVal as String?;
                              newUsers = Employee(
                                  image: newUsers.image,
                                  categordId: _dropdownValCat,
                                  id: newUsers.id,
                                  fname: newUsers.fname,
                                  lname: newUsers.lname,
                                  email: newUsers.email,
                                  password: newUsers.password,
                                  phone: newUsers.phone,
                                  location: newUsers.location,
                                  role: newUsers.role);
                            });
                          }),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: const Text(
                          'التسجيل',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
