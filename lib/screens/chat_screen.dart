import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/models/chat_card.dart';
import 'package:provider/provider.dart';

import '../providers/chat.dart';
import '../providers/user.dart';
import '../widgets/chat_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<ChatCardModel> messages = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final userId = Provider.of<User>(context).userId;
      final allMessages = await Provider.of<Chat>(context).getChats();
      for (var element in allMessages) {
        if (element.userId == userId) {
          messages.add(element);
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('المحادثات')),
      ),
      body: _isLoading
          ? const SpinKitSpinningLines(color: Colors.red)
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (contex, index) =>
                  ChatCard(message: messages[index])),
    );
  }
}
