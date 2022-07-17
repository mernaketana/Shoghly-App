import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
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
  // ignore: unused_field
  String? _dropdownVal;
  // ignore: unused_field
  String? _dropdownValCat;
  final _categories = DUMMY_CATEGORIES.map((e) => e.title).toList();

  // ignore: prefer_final_fields
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
      Navigator.of(context).pop();
    } on HttpException catch (_) {
      var errorMessage = 'حدث خطأ ما';
      _errorMessage(errorMessage);
    } catch (error) {
      // ignore: avoid_print
      print(error.toString());
      var errorMessage = 'حدث خطأ ما رجاء المحاولة في وقت لاحق';
      _errorMessage(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

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
                    const SizedBox(
                      height: 14,
                    ),
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
                            labelText: 'الجنس'),
                        isExpanded: true,
                        iconEnabledColor: Colors.white,
                        items: const [
                          DropdownMenuItem(
                            child: Text('انثى'),
                            value: 'انثى',
                          ),
                          DropdownMenuItem(
                            child: Text('ذكر'),
                            value: 'ذكر',
                          )
                        ],
                        onSaved: (String? e) =>
                            _authData['gender'] = e as String,
                        onChanged: (newVal) {
                          _dropdownValCat = newVal as String?;
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
                        items: CITIES
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onSaved: (String? e) => _authData['city'] = e as String,
                        onChanged: (newVal) {
                          _dropdownVal = newVal as String?;
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
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.home,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'العنوان',
                      ),
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
                              labelText: 'مجال العمل'),
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
                    const SizedBox(
                      height: 20,
                    ),
                    if (_isLoading)
                      SpinKitSpinningLines(
                          color: Theme.of(context).colorScheme.primary)
                    else
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
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary),
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
