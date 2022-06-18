import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/comment.dart';
// import '../models/employee.dart';
import 'auth.dart';

class Review with ChangeNotifier {
  late String authToken;
  late String _reviewId;
  // ignore: unused_field
  Comment _review =
      Comment(comment: '', userId: '', workerId: '', createdAt: DateTime.now());
  late String userId;
  final apiUrl = dotenv.env['API_URL']!;
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
    userId = auth.userId;
    // print('recieve token in user provider');
    // print(userId);
  }

  // ignore: prefer_final_fields
  List<Comment> _items = [];

  List<Comment> get items {
    return [..._items];
  }

  // Comment findById(String id) {
  //   return _items.firstWhere((e) => e. == id);
  // }

  Future<void> addReview(Comment review) async {
    final url = Uri.parse("${apiUrl}workers/${review.workerId}/reviews");
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "rating": review.rate,
          "description": review.comment,
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken"
        },
      );
      final responseData = json.decode(response.body);
      _reviewId = responseData['reviewId'];
      // print(responseData);
      if (responseData["error"] != null) {
        throw HttpException(responseData["message"]);
      }
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

  String get reviewId {
    return _reviewId;
  }

  Future<Comment> getReview(String workerId) async {
    final url = Uri.parse("${apiUrl}profile/workers/$workerId/reviews");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken"
        },
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      print(data);
      // ignore: unnecessary_null_comparison
      if (data == null) {
        return Comment(
            comment: '', userId: '', workerId: '', createdAt: DateTime.now());
      }
      Map<String, dynamic> reviewInfo = data["info"];
      _review = Comment(
          comment: reviewInfo['comment'],
          userId: reviewInfo['userId'],
          workerId: reviewInfo['workerId'],
          createdAt: reviewInfo['createdAt']);
      notifyListeners();
      return _review;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getAllReviews() async {
    final url = Uri.parse("${apiUrl}profile/review/$userId");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken"
        },
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      // print(data);
      // ignore: unnecessary_null_comparison
      if (data == null) {
        return;
      }
      Map<String, dynamic> reviewInfo = data["info"];
      _review = Comment(
          comment: reviewInfo['comment'],
          userId: reviewInfo['userId'],
          workerId: reviewInfo['workerId'],
          createdAt: reviewInfo['createdAt']);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteReview(Comment review) async {
    final url = Uri.parse("${apiUrl}profile/review/$reviewId");
    try {
      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      // print(data);
      // ignore: unnecessary_null_comparison
      if (data == null) {
        return;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
