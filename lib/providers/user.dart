import "dart:async";
import "dart:convert";
import 'dart:io';
import 'package:http/http.dart' as http;
import "package:flutter/cupertino.dart";
import 'package:project/models/employee.dart';
import '../providers/auth.dart';
// import "package:shared_preferences/shared_preferences.dart";
// import "../helpers/http_exception.dart";

class User with ChangeNotifier {
  late String authToken;
  late String userId;
  Employee _user = Employee(
    id: '',
    address: '',
    fname: '',
    lname: '',
    email: '',
    password: '',
    phone: 0,
    location: '',
    role: '',
    categordId: '',
  );

// for main to get the token and the user id from auth
  void recieveToken(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
    // print('recieve token in user provider');
    // print(userId);
  }

  Future<void> getUser() async {
    // print('getuser user provider');
    // print(userId);
    // final prefs = await SharedPreferences.getInstance();
    // // print(prefs.getString('userData'));
    // if (!prefs.containsKey('userData')) {
    //   return null;
    // } else {
    //   // print('Do I get here?');
    //   final extractedUserData =
    //       json.decode(prefs.getString('userData') as String)
    //           as Map<String, dynamic>;
    //   if (extractedUserData['token'] == null) {
    //     return null;
    //   }
    // _userId = extractedUserData['userId'] as String;
    final url = Uri.parse(
        "https://cjyzhu7lw2.execute-api.eu-central-1.amazonaws.com/dev/profile/$userId");
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      // print(data);
      // ignore: unnecessary_null_comparison
      if (data == null) {
        return;
      }
      Map<String, dynamic> employeeInfo = data["info"];
      _user = Employee(
        id: userId,
        address: employeeInfo["line"],
        fname: employeeInfo["firstName"],
        lname: employeeInfo["lastName"],
        email: '',
        password: '',
        phone: int.parse(employeeInfo["phone"]),
        location: 'مصر',
        role: employeeInfo["role"],
        categordId: employeeInfo["profession"],
      );
      notifyListeners();
      // return _user;
      // print(data);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> editUser(
    String fname,
    String lname,
    String gender,
    String phone,
    String city,
    String address,
  ) async {
    final url = Uri.parse(
        "https://cjyzhu7lw2.execute-api.eu-central-1.amazonaws.com/dev/profile");
    // print(password);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "firstName": fname,
          "lastName": lname,
          "gender": gender,
          "phone": phone,
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
      // _expiryDate = DateTime.now()
      //     .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      // _autoLogOut();
      notifyListeners();
      // final prefs = await SharedPreferences.getInstance();
      // final userData = json.encode({
      //   "token": _token,
      //   "userId": _userId,
      //   "expiryDate": _expiryDate!.toIso8601String(),
      // });
      // prefs.setString("userData", userData);
      // print("=====================>");
      // print(prefs.getString("userData"));
    } catch (error) {
      //Firebase doesn"t return an error, it doesn"t have an error status
      rethrow;
      // print(error);
    }
  }

  Employee? get currentUser {
    // print(_user.id);
    if (_user.id != '') {
      // print('****************************************');
      // print(_user);
      return _user;
    } else {
      // print('user is null');
      return null;
    }
  }
}
