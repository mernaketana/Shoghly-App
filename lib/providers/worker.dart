import "dart:async";
import "dart:convert";
import 'dart:io';
import 'package:http/http.dart' as http;
import "package:flutter/cupertino.dart";
import 'package:project/models/employee.dart';
import '../models/comment.dart';
import '../providers/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Worker with ChangeNotifier {
  late String authToken;
  late String userId;
  List<Employee> _employees = [];
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

  Future<void> getWorkers(String city, String profession) async {
    final url = Uri.parse("${apiUrl}workers");
    Map<String, String> queryParams = {'city': city, 'profession': profession};
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
      // ignore: unnecessary_null_comparison
      if (data == null) {
        return;
      }
      final employeesData = data['data'];
      final employeesList = employeesData['workers'];
      final tot_no_of_employees = employeesData['count'];
      if (tot_no_of_employees > 0) {
        for (var i = 0; i < tot_no_of_employees; i++) {
          final currentEmp = Employee(
              id: employeesList[i]['id'],
              address: employeesList[i]['line'],
              fname: employeesList[i]['firstName'],
              lname: employeesList[i]['lastName'],
              email: '',
              password: '',
              gender: employeesList[i]['gender'],
              phone: int.parse(employeesList[i]['phone']),
              location: employeesList[i]['city'],
              role: employeesList[i]['role'],
              image: employeesList[i]['picture'],
              categordId: employeesList[i]['profession'],
              reviews: employeesList[i]['reviews']);
          if (!_employees.any(
            (element) => element.id == currentEmp.id,
          )) {
            _employees.add(currentEmp);
          }
        }
      }
      print('EMPLOYEEEEES');
      print(_employees);
      // print(_user.image);
      notifyListeners();

      // return _user;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getWorker(String workerId) async {
    final url = Uri.parse("${apiUrl}workers/$workerId");
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
        return {};
      }
      final employeeData = data['data'];
      final employee = Employee(
          id: employeeData["id"],
          address: employeeData["line"],
          fname: employeeData["firstName"],
          lname: employeeData["lastName"],
          email: '',
          password: '',
          gender: employeeData["gender"],
          phone: int.parse(employeeData["phone"]),
          location: employeeData["city"],
          role: employeeData["role"],
          image: employeeData["picture"],
          categordId: employeeData["profession"]);
      List userReviews = employeeData["reviews"];
      final workerComments = <Comment>[];
      for (var i = 0; i < userReviews.length; i++) {
        final currentComment = userReviews[i];
        final review = Comment(
            reviewId: currentComment["reviewId"],
            updatedAt: DateTime.parse(currentComment["updatedAt"]),
            user: Commenter(
                id: currentComment["client"]["id"],
                fname: currentComment["client"]["firstName"],
                lname: currentComment["client"]["lastName"],
                picture: currentComment["client"]["picture"],
                gender: currentComment["client"]["gender"]),
            comment: currentComment["description"],
            workerId: workerId,
            createdAt: DateTime.parse(currentComment['createdAt']),
            rate: (currentComment["rating"] as int).toDouble());
        workerComments.add(review);
      }
      final output = {"employee": employee, "workerComments": workerComments};
      return output;
      // final employeesList = employeesData['workers'];
      // final tot_no_of_employees = employeesData['count'];
      // if (tot_no_of_employees > 0) {
      //   for (var i = 0; i < tot_no_of_employees; i++) {
      //     final currentEmp = Employee(
      //         id: employeesList[i]['id'],
      //         address: employeesList[i]['line'],
      //         fname: employeesList[i]['firstName'],
      //         lname: employeesList[i]['lastName'],
      //         email: '',
      //         password: '',
      //         gender: employeesList[i]['gender'],
      //         phone: int.parse(employeesList[i]['phone']),
      //         location: employeesList[i]['city'],
      //         role: employeesList[i]['role'],
      //         image: employeesList[i]['picture'],
      //         categordId: employeesList[i]['profession'],
      //         reviews: employeesList[i]['reviews']);
      //     if (!_employees.any(
      //       (element) => element.id == currentEmp.id,
      //     )) {
      //       _employees.add(currentEmp);
      //     }
      //   }
      // }
      // print('EMPLOYEEEEES');
      // print(_employees);
      // print(_user.image);
      notifyListeners();

      // return _user;
    } catch (error) {
      rethrow;
    }
  }

  List<Employee> get employees {
    return _employees;
  }

  // Future<List<Employee>> search(String text, String city) async {
  //   // print(text);
  //   // print(city);
  //   Map<String, String> queryParams = {'text': text, 'city': city};
  //   final url = Uri.parse("${apiUrl}autoComplete");
  //   final finalUrl = url.replace(queryParameters: queryParams);
  //   try {
  //     final response = await http.get(
  //       finalUrl,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $authToken",
  //       },
  //     );
  //     final employee = await getUser(userId);
  //     final data = json.decode(response.body) as Map<String, dynamic>;
  //     final message = data['message'];
  //     final results = data['results'] as List<dynamic>;
  //     List<Employee> employees = [];
  //     final employeeIds = results.map((e) => e["userId"]).toList();
  //     for (var i = 0; i < employeeIds.length; i++) {
  //       await getUser(employeeIds[i]).then((value) {
  //         print(value);
  //         employees.add(value);
  //       });
  //     }
  //     // ignore: unnecessary_null_comparison
  //     if (data == null) {
  //       return [];
  //     }
  //     notifyListeners();
  //     return employees;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  // Future<void> editUser(String fname, String lname, String gender, String phone,
  //     String city, String address, String picture) async {
  //   final url = Uri.parse("${apiUrl}users");
  //   print(picture);
  //   try {
  //     final response = await http.put(
  //       url,
  //       body: json.encode({
  //         "firstName": fname,
  //         "lastName": lname,
  //         "phone": phone,
  //         "gender": gender,
  //         "country": "مصر",
  //         "city": city,
  //         "line": address,
  //         "picture": picture,
  //       }),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $authToken"
  //       },
  //     );
  //     final responseData = json.decode(response.body);
  //     print(responseData);
  //     if (responseData["error"] != null) {
  //       throw HttpException(responseData["message"]);
  //     }
  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  // Employee? get currentUser {
  //   // print(_user.id);
  //   if (_user.id != '') {
  //     // print('****************************************');
  //     // print(_user);
  //     return _user;
  //   } else {
  //     // print('user is null');
  //     return null;
  //   }
  // }
}
