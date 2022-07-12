import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project/models/chat_card.dart';
import 'package:project/widgets/chat_card.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import '../helpers/http_exception.dart';
import '../models/message.dart';
import 'auth.dart';

class Chat with ChangeNotifier {
  late String authToken;
  late String userId;
  late IO.Socket socket;
  final apiUrl = dotenv.env['API_URL']!;

  void recieveToken(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

  void connect({String? message}) async {
    socket = IO.io(
        'http://ec2-52-59-217-155.eu-central-1.compute.amazonaws.com:8080/',
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .disableAutoConnect()
            .setQuery({"token": authToken})
            .build());
    socket.connect();
    socket.onConnect((data) => print('SUCCESSSSSSSSS'));
    socket.onConnectError((data) => print(data));
    socket.onConnectTimeout((data) => print('TIMEOUUUUUUUUUUUUUUUUUUUUT'));
    socket
        .onConnecting((data) => print('CONNECTINGGGGGGGGGGGGGGGGGGGGGGGGGGGG'));
    socket.emit("message", {"message": message});
  }

  Future<void> sendMessage(String recieverId, String text) async {
    final url = Uri.parse("${apiUrl}messages");
    connect(message: text);
    print('send message provider');
    print(recieverId);
    print(text);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "receiverId": recieverId,
          "text": text,
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

  Future<List<ChatCardModel>> getChats() async {
    final url = Uri.parse("${apiUrl}chats");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken"
        },
      );
      final responseData = json.decode(response.body);
      print(responseData);
      List<ChatCardModel> messages = [];
      final accessMessages = responseData["data"] as List;
      for (var i = 0; i < accessMessages.length; i++) {
        final accessSingleMessage = accessMessages[i] as Map<String, dynamic>;
        final currentMessage = ChatCardModel(
            firstName: accessSingleMessage["user"]["firstName"],
            lastMessage: accessSingleMessage["lastMessage"],
            lastName: accessSingleMessage["user"]["lastName"],
            userId: accessSingleMessage["lastUserId"],
            workerId: accessSingleMessage["user"]["id"],
            workerPicture: accessSingleMessage["user"]["picture"]);
        messages.add(currentMessage);
      }
      if (responseData["error"] != null) {
        throw HttpException(responseData["message"]);
      }
      notifyListeners();
      return messages;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Message>> getSpecificChat(String recieverId) async {
    final url = Uri.parse("${apiUrl}users/$recieverId/messages");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken"
        },
      );
      final responseData = json.decode(response.body);
      print(responseData);
      List<Message> messages = [];
      final accessMessages = responseData["data"] as List;
      for (var i = 0; i < accessMessages.length; i++) {
        final accessSingleMessage = accessMessages[i] as Map<String, dynamic>;
        final currentMessage = Message(
            messageId: accessSingleMessage["messageId"],
            senderId: accessSingleMessage["senderId"],
            recieverId: accessSingleMessage["receiverId"],
            isOwner: accessSingleMessage["isOwner"],
            text: accessSingleMessage["text"],
            isRead: accessSingleMessage['isRead'],
            createdAt: DateTime.parse(accessSingleMessage['createdAt']),
            updatedAt: DateTime.parse(accessSingleMessage["updatedAt"]));
        messages.add(currentMessage);
      }
      if (responseData["error"] != null) {
        throw HttpException(responseData["message"]);
      }
      notifyListeners();
      return messages;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> acknowledgeMessage(String messageId) async {
    final url = Uri.parse("${apiUrl}messages/$messageId/acknowledge-read");
    try {
      final response = await http.post(
        url,
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
}
