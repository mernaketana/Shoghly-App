import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/comment.dart';
// import '../models/employee.dart';
import 'auth.dart';

class Images with ChangeNotifier {
  late String authToken;
  // late String _reviewId;
  // // ignore: unused_field
  // Comment _review =
  //     Comment(comment: '', userId: '', workerId: '', createdAt: DateTime.now());
  // late String userId;
  // Employee _user = Employee(
  //   id: '',
  //   address: '',
  //   fname: '',
  //   lname: '',
  //   email: '',
  //   password: '',
  //   phone: 0,
  //   location: '',
  //   role: '',
  //   categordId: '',
  // );

// for main to get the token and the user id from auth
  void recieveToken(Auth auth) {
    authToken = auth.token;
    // print('recieve token in user provider');
    // print(userId);
  }

  // ignore: prefer_final_fields
  // List<Comment> _items = [];

  // List<Comment> get items {
  //   return [..._items];
  // }

  // Comment findById(String id) {
  //   return _items.firstWhere((e) => e. == id);
  // }

  Future<void> addImage(String image) async {
    Map<String, String> headers = {"bearerAuth": authToken};
    print(image);
    final url = Uri.parse(
        "https://cjyzhu7lw2.execute-api.eu-central-1.amazonaws.com/dev/upload");
    try {
      final request = http.MultipartRequest('POST', url);
      request.files.add(http.MultipartFile.fromString('file', image));
      request.headers['authorization'] = authToken;
      request.headers.addAll(headers);
      final response = await request.send();
      // final response = await http.post(
      //   url,
      //   body: image,
      //   headers: {"Content-Type": "multipart/form-data"},
      // );
      // final responseData = json.decode(response.body);
      final responseData = await http.Response.fromStream(response);
      print(responseData.body);
      // if (response["error"] != null) {
      //   throw HttpException(response["message"]);
      // }
      // _token = responseData["id"];
      // _userId = responseData["id"];
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
      // print("=====================>");
      // print(prefs.getString("userData"));
    } catch (error) {
      //Firebase doesn"t return an error, it doesn"t have an error status
      rethrow;
      // print(error);
    }
  }

  // String get reviewId {
  //   return _reviewId;
  // }

  // Future<void> getReview() async {
  //   final url = Uri.parse(
  //       "https://cjyzhu7lw2.execute-api.eu-central-1.amazonaws.com/dev/profile/review/$reviewId");
  //   try {
  //     final response = await http.get(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //     );
  //     final data = json.decode(response.body) as Map<String, dynamic>;
  //     // print(data);
  //     // ignore: unnecessary_null_comparison
  //     if (data == null) {
  //       return;
  //     }
  //     Map<String, dynamic> reviewInfo = data["info"];
  //     _review = Comment(
  //         comment: reviewInfo['comment'],
  //         userId: reviewInfo['userId'],
  //         workerId: reviewInfo['workerId'],
  //         createdAt: reviewInfo['createdAt']);
  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  // Future<void> getAllReviews() async {
  //   final url = Uri.parse(
  //       "https://cjyzhu7lw2.execute-api.eu-central-1.amazonaws.com/dev/profile/review/$userId");
  //   try {
  //     final response = await http.get(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //     );
  //     final data = json.decode(response.body) as Map<String, dynamic>;
  //     // print(data);
  //     // ignore: unnecessary_null_comparison
  //     if (data == null) {
  //       return;
  //     }
  //     Map<String, dynamic> reviewInfo = data["info"];
  //     _review = Comment(
  //         comment: reviewInfo['comment'],
  //         userId: reviewInfo['userId'],
  //         workerId: reviewInfo['workerId'],
  //         createdAt: reviewInfo['createdAt']);
  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  // Future<void> deleteReview(Comment review) async {
  //   final url = Uri.parse(
  //       "https://cjyzhu7lw2.execute-api.eu-central-1.amazonaws.com/dev/profile/review/$reviewId");
  //   try {
  //     final response = await http.delete(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //     );
  //     final data = json.decode(response.body) as Map<String, dynamic>;
  //     // print(data);
  //     // ignore: unnecessary_null_comparison
  //     if (data == null) {
  //       return;
  //     }
  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
}
