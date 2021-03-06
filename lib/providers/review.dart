import "dart:convert";
import "dart:io";
import "package:flutter/foundation.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;

import "../models/comment.dart";
import "./auth.dart";

class Review with ChangeNotifier {
  late String authToken;
  late String _reviewId;
  Comment _review = Comment(
      comment: "",
      workerId: "",
      createdAt: DateTime.now(),
      rate: 0,
      reviewId: "",
      updatedAt: DateTime.now(),
      user: Commenter(id: "", fname: "", lname: "", picture: "", gender: ""));
  late String userId;
  final apiUrl = dotenv.env["API_URL"]!;
  List<Comment> _items = [];

  void recieveToken(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

  List<Comment> get items {
    return [..._items];
  }

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
      print(responseData);
      _reviewId = responseData["data"]["id"];
      if (responseData["error"] != null) {
        throw HttpException(responseData["message"]);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> editReview(Comment review) async {
    final url = Uri.parse("${apiUrl}workers/reviews/${review.reviewId}");
    try {
      final response = await http.put(
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
      print(responseData);
      if (responseData["error"] != null) {
        throw HttpException(responseData["message"]);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  String get reviewId {
    return _reviewId;
  }

  Future<List<Comment>> getReview(String workerId) async {
    final List<Comment> workerComments = [];
    final url = Uri.parse("${apiUrl}workers/$workerId/reviews");
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
        return [];
      }
      List listOfReviews = data["data"]["reviews"];
      for (var i = 0; i < listOfReviews.length; i++) {
        final currentComment = listOfReviews[i];
        _review = Comment(
            reviewId: currentComment["reviewId"],
            updatedAt: DateTime.parse(currentComment["updatedAt"]).toLocal(),
            user: Commenter(
                id: currentComment["client"]["id"],
                fname: currentComment["client"]["firstName"],
                lname: currentComment["client"]["lastName"],
                picture: currentComment["client"]["picture"],
                gender: currentComment["client"]["gender"]),
            comment: currentComment["description"],
            workerId: currentComment["workerId"],
            createdAt: DateTime.parse(currentComment["createdAt"]).toLocal(),
            rate: (currentComment["rating"] as int).toDouble());
        if (_review.user != null) {
          workerComments.add(_review);
        }
      }
      notifyListeners();
      return workerComments;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteReview(String reviewId) async {
    final url = Uri.parse("${apiUrl}workers/reviews/$reviewId");
    try {
      final response = await http.delete(
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
        return;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
