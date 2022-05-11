import 'dart:io';

import 'package:flutter/material.dart';
import 'package:comment_box/comment/comment.dart';
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
        if (formKey.currentState!.validate()) {
          // ignore: avoid_print
          print(commentController.text);
          setState(() {
            var value = Comment(
                comment: commentController.text,
                userId: widget.userId,
                workerId: widget.workerId);
            widget.items.add(value);
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
