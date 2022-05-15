import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/employee.dart';
import 'package:project/widgets/user_image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/Auth.dart';
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
  var _isLoading = false;

  // var newUsers = Employee(
  //     bDate: null,
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
  //     role: '');

  void _errorMessage(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An error occured'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Ok'))
              ],
            ));
  }

  Future<void> _submit() async {
    final _valid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!_valid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    print(_authData['firstName']);
    print(_authData['lastName']);
    print(_authData['gender']);
    print(_authData['role']);
    print(_authData['profession']);
    print(_authData['phone']);
    print(_authData['city']);
    print(_authData['line']);
    print(_authData['email']);
    print(_authData['password']);

    try {
      await Provider.of<Auth>(context, listen: false).signup(
          _authData['firstName'] as String,
          _authData['lastName'] as String,
          _authData['gender'] as String,
          _authData['role'] as String,
          _authData['profession'] as String,
          _authData['phone'] as String,
          _authData['city'] as String,
          _authData['line'] as String,
          _authData['email'] as String,
          _authData['password'] as String);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed.';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address already exists';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Invalid email address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _errorMessage(errorMessage);
    } catch (error) {
      var errorMessage = 'Authentication failed. Please try again later.';
      _errorMessage(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });

    // DUMMY_EMP.add(newUsers);
    // Navigator.of(context)
    //     .pushReplacementNamed(CategoriesScreen.routeName, arguments: newUsers);
  }

  // Future _datePicker() async {
  //   await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   ).then((date) {
  //     if (date == null) {
  //       return;
  //     }
  //     setState(() {
  //       _pickedDate.text = DateFormat.yMd().format(date);
  //     });
  //   });
  // }

  // void _pickedImage(File image) {
  //   _userImage = image.path; //بفوروارد بالعكس
  //   setState(() {
  //     newUsers = Employee(
  //         bDate: newUsers.bDate,
  //         categordId: newUsers.categordId,
  //         id: newUsers.id,
  //         fname: newUsers.fname,
  //         lname: newUsers.lname,
  //         email: newUsers.email,
  //         password: newUsers.password,
  //         phone: newUsers.phone,
  //         location: newUsers.location,
  //         address: newUsers.address,
  //         role: newUsers.role,
  //         image: _userImage);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    _authData['email'] = widget.userEmail;
    _authData['password'] = widget.userPass;
    _authData['role'] = widget.role;
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(40),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // UserImagePicker(imagePick: _pickedImage),
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
                      onSaved: (e) => _authData['firstName'] = e as String,

                      // newUsers = Employee(
                      //     bDate: newUsers.bDate,
                      //     image: newUsers.image,
                      //     id: DateTime.now().toString(),
                      //     fname: e as String,
                      //     lname: newUsers.lname,
                      //     email: widget.userEmail,
                      //     password: widget.userPass,
                      //     phone: newUsers.phone,
                      //     location: newUsers.location,
                      //     categordId: newUsers.categordId,
                      //     address: newUsers.address,
                      //     role: widget.role),
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
                      onSaved: (e) => _authData['lastName'] = e as String,
                      // newUsers = Employee(
                      //     bDate: newUsers.bDate,
                      //     image: newUsers.image,
                      //     categordId: newUsers.categordId,
                      //     id: newUsers.id,
                      //     fname: newUsers.fname,
                      //     lname: e as String,
                      //     email: newUsers.email,
                      //     address: newUsers.address,
                      //     password: newUsers.password,
                      //     phone: newUsers.phone,
                      //     location: newUsers.location,
                      //     role: newUsers.role),
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
                      onSaved: (e) => _authData['phone'] = e as String,
                      // newUsers = Employee(
                      //     bDate: newUsers.bDate,
                      //     image: newUsers.image,
                      //     categordId: newUsers.categordId,
                      //     id: newUsers.id,
                      //     fname: newUsers.fname,
                      //     lname: newUsers.lname,
                      //     phone: int.parse(e as String),
                      //     email: newUsers.email,
                      //     password: newUsers.password,
                      //     location: newUsers.location,
                      //     address: newUsers.address,
                      //     role: newUsers.role),
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
                    DropdownButtonFormField(
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
                            labelText: 'الجنس'
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
                        // newUsers = Employee(
                        //     bDate: newUsers.bDate,
                        //     image: newUsers.image,
                        //     categordId: e as String,
                        //     id: newUsers.id,
                        //     fname: newUsers.fname,
                        //     lname: newUsers.lname,
                        //     email: newUsers.email,
                        //     password: newUsers.password,
                        //     phone: newUsers.phone,
                        //     location: newUsers.location,
                        //     address: newUsers.address,
                        //     role: newUsers.role),
                        onChanged: (newVal) {
                          // setState(() {
                          _dropdownValCat = newVal as String?;
                          //   newUsers = Employee(
                          //       bDate: newUsers.bDate,
                          //       image: newUsers.image,
                          //       categordId: _dropdownValCat,
                          //       id: newUsers.id,
                          //       fname: newUsers.fname,
                          //       lname: newUsers.lname,
                          //       email: newUsers.email,
                          //       password: newUsers.password,
                          //       phone: newUsers.phone,
                          //       location: newUsers.location,
                          //       address: newUsers.address,
                          //       role: newUsers.role);
                          // });
                        }),
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
                        onSaved: (String? e) => _authData['city'] = e as String,
                        // newUsers = Employee(
                        //     bDate: newUsers.bDate,
                        //     image: newUsers.image,
                        //     categordId: newUsers.categordId,
                        //     id: newUsers.id,
                        //     fname: newUsers.fname,
                        //     lname: newUsers.lname,
                        //     email: newUsers.email,
                        //     password: newUsers.password,
                        //     phone: newUsers.phone,
                        //     location: e as String,
                        //     address: newUsers.address,
                        //     role: newUsers.role),
                        onChanged: (newVal) {
                          // setState(() {
                          _dropdownVal = newVal as String?;
                          // newUsers = Employee(
                          //     bDate: newUsers.bDate,
                          //     image: newUsers.image,
                          //     categordId: newUsers.categordId,
                          //     id: newUsers.id,
                          //     fname: newUsers.fname,
                          //     lname: newUsers.lname,
                          //     email: newUsers.email,
                          //     password: newUsers.password,
                          //     phone: newUsers.phone,
                          //     location: _dropdownVal as String,
                          //     address: newUsers.address,
                          //     role: newUsers.role);
                          // });
                        }),
                    const SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      key: const ValueKey('address'),
                      validator: (e) {
                        if (e!.isEmpty) {
                          return 'يجب ادخال العنوان ';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (e) => _authData['line'] = e as String,
                      // newUsers = Employee(
                      //     bDate: newUsers.bDate,
                      //     image: newUsers.image,
                      //     categordId: newUsers.categordId,
                      //     id: newUsers.id,
                      //     fname: newUsers.fname,
                      //     lname: newUsers.lname,
                      //     phone: newUsers.phone,
                      //     email: newUsers.email,
                      //     password: newUsers.password,
                      //     location: newUsers.location,
                      //     address: e as String,
                      //     role: newUsers.role),
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
                          onSaved: (String? e) =>
                              _authData['profession'] = e as String,
                          // newUsers = Employee(
                          //     bDate: newUsers.bDate,
                          //     image: newUsers.image,
                          //     categordId: e as String,
                          //     id: newUsers.id,
                          //     fname: newUsers.fname,
                          //     lname: newUsers.lname,
                          //     email: newUsers.email,
                          //     password: newUsers.password,
                          //     phone: newUsers.phone,
                          //     location: newUsers.location,
                          //     address: newUsers.address,
                          //     role: newUsers.role),
                          onChanged: (newVal) {
                            // setState(() {
                            _dropdownValCat = newVal as String?;
                            //   newUsers = Employee(
                            //       bDate: newUsers.bDate,
                            //       image: newUsers.image,
                            //       categordId: _dropdownValCat,
                            //       id: newUsers.id,
                            //       fname: newUsers.fname,
                            //       lname: newUsers.lname,
                            //       email: newUsers.email,
                            //       password: newUsers.password,
                            //       phone: newUsers.phone,
                            //       location: newUsers.location,
                            //       address: newUsers.address,
                            //       role: newUsers.role);
                            // });
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
