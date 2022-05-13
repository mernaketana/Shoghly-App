import 'package:flutter/material.dart';
import '../screens/categories_screen.dart';
import '../screens/choice_screen.dart';
import '../dummy_data.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  final _passController = TextEditingController();
  String _userEmail = '';
  String _userPass = '';

  void _submit(BuildContext context) {
    final _valid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!_valid) {
      return;
    }
    _formKey.currentState!.save();
    if (!_isLogin) {
      Navigator.of(context).pushReplacementNamed(ChoicesScreen.routeName,
          arguments: {'userEmail': _userEmail, 'userPass': _userPass});
    } else {
      if (DUMMY_EMP.any((element) =>
          element.email == _userEmail && element.password == _userPass)) {
        final currentUser = DUMMY_EMP.firstWhere((element) =>
            element.email == _userEmail && element.password == _userPass);
        // print(currentUser);

        Navigator.of(context).pushReplacementNamed(CategoriesScreen.routeName,
            arguments: currentUser);
      } else if (!DUMMY_EMP.any((element) => element.email == _userEmail)) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text(
                  'لا يوجد مستعمل بهذا البريد',
                  textAlign: TextAlign.right,
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = false;
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('سجل الان'))
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text(
                  'يوجد خطأ في البريد الالكتروني او الرقم السري',
                  textAlign: TextAlign.right,
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('حسنا'))
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      decoration: const BoxDecoration(
          // color: Colors.grey,
          // borderRadius: new BorderRadius.circular(10.0),
          ),
      child: Padding(
          padding: const EdgeInsets.all(40),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      key: const ValueKey('email'),
                      validator: (e) {
                        if (e!.isEmpty || !e.contains('@')) {
                          return 'يرجي ادخال بريد الكتروني صحيح';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (e) => _userEmail = e as String,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'ادخل بريدك الالكتروني',
                        // labelStyle: TextStyle(color: Colors.white)
                      ),

                      // style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    TextFormField(
                      key: const ValueKey('password'),
                      validator: (e) {
                        if (e!.isEmpty || e.length < 6) {
                          return 'يجب الا يفل الرقم السري عن 6 رموز';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (e) => _userPass = e as String,
                      decoration: InputDecoration(
                        labelText: 'ادخل الرقم السري',
                        prefixIcon: const Icon(
                          Icons.password_outlined,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // labelStyle: TextStyle(color: Colors.white)
                        ),
                      ),
                      // style: const TextStyle(color: Colors.white),
                      controller: _passController,
                      obscureText: true,
                    ),
                    if (!_isLogin)
                      const SizedBox(
                        height: 35,
                      ),
                    if (!_isLogin)
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
                            Icons.password_outlined,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'اعد ادخال الرقم السري',
                          // labelStyle: TextStyle(color: Colors.white)
                        ),
                        // style: const TextStyle(color: Colors.white),
                        obscureText: true,
                      ),
                    const SizedBox(
                      height: 35,
                    ),
                    // if (widget.isLoading)
                    //   const CircularProgressIndicator(),
                    // if (!widget.isLoading)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _submit(context),
                        child: Text(
                          _isLogin ? 'الدخول' : 'التسجيل',
                          style: const TextStyle(
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
                    // if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'ليس لديك حساب؟\n\t\t\t\tقم بالتسجيل.'
                            : 'لديك حساب بالفعل؟\n\t\t\t\t\tقم بالدخول.',
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
              ))),
    ));
  }
}
