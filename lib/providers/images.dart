import "dart:convert";
import "dart:io";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";

import "./auth.dart";

class Images with ChangeNotifier {
  late String authToken;
  String? _imageUrl;
  final apiUrl = dotenv.env["API_URL"]!;

  void recieveToken(Auth auth) {
    authToken = auth.token;
  }

  Future<String> addImage(String image) async {
    final url = Uri.parse("${apiUrl}upload");
    try {
      final request = http.MultipartRequest("POST", url);
      request.files.add(await http.MultipartFile.fromPath("photos", image));
      request.headers["Authorization"] = "Bearer $authToken";
      request.headers["Content-Type"] = "image/jpg";
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      final info = json.decode(responseData.body);
      print(info);
      final data = info["data"];
      print(data);
      _imageUrl = data[0]["url"];
      print(_imageUrl);
      notifyListeners();
      return imageUrl;
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
          "Authorization": "Bearer $authToken"
        },
      );
      final responseData = json.decode(response.body);
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
      return _imageUrl as String;
    }
    return "";
  }
}
