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
  List<Message> messages = [];

  void recieveToken(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

  List<Message> get chatmessages {
    return messages.reversed.toList();
  }

  void addMessageToMessages(Message message) {
    messages.add(message);
    notifyListeners();
  }

  Future<void> sendMessage(String recieverId, String text) async {
    final url = Uri.parse("${apiUrl}messages");
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
      final List<ChatCardModel> chatmessages = [];
      final accessMessages = responseData["data"] as List;
      for (var i = 0; i < accessMessages.length; i++) {
        final accessSingleMessage = accessMessages[i] as Map<String, dynamic>;
        final currentMessage = ChatCardModel(
            firstName: accessSingleMessage["user"]["firstName"],
            lastMessage: accessSingleMessage["lastMessage"],
            lastMessageUserId: accessSingleMessage["lastUserId"],
            lastName: accessSingleMessage["user"]["lastName"],
            userId: accessSingleMessage["user"]["id"],
            userPicture: accessSingleMessage["user"]["picture"]);
        chatmessages.add(currentMessage);
      }
      if (responseData["error"] != null) {
        throw HttpException(responseData["message"]);
      }
      notifyListeners();
      return chatmessages;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Message>> getSpecificChat(String recieverId) async {
    messages.clear();
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
