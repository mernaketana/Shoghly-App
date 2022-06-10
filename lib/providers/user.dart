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
    gender: '',
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

  Future<Employee> getUser() async {
    print('here i am');
    final url = Uri.parse(
        "https://cjyzhu7lw2.execute-api.eu-central-1.amazonaws.com/dev/profile/$userId");
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      // ignore: unnecessary_null_comparison
      if (data == null) {
        return Employee(
            id: '',
            address: '',
            fname: '',
            lname: '',
            email: '',
            password: '',
            gender: '',
            phone: 0,
            location: '',
            role: '');
      }
      Map<String, dynamic> employeeInfo = data["info"];
      _user = Employee(
          gender: employeeInfo["gender"],
          id: userId,
          address: employeeInfo["line"],
          fname: employeeInfo["firstName"],
          lname: employeeInfo["lastName"],
          email: '',
          password: '',
          phone: int.parse(employeeInfo["phone"]),
          location: employeeInfo["city"],
          role: employeeInfo["role"],
          categordId: employeeInfo["profession"],
          image: employeeInfo["picture"]);
      print(_user.image);
      notifyListeners();
      return _user;
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
    try {
      final response = await http.put(
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
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken"
        },
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
