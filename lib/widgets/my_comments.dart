import 'package:flutter/material.dart';
import 'dart:math';

import '../models/comment.dart';
import '../dummy_data.dart';

class MyComments extends StatefulWidget {
  final List<Comment> comments;

  // ignore: use_key_in_widget_constructors
  const MyComments(this.comments);

  @override
  State<MyComments> createState() => _MyCommentsState();
}

class _MyCommentsState extends State<MyComments> {
  var _expand = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expand ? min(widget.comments.length + 170, 200) : 68,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            ListTile(
              title: const Text('اظهر التعليقات'),
              trailing: IconButton(
                icon: Icon(_expand ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expand = !_expand;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _expand ? min(widget.comments.length + 100, 180) : 0,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(33, 255, 109, 64),
              ),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  // var user = DUMMY_EMP.firstWhere(
                  //   (e) => e.id == widget.comments[index].userId,
                  // );
                  return Padding(
                    padding: const EdgeInsets.all(6),
                    child: widget.comments == []
                        ? const Center(
                            child: Text('لا يوجد تعليقات'),
                          )
                        : SizedBox(
                            height: 45,
                            child: ListTile(
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: CircleAvatar(
                                    // maxRadius: 20,
                                    // backgroundImage: user.image != null
                                    //     ? NetworkImage(user.image as String)
                                    //     : const AssetImage(
                                    //             'assets/images/placeholder.png')
                                    //         as ImageProvider
                                    ),
                              ),
                              // title: Text('${user.fname} ${user.lname}'),
                              subtitle: Text(widget.comments[index].comment),
                            ),
                          ),
                  );
                },
                itemCount: widget.comments.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
