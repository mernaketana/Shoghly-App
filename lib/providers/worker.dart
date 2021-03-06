import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter/cupertino.dart";
import "package:project/models/employee.dart";
import "../models/comment.dart";
import "../providers/auth.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

class Worker with ChangeNotifier {
  late String authToken;
  late String userId;
  // ignore: prefer_final_fields
  List<Employee> _employees = [];
  final apiUrl = dotenv.env["API_URL"]!;

  void recieveToken(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

  Future<void> getWorkers(String city, String profession) async {
    employees.clear();
    final url = Uri.parse("${apiUrl}workers");
    Map<String, String> queryParams = {"city": city, "profession": profession};
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
      final employeesData = data["data"];
      final employeesList = employeesData["workers"];
      final totalNumberofEmps = employeesData["count"];
      if (totalNumberofEmps > 0) {
        for (var i = 0; i < totalNumberofEmps; i++) {
          final currentEmp = Employee(
              id: employeesList[i]["id"],
              address: employeesList[i]["line"],
              fname: employeesList[i]["firstName"],
              lname: employeesList[i]["lastName"],
              email: "",
              password: "",
              avgRate: (employeesList[i]["averageRating"] ?? 0).toDouble(),
              gender: employeesList[i]["gender"],
              phone: int.parse(employeesList[i]["phone"]),
              location: employeesList[i]["city"],
              role: employeesList[i]["role"],
              image: employeesList[i]["picture"],
              categordId: employeesList[i]["profession"],
              reviews: employeesList[i]["reviews"]);
          if (!_employees.any(
            (element) => element.id == currentEmp.id,
          )) {
            _employees.add(currentEmp);
          }
        }
      }
      notifyListeners();
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
      final employeeData = data["data"];
      final employee = Employee(
          id: employeeData["id"],
          address: employeeData["line"],
          fname: employeeData["firstName"],
          lname: employeeData["lastName"],
          email: "",
          password: "",
          gender: employeeData["gender"],
          phone: int.parse(employeeData["phone"]),
          location: employeeData["city"],
          role: employeeData["role"],
          image: employeeData["picture"],
          categordId: employeeData["profession"]);
      List userReviews = employeeData["reviews"] ?? [];
      final workerComments = <Comment>[];
      for (var i = 0; i < userReviews.length; i++) {
        final currentComment = userReviews[i];
        final review = Comment(
            reviewId: currentComment["reviewId"],
            updatedAt: DateTime.parse(currentComment["updatedAt"]).toLocal(),
            user: currentComment["client"] == null
                ? Commenter(
                    id: "", fname: "", lname: "", picture: "", gender: "")
                : Commenter(
                    id: currentComment["client"]["id"],
                    fname: currentComment["client"]["firstName"],
                    lname: currentComment["client"]["lastName"],
                    picture: currentComment["client"]["picture"] ??
                        "assets/images/placeholder.png",
                    gender: currentComment["client"]["gender"]),
            comment: currentComment["description"],
            workerId: workerId,
            createdAt: DateTime.parse(currentComment["createdAt"]).toLocal(),
            rate: (currentComment["rating"] as int).toDouble());
        if (review.user!.id != "") {
          workerComments.add(review);
        }
      }
      final output = {"employee": employee, "workerComments": workerComments};
      notifyListeners();
      return output;
    } catch (error) {
      rethrow;
    }
  }

  List<Employee> get employees {
    return _employees;
  }
}
