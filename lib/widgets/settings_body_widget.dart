import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../dummy_data.dart';
import '../models/employee.dart';
import '../providers/auth.dart';
import '../providers/user.dart';
import './user_image_picker.dart';

class SettingsBody extends StatefulWidget {
  static const routeName = '/settings-screen';
  const SettingsBody({Key? key}) : super(key: key);

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  final _formKey = GlobalKey<FormState>();
  // final _pickedDate = TextEditingController();
  // ignore: unused_field
  String? _dropdownVal;
  // ignore: unused_field
  String? _dropdownValCat;
  final _categories = DUMMY_CATEGORIES.map((e) => e.title).toList();
  final _passController = TextEditingController();
  late String oldPass;
  late String newPass;
  var isLoading = false;
  // ignore: prefer_final_fields
  Map<String, String> _authData = {
    'picture': '',
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
  late Employee currentUser;
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final userId = Provider.of<User>(context, listen: false).userId;
      await Provider.of<User>(context)
          .getUser(userId)
          .then((value) => currentUser = value);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  Future<void> _submitPass() async {
    final _valid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!_valid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
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
        _authData["line"] as String,
        _authData["picture"]!);

    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  void _pickedImage(String image) {
    _authData["picture"] = image; //بفوروارد بالعكس
  }

  @override
  Widget build(BuildContext context) {
    bool editPass = ModalRoute.of(context)!.settings.arguments as bool;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Text('تعديل'),
        ),
        body: _isLoading
            ? Center(
                child: SpinKitSpinningLines(
                    color: Theme.of(context).colorScheme.primary),
              )
            : Center(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
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
                                ),
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
                            if (!editPass)
                              UserImagePicker(imagePick: _pickedImage),
                            if (!editPass)
                              const SizedBox(
                                height: 20,
                              ),
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
                                onSaved: (e) =>
                                    _authData['lastName'] = e as String,
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
                                initialValue:
                                    '0${currentUser.phone.toString()}',
                                key: const ValueKey('phonenum'),
                                validator: (e) {
                                  if (e!.isEmpty) {
                                    return 'يجب ادخال رقم الهاتف';
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.number,
                                onSaved: (e) =>
                                    _authData['phone'] = e as String,
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
                            if (!editPass)
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                            if (!editPass)
                              const SizedBox(
                                height: 14,
                              ),
                            if (!editPass)
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                ),
                              ),
                            if (!editPass)
                              if (currentUser.role == 'worker')
                                const SizedBox(
                                  height: 14,
                                ),
                            if (!editPass)
                              if (currentUser.role == 'worker')
                                DropdownButtonFormField(
                                    value: currentUser.categordId,
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
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                            SizedBox(
                              height: editPass ? 40 : 20,
                            ),
                            SizedBox(
                              width: isLoading ? 50 : double.infinity,
                              height: 50,
                              child: isLoading
                                  ? SpinKitSpinningLines(
                                      color:
                                          Theme.of(context).colorScheme.primary)
                                  : ElevatedButton(
                                      onPressed: () => editPass
                                          ? _submitPass()
                                          : _submitUser(),
                                      child: const Text(
                                        'تم',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all(0),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white)),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ))),
      ),
    );
  }
}
