import "dart:async";
import "dart:convert";
import 'dart:io';
import 'package:http/http.dart' as http;
import "package:flutter/cupertino.dart";
import 'package:project/models/employee.dart';
import '../providers/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  }

  Future<Employee> getUser(String userId) async {
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
        email: '',
        password: '',
        role: employeeInfo["role"],
      );
      notifyListeners();
      return _user;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Employee>> search(String text, String city) async {
    print(authToken);
    final url = Uri.parse("${apiUrl}autoComplete");
    print('in provider');
    print(city);
    print(text);
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
      final data = json.decode(response.body) as Map<String, dynamic>;
      print(data);
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
    if (_user.id != '') {
      return _user;
    } else {
      return null;
    }
  }
}
