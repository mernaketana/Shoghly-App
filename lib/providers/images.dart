import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/comment.dart';
// import '../models/employee.dart';
import 'auth.dart';

class Images with ChangeNotifier {
  late String authToken;
  String? _imageUrl;
  final apiUrl = dotenv.env['API_URL']!;

  void recieveToken(Auth auth) {
    authToken = auth.token;
  }

  Future<void> addImage(String image) async {
    print(image);
    final url = Uri.parse("${apiUrl}upload");
    try {
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('photos', image));
      request.headers['Authorization'] = 'Bearer $authToken';
      request.headers['Content-Type'] = 'image/jpg';
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      final info = json.decode(responseData.body);
      print(info);
      final data = info["data"];
      print(data);
      _imageUrl = data[0]["url"];
      print(_imageUrl);
      notifyListeners();
      changeImage(imageUrl);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> changeImage(String imageUrl) async {
    final url = Uri.parse("${apiUrl}profile/changePicture");
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "picture": imageUrl,
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $authToken'
        },
      );
      final responseData = json.decode(response.body);
      print('here in changeimage');
      print(responseData);
      notifyListeners();
      if (responseData["error"] != null) {
        throw HttpException(responseData["message"]);
      }
    } catch (error) {
      rethrow;
    }
  }

  String get imageUrl {
    if (_imageUrl != null) {
      // print(_token);
      // print(_userId);
      // print(_expiryDate);
      // print('ok');
      return _imageUrl as String;
    }
    return '';
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
