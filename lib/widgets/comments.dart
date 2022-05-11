import 'dart:io';

import 'package:flutter/material.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project/models/comment.dart';
import '../dummy_data.dart';

class Comments extends StatefulWidget {
  final List<Comment> items;
  final String userId;
  final String workerId;
  const Comments({
    Key? key,
    required this.items,
    required this.userId,
    required this.workerId,
  }) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();
  double? _rate;
  @override
  Widget build(BuildContext context) {
    return CommentBox(
      userImage:
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
      child: ListView.builder(
        itemBuilder: (context, index) {
          var user = DUMMY_EMP.firstWhere((e) =>
              e.id ==
              widget.items
                  .where((e) => e.workerId == widget.workerId)
                  .toList()[index]
                  .userId);
          return Padding(
              padding: const EdgeInsets.all(6),
              child: ListTile(
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: CircleAvatar(
                      maxRadius: 20,
                      backgroundImage: user.image != null
                          ? user.image!.startsWith('/data')
                              ? FileImage(File(user.image as String))
                              : NetworkImage(user.image as String)
                                  as ImageProvider<Object>
                          : const AssetImage('assets/images/placeholder.png')),
                ),
                title: Text('${user.fname} ${user.lname}'),
                subtitle: Text(widget.items
                    .where((e) => e.workerId == widget.workerId)
                    .toList()[index]
                    .comment),
                trailing: SizedBox(
                  width: 50,
                  child: Row(children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('$_rate')
                  ]),
                ),
              ));
        },
        itemCount: widget.items
            .where((e) => e.workerId == widget.workerId)
            .toList()
            .length,
      ),
      labelText: 'اكتب تعليق...',
      withBorder: false,
      sendButtonMethod: () {
        // ignore: avoid_print
        // print(commentController.text);
        showDialog(
            context: context,
            builder: (context) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    title: const Text('ما هو تقييمك؟'),
                    content: FittedBox(
                      child: RatingBar.builder(
                        itemBuilder: (context, index) =>
                            const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rate) {
                          // ignore: avoid_print
                          print(rate);
                          setState(() {
                            _rate = rate;
                          });
                        },
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 25,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('تم'))
                    ],
                  ),
                ));
        // rate is faultyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
        if (formKey.currentState!.validate()) {
          if (_rate! > 0) {
            setState(() {
              var value = Comment(
                  rate: _rate,
                  comment: commentController.text,
                  userId: widget.userId,
                  workerId: widget.workerId);
              widget.items.add(value);
            });
          }
          setState(() {
            _rate = 0.0;
          });
          commentController.clear();
          FocusScope.of(context).unfocus();
        }
        // ignore: avoid_print
        // print('invalid');
      },
      formKey: formKey,
      commentController: commentController,
      sendWidget: const Icon(Icons.send),
    );
  }
}