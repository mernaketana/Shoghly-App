import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter/foundation.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

import "../models/worker_project.dart";
import "./auth.dart";

class Project with ChangeNotifier {
  late String authToken;
  late String userId;
  final apiUrl = dotenv.env["API_URL"]!;

  void recieveToken(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

  Future<void> addProject(WorkerProject workerProject) async {
    final url = Uri.parse("${apiUrl}workers/projects");
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
    final url = Uri.parse("${apiUrl}workers/$workerId/projects");
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
        return WorkerProject(desc: "", urls: []);
      }
      notifyListeners();
      return project;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> editProject(WorkerProject project) async {
    final url = Uri.parse("${apiUrl}workers/projects/${project.projectId}");
    try {
      final response = await http.put(
        url,
        body: json.encode({"urls": project.urls, "description": project.desc}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData["error"] != null) {
        return;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProject(String projectId) async {
    final url = Uri.parse("${apiUrl}workers/projects/$projectId");
    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken"
        },
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData["error"] != null) {
        return;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
