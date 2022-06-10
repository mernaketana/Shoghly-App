import "dart:async";
import "dart:convert";
import 'package:http/http.dart' as http;
import "package:flutter/cupertino.dart";
import 'package:project/providers/images.dart';
import "package:shared_preferences/shared_preferences.dart";
import "../helpers/http_exception.dart";

class Auth with ChangeNotifier {
  String? _token; //tokens expire after an amount of time typically one hour
  // DateTime? _expiryDate;
  String? _userId;
  late String imageUrl;
  // Timer? _authTimer;

  Future<void> signup(
      String fname,
      String lname,
      String gender,
      String role,
      String profession,
      String phone,
      String city,
      String address,
      String email,
      String password) async {
    final url = Uri.parse(
        "https://cjyzhu7lw2.execute-api.eu-central-1.amazonaws.com/dev/signup");
    try {
      print("auth signup");
      print(imageUrl);
      final response = await http.post(
        url,
        body: json.encode({
          "firstName": fname,
          "lastName": lname,
          "email": email,
          "password": password,
          "gender": gender,
          "role": role,
          "profession": profession,
          "phone": phone,
          "picture": imageUrl,
          "country": "مصر",
          "city": city,
          "line": address
        }),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData["error"] != null) {
        throw HttpException(responseData["message"]);
      }
      // _token = responseData["id"];
      _userId = responseData["id"];
      // _expiryDate = DateTime.now()
      //     .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      // _autoLogOut();
      notifyListeners();
      signin(email, password);
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
      });
      prefs.setString("userData", userData);
      // print("=====================>");
      // print(prefs.getString("userData"));
    } catch (error) {
      //Firebase doesn"t return an error, it doesn"t have an error status
      rethrow;
      // print(error);
    }
  }

  Future<void> signin(String email, String password) async {
    // print(email);
    // print(password);
    final url = Uri.parse(
        "https://cjyzhu7lw2.execute-api.eu-central-1.amazonaws.com/dev/signin");
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
        }),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData["error"] != null) {
        throw HttpException(responseData["message"]);
      }
      _token = responseData["accessToken"];
      _userId = responseData["userId"];
      // _expiryDate = DateTime.now()
      //     .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      // _autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        // "expiryDate": _expiryDate!.toIso8601String(),
      });
      prefs.setString("userData", userData);
      // print("=====================>");
      // print(prefs.getString("userData"));
    } catch (error) {
      //Firebase doesn"t return an error, it doesn"t have an error status
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    final url = Uri.parse(
        "https://cjyzhu7lw2.execute-api.eu-central-1.amazonaws.com/dev/signup");
    // print(password);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "email": email,
        }),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData["error"] != null) {
        throw HttpException(responseData["message"]);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final url = Uri.parse(
        "https://cjyzhu7lw2.execute-api.eu-central-1.amazonaws.com/dev/change-password");
    try {
      final response = await http.post(
        url,
        body: json
            .encode({"oldPassword": oldPassword, "newPassword": newPassword}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $_token'
        },
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData["error"] != null) {
        throw HttpException(responseData["message"]);
      }
      _userId = responseData["id"];
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogIn() async {
    // print('I TRIEEEEEEEEEEEEEEEEEEEEEED');
    final prefs = await SharedPreferences.getInstance();
    // print(prefs.getString('userData'));
    if (!prefs.containsKey('userData')) {
      return false;
    } else {
      // print('Do I get here?');
      final extractedUserData =
          json.decode(prefs.getString('userData') as String)
              as Map<String, dynamic>;
      // print(extractedUserData);
      // final expiryDate =
      //     DateTime.parse(extractedUserData['expiryDate'] as String);
      // print('why');
      // if (expiryDate.isBefore(DateTime.now())) {
      if (extractedUserData['token'] == null) {
        return false;
      }
      _token = extractedUserData['token'] as String;
      _userId = extractedUserData['userId'] as String;
      // _expiryDate = expiryDate;
      // print(_token);
      // print(_userId);
      // print(_expiryDate);
      notifyListeners();
      // _autoLogOut();
    }
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    // if (_authTimer != null) {
    //   _authTimer!.cancel();
    //   _authTimer = null;
    // }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // Future<void> logIn(String email, String password) async {
  //   return _authenticate(email, password, "signInWithPassword");
  // }
  // Future<void> logIn(String fname, String lname, String gender, String role, String profession, String phone, String city, String address,
  //     String email, String password) async {
  //   return _authenticate(fname, lname, gender, role, profession, phone, city, address, email, password, "signin");
  // }

  bool get isAuth {
    // print('****************');
    // print(_token);
    return token != '';
  }

  String get token {
    if (_token != null) {
      // print(_token);
      // print(_userId);
      // print(_expiryDate);
      // print('ok');
      return _token as String;
    }
    // print(_token);
    // print(_userId);
    // print(_expiryDate);
    // print('not Ok');
    return '';
  }

  String get userId {
    return _userId == null ? '' : _userId as String;
  }
}
