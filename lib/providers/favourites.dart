import "dart:async";
import "dart:convert";
import 'package:http/http.dart' as http;
import "package:flutter/cupertino.dart";
import 'package:project/models/worker_project.dart';
import '../models/employee.dart';
import '../providers/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Favourites with ChangeNotifier {
  late String authToken;
  late String userId;
  final apiUrl = dotenv.env['API_URL']!;

  void recieveToken(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

  Future<void> addFavourite(String workerId) async {
    final url = Uri.parse("${apiUrl}favorites/workers/$workerId");
    Map<String, String> queryParams = {'workerId': workerId};
    final finalUrl = url.replace(queryParameters: queryParams);
    print('add favourite');
    try {
      final response = await http.post(
        finalUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final data = json.decode(response.body);
      print(data);
      // ignore: unnecessary_null_comparison
      if (data == null) {
        return;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteFavourite(String workerId) async {
    final url = Uri.parse("${apiUrl}favorites/workers/$workerId");
    Map<String, String> queryParams = {'workerId': workerId};
    final finalUrl = url.replace(queryParameters: queryParams);
    try {
      final response = await http.delete(
        finalUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      // final employee = await getUser(userId);
      final data = json.decode(response.body) as Map<String, dynamic>;
      print(data);
      // ignore: unnecessary_null_comparison
      if (data == null) {
        return;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Employee>> getAllFavourites() async {
    final url = Uri.parse("${apiUrl}favorites");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      final accessWorkers = data["data"];
      print(data);
      List<Employee> employees = [];
      for (var i = 0; i < accessWorkers.length; i++) {
        print(accessWorkers[i]["worker"]['averageRating'].runtimeType);
        final emp = Employee(
            id: accessWorkers[i]["worker"]['id'],
            image: accessWorkers[i]["worker"]['picture'],
            categordId: accessWorkers[i]["worker"]['profession'],
            address: '',
            fname: accessWorkers[i]["worker"]['firstName'],
            lname: accessWorkers[i]["worker"]['lastName'],
            email: '',
            avgRate: double.parse(
                ((accessWorkers[i]["worker"]['averageRating']) ?? 0)
                    .toString()),
            password: '',
            gender: accessWorkers[i]["worker"]['gender'],
            phone: 0,
            location: '',
            role: 'worker');
        employees.add(emp);
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
}
