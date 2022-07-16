import "dart:async";
import "dart:convert";
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import "package:flutter/cupertino.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../helpers/http_exception.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:native_notify/native_notify.dart';

class Auth with ChangeNotifier {
  String? _token; //tokens expire after an amount of time typically one hour
  // DateTime? _expiryDate;
  String? _userId;
  String? imageUrl;
  String? identifier;
  // Timer? _authTimer;
  final apiUrl = dotenv.env['API_URL']!;
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
          "picture": imageUrl ?? '',
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
      NativeNotify.registerIndieID(_userId);
      notifyListeners();
      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      // if (Platform.isAndroid) {
      //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      //   print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
      //   identifier = androidInfo.id.toString();
      //   firebasetoken = await firebaseMessaging.getToken();
      // } else if (Platform.isIOS) {
      //   IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      //   print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
      //   identifier = iosInfo.identifierForVendor; //UUID for iOS
      //   firebasetoken = await firebaseMessaging.getToken();
      // }
      // if (firebasetoken != null) {
      //   print(firebasetoken);
      //   print(identifier);
      //   subscribe(firebasetoken!, identifier!);
      // }
      // firebaseMessaging.onTokenRefresh.listen((newToken) {
      //   subscribe(newToken, identifier!);
      // });
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

  // subscribe(String token, String deviceId) async {
  //   print('[subscribe] token: $token');

  //   bool isProduction = const bool.fromEnvironment('dart.vm.product');

  //   CreateSubscriptionParameters parameters = CreateSubscriptionParameters();
  //   parameters.environment =
  //       isProduction ? CubeEnvironment.PRODUCTION : CubeEnvironment.DEVELOPMENT;

  //   if (Platform.isAndroid) {
  //     parameters.channel = NotificationsChannels.GCM;
  //     parameters.platform = CubePlatform.ANDROID;
  //     parameters.bundleIdentifier = "com.connectycube.flutter.chat_sample";
  //   } else if (Platform.isIOS) {
  //     parameters.channel = NotificationsChannels.APNS;
  //     parameters.platform = CubePlatform.IOS;
  //     parameters.bundleIdentifier = Platform.isIOS
  //         ? "com.connectycube.flutter.chatSample.app"
  //         : "com.connectycube.flutter.chatSample.macOS";
  //   }

  //   parameters.udid = deviceId;
  //   parameters.pushToken = token;

  //   createSubscription(parameters.getRequestParameters())
  //       .then((cubeSubscription) {
  //     print('doneeeeeeeeeeeeeeeeeeeeeeee');
  //   }).catchError((error) {
  //     print('errooooooooooooooooooooooooooooooooooor');
  //     print(error);
  //   });
  // }

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
      // _expiryDate = DateTime.now()
      //     .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      // _autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        // "expiryDate": _expiryDate!.toIso8601String(),
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
          "Authorization": 'Bearer $_token'
        },
      );
      final responseData = json.decode(response.body);
      print(responseData);
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userData')) {
        return;
      } else {
        prefs.remove('userData');
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
          "Authorization": 'Bearer $_token'
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
    if (!prefs.containsKey('userData')) {
      return false;
    } else {
      final extractedUserData =
          json.decode(prefs.getString('userData') as String)
              as Map<String, dynamic>;
      // final expiryDate =
      //     DateTime.parse(extractedUserData['expiryDate'] as String);
      if (extractedUserData['token'] == null) {
        return false;
      }
      _token = extractedUserData['token'] as String;
      _userId = extractedUserData['userId'] as String;
      // _expiryDate = expiryDate;
      notifyListeners();
    }
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    // if (_authTimer != null) {
    //   _authTimer!.cancel();
    //   _authTimer = null;
    // }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_token != null) {
      return _token as String;
    }
    return '';
  }

  String get userId {
    return _userId == null ? '' : _userId as String;
  }
}
