import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter/cupertino.dart";
// import "package:shared_preferences/shared_preferences.dart";
// import "../helpers/http_exception.dart";

class Auth with ChangeNotifier {
  // String? _token; //tokens expire after an amount of time typically one hour
  // DateTime? _expiryDate;
  // String? _userId;
  // Timer? _authTimer;

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
    final url = Uri.parse(
        "https://c1fzfviv22.execute-api.us-east-1.amazonaws.com/dev/signup");
    print(fname);
    print(lname);
    print(gender);
    print(role);
    print(profession);
    print(phone);
    print(city);
    print(address);
    print(email);
    print(password);
    try {
      final response = await http.post(url,
          body: json.encode({
            "firstName": fname,
            "lastName": lname,
            "email": email,
            "password": password,
            "gender": gender,
            "role": role,
            "profession": profession,
            "phone": phone,
            "country": "Egypt",
            "city": city,
            "line": address
          }));
      final responseData = json.decode(response.body);
      print('do i come here');
      print(responseData);
      // if (responseData["error"] != null) {
      //   throw HttpException(responseData["error"]["message"]);
      // }
      // _token = responseData["idToken"];
      // _userId = responseData["localId"];
      // _expiryDate = DateTime.now()
      //     .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      // // _autoLogOut();
      // notifyListeners();
      // final prefs = await SharedPreferences.getInstance();
      // final userData = json.encode({
      //   "token": _token,
      //   "userId": _userId,
      //   "expiryDate": _expiryDate!.toIso8601String(),
      // });
      // prefs.setString("userData", userData);
      // print("=====================>");
      // print(prefs.getString("userData"));
    } catch (error) {
      //Firebase doesn"t return an error, it doesn"t have an error status
      rethrow;
    }
  }

  // Future<void> signUp(String fname, String lname, String gender, String role, String profession, String phone, String city, String address,
  //     String email, String password) async {
  //   return _authenticate(fname, lname, gender, role, profession, phone, city, address, email, password, "signup");
  // }
  Future<void> signin(String email, String password) async {
    final url = Uri.parse(
        "https://c1fzfviv22.execute-api.us-east-1.amazonaws.com/dev/signin");
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
          }));
      final responseData = json.decode(response.body);
      print(responseData);
      // if (responseData["error"] != null) {
      //   throw HttpException(responseData["error"]["message"]);
      // }
      // _token = responseData["idToken"];
      // _userId = responseData["localId"];
      // _expiryDate = DateTime.now()
      //     .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      // _autoLogOut();
      notifyListeners();
      // final prefs = await SharedPreferences.getInstance();
      // final userData = json.encode({
      //   "token": _token,
      //   "userId": _userId,
      //   "expiryDate": _expiryDate!.toIso8601String(),
      // });
      // prefs.setString("userData", userData);
      // // print("=====================>");
      // // print(prefs.getString("userData"));
    } catch (error) {
      //Firebase doesn"t return an error, it doesn"t have an error status
      rethrow;
    }
  }
  // Future<void> logIn(String email, String password) async {
  //   return _authenticate(email, password, "signInWithPassword");
  // }
  // Future<void> logIn(String fname, String lname, String gender, String role, String profession, String phone, String city, String address,
  //     String email, String password) async {
  //   return _authenticate(fname, lname, gender, role, profession, phone, city, address, email, password, "signin");
  // }

}
