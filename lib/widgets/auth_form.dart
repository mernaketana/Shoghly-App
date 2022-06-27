import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/http_exception.dart';
import '../providers/auth.dart';
import '../screens/choice_screen.dart';

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
  var _isLoading = false;

  void _errorMessage(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('حدث خطأ ما'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('حسنا'))
              ],
            ));
  }

  Future<void> _submit(BuildContext context) async {
    final _valid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // Invalid
    if (!_valid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (!_isLogin) {
      Navigator.of(context).pushNamed(ChoicesScreen.routeName,
          arguments: {'userEmail': _userEmail, 'userPass': _userPass});
    } else {
      try {
        await Provider.of<Auth>(context, listen: false)
            .signin(_userEmail, _userPass);
      } on HttpException catch (_) {
        var errorMessage = 'حدث خطأ ما';
        _errorMessage(errorMessage);
      } catch (error) {
        var errorMessage = 'حدث خطأ ما';
        _errorMessage(errorMessage);
      }
      _isLoading = false;
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
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
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
                    const SizedBox(
                      height: 10,
                    ),
                    // if (!widget.isLoading)
                    TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin ? 'ليس لديك حساب؟ ' : 'لديك حساب بالفعل؟ ',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            _isLogin ? 'إنشاء حساب جديد' : 'تسجيل الدخول',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        onPressed: () {},
                        child: const Text('إعادة ضبط كلمة المرور')),
                  ],
                ),
              ))),
    ));
  }
}
