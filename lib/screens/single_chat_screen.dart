import 'dart:async';

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
  static late StreamController<Message> _socketResponse;
  late IOWebSocketChannel channel;
  var _isInit = true;
  late List<Message> messages;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Chat>(context, listen: false)
          .getSpecificChat(widget.arguments['userId']);
      messages = Provider.of<Chat>(context, listen: false).chatmessages;
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  void connect({String? message}) async {
    _socketResponse = StreamController<Message>();
    socket = IO.io(
        'http://ec2-52-59-217-155.eu-central-1.compute.amazonaws.com:8080/',
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .disableAutoConnect()
            .setQuery({"token": widget.arguments["token"]})
            .build());
    socket.connect();
    socket.onConnect((data) {
      print('SUCCESSSSSSSSS');
      socket.on("message", (data) {
        print('onnnnnnnnnnnnnnnnnnnnn');
        print(data);
        final message = Message(
            messageId: data['messageId'],
            senderId: data["senderId"],
            recieverId: data['receiverId'],
            isOwner: data['isOwner'],
            text: data['text'],
            isRead: data['isRead'],
            createdAt: DateTime.parse(data['createdAt']));
        _socketResponse.sink.add(message);
      });
    });
    socket.onConnectError((data) => print(data));
    socket.onConnectTimeout((data) => print('TIMEOUUUUUUUUUUUUUUUUUUUUT'));
  }

  void sendMessage(String message, String recieverId) async {
    socket.emit("message");
    print('send message fun');
    await Provider.of<Chat>(context, listen: false)
        .sendMessage(recieverId, message);
    _controller.clear();
  }

  void _scrollDown() {
    try {
      Future.delayed(
          const Duration(milliseconds: 300),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
    } on Exception catch (_) {}
  }

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
                      backgroundImage: widget.arguments['userImage'] == ''
                          ? const AssetImage('assets/images/placeholder.png')
                              as ImageProvider
                          : CachedNetworkImageProvider(
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
              : StreamBuilder(
                  builder: (context, snapshot) {
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return const Center(
                    //       child: SpinKitSpinningLines(
                    //     color: Colors.red,
                    //   ));
                    // }
                    if (snapshot.hasData && snapshot.data != null) {
                      print('streaaaaaaaaaaaaaaaaaaaaaaam');
                      print((snapshot.data as Message).text);
                      messages.add(snapshot.data as Message);
                    }
                    _scrollDown();
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Expanded(
                            // height: MediaQuery.of(context).size.height - 150,
                            child: ListView.builder(
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
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: TextFormField(
                                          controller: _controller,
                                          focusNode: focusNode,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 5,
                                          minLines: 1,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "اكتب رسالة",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            prefixIcon: Icon(Icons.keyboard),
                                            contentPadding: EdgeInsets.all(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => sendMessage(
                                          _controller.text,
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
                    );
                  },
                  stream: _socketResponse.stream,
                )),
    );
  }
}
