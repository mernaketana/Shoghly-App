import "dart:async";
import "dart:convert";
import 'dart:io';
import 'package:http/http.dart' as http;
import "package:flutter/cupertino.dart";
import 'package:project/models/employee.dart';
import '../providers/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  final apiUrl = dotenv.env['API_URL']!;

// for main to get the token and the user id from auth
  void recieveToken(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
    // print('recieve token in user provider');
    // print(userId);
  }

  Future<Employee> getUser(String userId) async {
    // print(dotenv.env['API_URL']);
    final url = Uri.parse("${apiUrl}users");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      print(data);
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
      Map<String, dynamic> employeeInfo = data["data"];
      _user = Employee(
        id: employeeInfo["id"],
        fname: employeeInfo["firstName"],
        lname: employeeInfo["lastName"],
        phone: int.parse(employeeInfo["phone"]),
        image: employeeInfo["picture"],
        categordId: employeeInfo["profession"],
        gender: employeeInfo["gender"],
        location: employeeInfo["city"],
        address: employeeInfo["line"],
        reviews: employeeInfo["reviews"],
        reviewsCount: employeeInfo["reviewsCount"],
        email: '',
        password: '',
        role: employeeInfo["role"],
      );
      // print(_user.image);
      notifyListeners();
      return _user;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Employee>> search(String text, String city) async {
    // print(text);
    // print(city);
    final url = Uri.parse("${apiUrl}autoComplete");
    Map<String, String> queryParams = {'text': text, 'city': city};
    final finalUrl = url.replace(queryParameters: queryParams);
    try {
      final response = await http.get(
        finalUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final employee = await getUser(userId);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final message = data['message'];
      final results = data['results'] as List<dynamic>;
      List<Employee> employees = [];
      final employeeIds = results.map((e) => e["userId"]).toList();
      for (var i = 0; i < employeeIds.length; i++) {
        await getUser(employeeIds[i]).then((value) {
          print(value);
          employees.add(value);
        });
      }
      // ignore: unnecessary_null_comparison
      if (data == null) {
        return [];
      }
      notifyListeners();
      return employees;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> editUser(String fname, String lname, String gender, String phone,
      String city, String address, String picture) async {
    final url = Uri.parse("${apiUrl}users");
    print(picture);
    try {
      final response = await http.put(
        url,
        body: json.encode({
          "firstName": fname,
          "lastName": lname,
          "phone": phone,
          "gender": gender,
          "country": "مصر",
          "city": city,
          "line": address,
          "picture": picture,
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
