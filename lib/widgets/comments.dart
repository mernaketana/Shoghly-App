import 'package:flutter/material.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../models/comment.dart';
import '../models/employee.dart';
import '../screens/worker_details_screen.dart';
import '../providers/review.dart';

class Comments extends StatefulWidget {
  final Employee currentUser;
  final Employee currentWorker;
  final List<Comment> userComments;
  const Comments({
    Key? key,
    required this.currentUser,
    required this.currentWorker,
    required this.userComments,
  }) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();
  double? _rate;

  Future<void> createReview(Comment comment) async {
    await Provider.of<Review>(context, listen: false).addReview(comment);
    Navigator.of(context).popAndPushNamed(WorkerDetailsScreen.routeName,
        arguments: {
          'currentWorker': widget.currentWorker,
          'currentUser': widget.currentUser
        });
  }

  Future<void> editReview(Comment comment) async {
    await Provider.of<Review>(context, listen: false).editReview(comment);
    Navigator.of(context).popAndPushNamed(WorkerDetailsScreen.routeName,
        arguments: {
          'currentWorker': widget.currentWorker,
          'currentUser': widget.currentUser
        });
  }

  void deleteComment(String reviewId) async {
    await Provider.of<Review>(context, listen: false).deleteReview(reviewId);
    Navigator.of(context).popAndPushNamed(WorkerDetailsScreen.routeName,
        arguments: {
          'currentWorker': widget.currentWorker,
          'currentUser': widget.currentUser
        });
  }

  var starList = <Widget>[];
  List<Widget> createStars(double rate) {
    starList.clear();
    for (var i = 0; i < rate; i++) {
      starList.add(
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: 17,
        ),
      );
    }
    return starList;
  }

  Future<dynamic> editReviewDialog(Comment review, BuildContext bigContext) {
    String editedReview = '';
    return showDialog(
        context: context,
        builder: (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Text('تعديل تعليقك'),
                content: TextFormField(
                  initialValue: review.comment,
                  key: const ValueKey('comment'),
                  onChanged: (e) {
                    editedReview = e;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showRate(context).whenComplete(() {
                          if (editedReview == '') {
                            showDialog(
                                context: bigContext,
                                builder: (context) => Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: AlertDialog(
                                        title: const Text(
                                            'قم بتعديل التعليق لتتمكن من تعديل التقييم'),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text(
                                                'حسنا',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ))
                                        ],
                                      ),
                                    ));
                          }
                          if (formKey.currentState!.validate()) {
                            if (_rate! > 0 && editedReview != '') {
                              var value = Comment(
                                reviewId: review.reviewId,
                                rate: _rate,
                                comment: editedReview,
                                userId: widget.currentUser.id,
                                workerId: widget.currentWorker.id,
                              );
                              editReview(value);
                            }
                          }
                        });
                      },
                      child: const Text(
                        'تم',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ))
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return widget.currentUser.role == "worker"
        ? commentsSection(widget.userComments)
        : widget.userComments
                .any((element) => element.user!.id == widget.currentUser.id)
            ? commentsSection(widget.userComments)
            : CommentBox(
                userImage: widget.currentUser.image == ''
                    ? 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'
                    : widget.currentUser.image,
                child: widget.userComments.isEmpty
                    ? const Center(
                        child: Text('لا يوجد تعليقات'),
                      )
                    : commentsSection(widget.userComments),
                labelText: widget.userComments.any(
                        (element) => element.user!.id == widget.currentUser.id)
                    ? 'لا يمكنك كتابة تعليق مرة اخرى'
                    : 'اكتب تعليق...',
                withBorder: false,
                sendButtonMethod: () {
                  showRate(context).whenComplete(() {
                    if (commentController.text == '') {
                      showDialog(
                          context: context,
                          builder: (context) => Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                  title: const Text(
                                      'اكتب تعليق لتتمكن من اضافة تقييم'),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text(
                                          'حسنا',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ))
                                  ],
                                ),
                              ));
                    }
                    if (formKey.currentState!.validate()) {
                      if (_rate! > 0 && commentController.text != '') {
                        var value = Comment(
                            rate: _rate,
                            comment: commentController.text,
                            userId: widget.currentUser.id,
                            workerId: widget.currentWorker.id,
                            createdAt: DateTime.now());
                        createReview(value);
                      }

                      commentController.clear();
                      FocusScope.of(context).unfocus();
                    }
                  });
                },
                formKey: formKey,
                commentController: commentController,
                sendWidget: const Icon(Icons.send),
              );
  }

  ListView commentsSection(List<Comment> commentsList) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final currentComment = commentsList[index];
        final commentTime = currentComment.createdAt;
        return Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListTile(
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: CircleAvatar(
                          maxRadius: 20,
                          backgroundImage: currentComment.user!.picture != ''
                              ? NetworkImage(currentComment.user!.picture)
                                  as ImageProvider<Object>
                              : const AssetImage(
                                  'assets/images/placeholder.png')),
                    ),
                    title: Text(
                        '${currentComment.user!.fname} ${currentComment.user!.lname}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${commentTime!.hour}:${commentTime.minute}  ${commentTime.year}-${commentTime.month}-${commentTime.day}',
                          style: const TextStyle(fontSize: 10),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: createStars(currentComment.rate!),
                          ),
                        ),
                        Text(
                          currentComment.comment,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                if (currentComment.user!.id == widget.currentUser.id)
                  Row(
                    children: [
                      IconButton(
                          alignment: Alignment.centerLeft,
                          onPressed: () =>
                              editReviewDialog(currentComment, context),
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.red,
                            size: 20,
                          )),
                      IconButton(
                          alignment: Alignment.centerRight,
                          onPressed: () =>
                              deleteComment(currentComment.reviewId!),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          )),
                    ],
                  ),
              ],
            ));
      },
      itemCount: widget.userComments.length,
    );
  }

  Future<dynamic> showRate(BuildContext context) {
    return showDialog(
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
                      child: const Text(
                        'تم',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ))
                ],
              ),
            ));
  }
}
