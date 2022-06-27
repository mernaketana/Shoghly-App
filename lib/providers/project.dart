import "dart:async";
import "dart:convert";
import 'package:http/http.dart' as http;
import "package:flutter/cupertino.dart";
import 'package:project/models/worker_project.dart';
import '../providers/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Project with ChangeNotifier {
  late String authToken;
  late String userId;
  final apiUrl = dotenv.env['API_URL']!;

  void recieveToken(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

  Future<void> addProject(WorkerProject workerProject) async {
    final url = Uri.parse("${apiUrl}workers/projects");
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
        return;
      }
      Map<String, dynamic> employeeInfo = data["data"];
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Future<List<Employee>> search(String text, String city) async {
  //   final url = Uri.parse("${apiUrl}autoComplete");
  //   Map<String, String> queryParams = {'text': text, 'city': city};
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
  //   if (_user.id != '') {
  //     return _user;
  //   } else {
  //     return null;
  //   }
  // }
}
