import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/models/chat_card.dart';
import 'package:project/screens/single_chat_screen.dart';
import 'package:provider/provider.dart';

import '../models/employee.dart';
import '../providers/worker.dart';

class ChatCard extends StatelessWidget {
  final ChatCardModel message;
  final Employee currentUser;
  const ChatCard({Key? key, required this.message, required this.currentUser})
      : super(key: key);

  void chatScreen(ChatCardModel message, BuildContext context) async {
    Navigator.pushNamed(context, SingleChatScreen.routeName, arguments: {
      "userId": message.userId,
      "userImage": message.userPicture,
      "userFirstName": message.firstName,
      "userLastName": message.lastName
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => chatScreen(message, context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueGrey,
            backgroundImage: CachedNetworkImageProvider(message.userPicture),
          ),
          title: Text(
            '${message.firstName} ${message.lastName}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.done,
                size: 15,
              ),
              const SizedBox(
                width: 3,
              ),
              SizedBox(
                width: 200,
                child: Text(
                  message.lastMessage,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          trailing: const Text('10:00'),
        ),
      ),
    );
  }
}
