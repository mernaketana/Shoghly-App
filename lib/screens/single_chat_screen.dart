import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectycube_sdk/connectycube_pushnotifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:native_notify/native_notify.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:project/widgets/message_card.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// ignore: library_prefixes
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
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
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
//     FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

// // FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

// Future<void> onBackgroundMessage(RemoteMessage message) {
//   print('[onBackgroundMessage] message: $message');
//   // showNotification(message);
//   return Future.value();
// }

//     // request permissions for showing notification in iOS
//     firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);

//     // add listener for foreground push notifications
//     FirebaseMessaging.onMessage.listen((remoteMessage) {
//       print('[onMessage] message: $remoteMessage');
//       // showNotification(remoteMessage);
//     });

    // set listener for push notifications, which will be received when app in background or killed
    // FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    // final fbm = FirebaseMessaging.instance;
    // fbm.requestPermission();
    // FirebaseMessaging.onMessage.listen((message) {
    //   print(message);
    //   return;
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print(message);
    //   return;
    // });
    // fbm.getToken() Sending autonated push notifications
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
            createdAt: DateTime.parse(data['createdAt']).toLocal());
        _socketResponse.sink.add(message);
        if (!message.isOwner) {
          NativeNotify.sendIndieNotification(
              1119,
              'wLzxM3KpqXUF1xxgw5Lb7r',
              message.recieverId,
              '${widget.arguments['userFirstName']} ${widget.arguments['userLastName']}',
              message.text,
              null,
              null);
        }
        // yourAppID, yourAppToken, 'your_sub_id', 'your_title', 'your_body' is required
        // put null in any other parameter you do NOT want to use
        // bool isProduction = const bool.fromEnvironment('dart.vm.product');
        // CreateEventParams params = CreateEventParams();
        // params.parameters = {
        //   'message': message.text, // 'message' field is required
        // };
        // params.notificationType = NotificationType.PUSH;
        // params.environment = isProduction
        //     ? CubeEnvironment.PRODUCTION
        //     : CubeEnvironment.DEVELOPMENT;
        // params.usersTagsAll = [message.senderId, message.recieverId];
        // // params.usersIds = [88709, 88708];
        // params.eventType = 'message';
        // createEvent(params.getEventForRequest())
        //     .then((cubeEvent) {})
        //     .catchError((error) {});
      });
    });
    socket.onConnectError((data) => print(data));
    socket.onConnectTimeout((data) => print('TIMEOUUUUUUUUUUUUUUUUUUUUT'));
  }

  void sendMessage(String message, String recieverId) async {
    if (message.isEmpty) {
      return;
    }
    socket.emit("message");
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
              ? SpinKitSpinningLines(
                  color: Theme.of(context).colorScheme.primary)
              : StreamBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      messages.add(snapshot.data as Message);
                    }
                    _scrollDown();
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  message: messages[index],
                                );
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
                                      icon: Icon(
                                        Icons.send,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
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
