import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/models/employee.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:project/widgets/message_card.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/message.dart';
import '../providers/chat.dart';

class SingleChatScreen extends StatefulWidget {
  static const routeName = '/single-chat-screen';
  final Map<String, dynamic> arguments;
  const SingleChatScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  _SingleChatScreenState createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  // List<MessageModel> messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  late IO.Socket socket;
  late IOWebSocketChannel channel;
  var _isInit = true;
  late List<Message> messages;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<Chat>(context).connect();

      setState(() {
        _isLoading = true;
      });
      messages = await Provider.of<Chat>(context, listen: false)
          .getSpecificChat(widget.arguments['userId']);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  void sendMessage(String message, String recieverId) async {
    _controller.clear();
    print('send message fun');
    await Provider.of<Chat>(context, listen: false)
        .sendMessage(recieverId, message);
    setState(() {
      _isInit = true;
    });
  }

  // void setMessage(String type, String message) {
  //   MessageModel messageModel = MessageModel(
  //       type: type,
  //       message: message,
  //       time: DateTime.now().toString().substring(10, 16));
  //   print(messages);

  //   setState(() {
  //     messages.add(messageModel);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            leadingWidth: 70,
            titleSpacing: 0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_back,
                    size: 24,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(
                      widget.arguments['userImage'],
                    ),
                    backgroundColor: Colors.blueGrey,
                  ),
                ],
              ),
            ),
            title: Container(
              margin: const EdgeInsets.all(6),
              child: Text(
                '${widget.arguments['userFirstName']} ${widget.arguments['userLastName']}',
                style: const TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        body: _isLoading
            ? const SpinKitSpinningLines(color: Colors.red)
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Expanded(
                      // height: MediaQuery.of(context).size.height - 150,
                      child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          // if (index == 5) {
                          //   return Container(
                          //     height: 70,
                          //   );
                          // } else {
                          return MessageCard(
                            message: messages[index],
                          );
                          // }
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 70,
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  margin: const EdgeInsets.only(
                                      left: 2, right: 2, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: TextFormField(
                                    controller: _controller,
                                    focusNode: focusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "اكتب رسالة",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(Icons.keyboard),
                                      contentPadding: EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => sendMessage(_controller.text,
                                    widget.arguments['userId']),
                                icon: const Icon(Icons.send),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
