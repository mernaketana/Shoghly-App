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
    print('add project');
    print(workerProject.urls);
    print(workerProject.desc);
    try {
      final response = await http.post(
        url,
        body: json.encode(
            {"urls": workerProject.urls, "description": workerProject.desc}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final data = json.decode(response.body);
      print(data);
      print('hereeeeeeeeeeeeeeeeeeeeee');
      // ignore: unnecessary_null_comparison
      if (data == null) {
        return;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<WorkerProject>> getWorkerProjects(String workerId) async {
    print(authToken);
    print(workerId);
    final url = Uri.parse("${apiUrl}workers/$workerId/projects");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      // final employee = await getUser(userId);
      final data = json.decode(response.body) as Map<String, dynamic>;
      print(data);
      final accessProjects = data["data"] as List;
      List<WorkerProject> projects = [];
      for (var i = 0; i < accessProjects.length; i++) {
        final currentProject = WorkerProject(
          desc: accessProjects[i]["description"],
          urls: accessProjects[i]["pictures"],
          projectId: accessProjects[i]["id"],
        );
        if (currentProject.urls != null) {
          projects.add(currentProject);
        }
      }
      // ignore: unnecessary_null_comparison
      if (data == null) {
        return [];
      }
      notifyListeners();
      return projects;
    } catch (error) {
      rethrow;
    }
  }

  Future<WorkerProject> getWorkerProject(String projectId) async {
    final url = Uri.parse("${apiUrl}workers/projects/$projectId");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      // final employee = await getUser(userId);
      // I don't fetch the worker Id
      print('dataaaaaaaaaaaaaaaaaaaaaaaaaa');
      final data = json.decode(response.body) as Map<String, dynamic>;
      final accessProject = data["project"][0];
      print(data);
      final project = WorkerProject(
          desc: accessProject["description"],
          urls: accessProject["photos"],
          projectId: accessProject["projectId"],
          createdAt: DateTime.parse(accessProject["createdAt"]),
          updatedAt: DateTime.parse(accessProject["updatedAt"]));
      // ignore: unnecessary_null_comparison
      if (data == null) {
        return WorkerProject(desc: '', urls: []);
      }
      notifyListeners();
      return project;
    } catch (error) {
      rethrow;
    }
  }

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
