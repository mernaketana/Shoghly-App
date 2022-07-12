import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/models/chat_card.dart';
import 'package:project/screens/single_chat_screen.dart';
import 'package:provider/provider.dart';

import '../providers/worker.dart';

class ChatCard extends StatelessWidget {
  final ChatCardModel message;
  const ChatCard({Key? key, required this.message}) : super(key: key);

  void chatScreen(String workerId, BuildContext context) async {
    final workerProfile =
        await Provider.of<Worker>(context, listen: false).getWorker(workerId);
    final currentWorker = workerProfile['employee'];
    Navigator.pushNamed(context, SingleChatScreen.routeName,
        arguments: currentWorker);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => chatScreen(message.workerId, context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        child: ListTile(
          visualDensity: VisualDensity.standard,
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueGrey,
            backgroundImage: CachedNetworkImageProvider(message.workerPicture),
          ),
          title: Text(
            '${message.firstName} ${message.lastName}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: FittedBox(
            child: Row(
              children: [
                const Icon(Icons.done),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  message.lastMessage,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          trailing: const Text('10:00'),
        ),
      ),
    );
  }
}
