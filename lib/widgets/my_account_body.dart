import 'package:flutter/material.dart';
import 'package:project/models/employee.dart';
import 'package:project/screens/detailed_image_screen.dart';
import 'package:project/screens/gallery_screen.dart';
import 'package:project/screens/settings_screen.dart';
import 'dart:math';
import 'dart:io';

import '../models/comment.dart';
import '../dummy_data.dart';
import './images_gallery_widget.dart';

class MyAccountBody extends StatefulWidget {
  final List<Comment> comments;
  final Employee currentUser;
  const MyAccountBody(
      {Key? key, required this.comments, required this.currentUser})
      : super(key: key);

  @override
  State<MyAccountBody> createState() => _MyAccountBodyState();
}

class _MyAccountBodyState extends State<MyAccountBody> {
  var _expandComment = false;
  var _expandInfo = false;
  var _expandImg = false;
  // String age(DateTime bdate) {
  //   var myAge = DateTime.now().difference(bdate).toString();
  //   return myAge;
  // }
  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.currentUser.bDate);
    // print(widget.currentUser.image);
    // print(DUMMY_IMAGES.firstWhere((e) => e.userId == widget.currentUser.id).url
    //     as List<String>);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 380,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: widget.currentUser.image != ''
              ? InkWell(
                  onTap: () => Navigator.of(context).pushNamed(
                      DetailedImageScreen.routeName,
                      arguments: widget.currentUser.image),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: widget.currentUser.image!.startsWith('/data')
                          ? Image.file(
                              File(
                                widget.currentUser.image as String,
                              ),
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              widget.currentUser.image as String,
                              fit: BoxFit.cover,
                            )),
                )
              : Image.asset('assets/images/placeholder.png'),
        ),
        // CircleAvatar(
        //   backgroundImage: widget.currentUser.image != null
        //       ? NetworkImage(widget.currentUser.image as String)
        //       : const AssetImage('assets/images/placeholder.png')
        //           as ImageProvider,
        //   minRadius: 100,
        // ),
        myWidget(
          _expandInfo,
          'معلوماتي',
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text('الاسم: '),
                      Text(
                          '${widget.currentUser.fname} ${widget.currentUser.lname}')
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  if (widget.currentUser.role == 'worker')
                    Row(
                      children: <Widget>[
                        const Text('الحرفة: '),
                        Text(widget.currentUser.categordId as String)
                      ],
                    ),
                  if (widget.currentUser.role == 'worker')
                    const SizedBox(
                      height: 6,
                    ),
                  if (widget.currentUser.bDate != null)
                    Row(
                      children: <Widget>[
                        const Text('السن: '),
                        Text(calculateAge(widget.currentUser.bDate as DateTime)
                            .toString())
                      ],
                    ),
                  if (widget.currentUser.bDate != null)
                    const SizedBox(
                      height: 6,
                    ),
                  Row(
                    children: <Widget>[
                      const Text('المحافظة: '),
                      Text(widget.currentUser.location)
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextButton.icon(
                            onPressed: () => Navigator.of(context).pushNamed(
                                    SettingsScreen.routeName,
                                    arguments: {
                                      'currentUser': widget.currentUser,
                                      'editPass': false
                                    }),
                            icon: const Icon(
                              Icons.edit,
                              size: 20,
                            ),
                            label: const Text(
                              'تعديل',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          () {
            setState(() {
              _expandInfo = !_expandInfo;
            });
          },
        ),
        // const SizedBox(
        //   height: 10,
        // ),
        if (widget.currentUser.role == 'worker')
          myWidget(
            _expandComment,
            'اظهر التعليقات',
            ListView.builder(
              itemBuilder: (context, index) {
                var user = DUMMY_EMP.firstWhere(
                  (e) => e.id == widget.comments[index].userId,
                );
                return Padding(
                  padding: const EdgeInsets.all(6),
                  child: SizedBox(
                    height: 50,
                    child: ListTile(
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: CircleAvatar(
                            maxRadius: 20,
                            backgroundImage: user.image != null
                                ? user.image!.startsWith('/data')
                                    ? FileImage(File(user.image as String))
                                    : NetworkImage(user.image as String)
                                        as ImageProvider<Object>
                                : const AssetImage(
                                    'assets/images/placeholder.png')),
                      ),
                      title: Text('${user.fname} ${user.lname}'),
                      subtitle: Text(widget.comments[index].comment),
                    ),
                  ),
                );
              },
              itemCount: widget.comments.length,
            ),
            () {
              setState(() {
                _expandComment = !_expandComment;
              });
            },
          ),
        if (widget.currentUser.role == 'worker')
          myWidget(
              _expandImg,
              'معرضي',
              SingleChildScrollView(
                child: !DUMMY_IMAGES
                        .any((e) => e.userId == widget.currentUser.id)
                    ? Container()
                    : Column(
                        children: [
                          ImagesGallery(
                              images: DUMMY_IMAGES
                                  .firstWhere(
                                      (e) => e.userId == widget.currentUser.id)
                                  .url as List<String>),
                          Row(
                            children: [
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextButton.icon(
                                    onPressed: () => Navigator.of(context)
                                        .pushNamed(GalleryScreen.routeName,
                                            arguments: widget.currentUser),
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                    ),
                                    label: const Text(
                                      'تعديل',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
              ), () {
            setState(() {
              _expandImg = !_expandImg;
            });
          }),
      ],
    );
  }

  AnimatedContainer myWidget(
      bool expand, String title, Widget child, void Function()? onPressed) {
    return AnimatedContainer(
      width: 380,
      duration: const Duration(milliseconds: 300),
      height: expand ? min(widget.comments.length + 245, 300) : 68,
      child: Card(
        // color: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            ListTile(
              tileColor: Colors.red,
              textColor: Colors.white,
              iconColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(title),
              trailing: IconButton(
                icon: Icon(expand ? Icons.expand_less : Icons.expand_more),
                onPressed: onPressed,
              ),
            ),
            AnimatedContainer(
              width: 380,
              duration: const Duration(milliseconds: 300),
              height: expand ? min(widget.comments.length + 177, 250) : 0,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(33, 255, 109, 64),
              ),
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
