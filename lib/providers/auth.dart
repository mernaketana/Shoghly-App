import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter/foundation.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

import "../helpers/http_exception.dart";

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  String? imageUrl;
  String? identifier;
  final apiUrl = dotenv.env["API_URL"]!;
  String? firebasetoken;

  Future<void> signup(
      String fname,
      String lname,
      String gender,
      String role,
      String profession,
      String phone,
      String city,
      String address,
      String email,
      String password) async {
    final url = Uri.parse("${apiUrl}users");
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "firstName": fname,
          "lastName": lname,
          "email": email,
          "password": password,
          "gender": gender,
          "role": role,
          "profession": profession,
          "phone": phone,
          "picture": imageUrl ?? "",
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
      _userId = responseData["id"];
      notifyListeners();
      signin(email, password);
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
      });
      prefs.setString("userData", userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> verifyEmail(String email, String code) async {
    final url = Uri.parse("${apiUrl}settings/verify-email");
    try {
      final response = await http.post(
        url,
        body: json.encode({"email": email, "code": code}),
        headers: {"Content-Type": "application/json"},
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

  Future<void> signin(String email, String password) async {
    final url = Uri.parse("${apiUrl}signin");
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
        }),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData["error"] != null) {
        throw HttpException(responseData["message"]);
      }
      _token = responseData["accessToken"];
      _userId = responseData["userId"];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
      });
      prefs.setString("userData", userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    final url = Uri.parse("${apiUrl}users");
    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_token"
        },
      );
      final responseData = json.decode(response.body);
      print(responseData);
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey("userData")) {
        return;
      } else {
        prefs.remove("userData");
      }
      if (responseData["error"] != null) {
        throw HttpException(responseData["message"]);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<String> forgotPassword(String email) async {
    final url = Uri.parse("${apiUrl}settings/forgot-password");
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "email": email,
        }),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData["error"] != null) {
        return "لا يوجد مستخدم بهذا الاسم";
      }
      notifyListeners();
      return "تم بعث لينك لحسابك الشخصي";
    } catch (error) {
      rethrow;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final url = Uri.parse("${apiUrl}settings/change-password");
    try {
      final response = await http.post(
        url,
        body: json
            .encode({"oldPassword": oldPassword, "newPassword": newPassword}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_token"
        },
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData["error"] != null) {
        throw HttpException(responseData["message"]);
      }
      _userId = responseData["id"];
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    } else {
      final extractedUserData =
          json.decode(prefs.getString("userData") as String)
              as Map<String, dynamic>;
      if (extractedUserData["token"] == null) {
        return false;
      }
      _token = extractedUserData["token"] as String;
      _userId = extractedUserData["userId"] as String;
      notifyListeners();
    }
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  bool get isAuth {
    return token != "";
  }

  String get token {
    if (_token != null) {
      return _token as String;
    }
    return "";
  }

  String get userId {
    return _userId == null ? "" : _userId as String;
  }
}
