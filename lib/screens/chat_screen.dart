import 'package:flutter/material.dart';

import '../widgets/chat_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('المحادثات')),
      ),
      body: ListView.builder(
          itemCount: 5,
          // widget.chatmodels.length,
          itemBuilder: (contex, index) => const ChatCard()
          // CustomCard(
          //   chatModel: widget.chatmodels[index],
          //   sourchat: widget.sourchat,
          // ),
          ),
    );
  }
}
