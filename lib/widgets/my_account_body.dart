import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/models/employee.dart';
import 'package:project/screens/detailed_image_screen.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/comment.dart';
import '../models/image.dart';
import '../providers/images.dart';
import '../providers/user.dart';
import '../providers/worker.dart';

class MyAccountBody extends StatefulWidget {
  const MyAccountBody({Key? key}) : super(key: key);

  @override
  State<MyAccountBody> createState() => _MyAccountBodyState();
}

class _MyAccountBodyState extends State<MyAccountBody> {
  var _expandComment = false;
  var _expandInfo = false;
  var newWorkImage = MyImage('', [], '');
  var _isLoading = false;
  // String age(DateTime bdate) {
  //   var myAge = DateTime.now().difference(bdate).toString();
  //   return myAge;
  // }
  late Employee currentUser;
  List<Comment> comments = [];
  var _isInit = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final userId = Provider.of<User>(context, listen: false).userId;
      await Provider.of<User>(context)
          .getUser(userId)
          .then((value) => currentUser = value);
      if (currentUser.role == 'worker') {
        final workerProfile = await Provider.of<Worker>(context, listen: false)
            .getWorker((userId));
        comments = workerProfile['workerComments'];
      }
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

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

  Future _dialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          content: const Text(
            'قم باختيار مصدر الصورة',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              child: const Text('الكاميرا'),
              onPressed: () {
                _pickedImageCamera();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('المعرض'),
              onPressed: () {
                _pickedImageGallery();
                Navigator.of(context).pop();
              },
            ),
          ]),
    );
  }

  Future<void> _pickedImageCamera() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage == null) return;
      setState(() {
        _isLoading = true;
      });
      String userImage = await Provider.of<Images>(context, listen: false)
          .addImage(pickedImage.path);
      await Provider.of<User>(context, listen: false).editUser(
          currentUser.fname,
          currentUser.lname,
          currentUser.gender,
          currentUser.phone.toString(),
          currentUser.location,
          currentUser.address,
          userImage);
      setState(() {
        _isInit = true;
      });
      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (_) {
      return;
    }
  }

  Future<void> _pickedImageGallery() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;
      setState(() {
        _isLoading = true;
      });
      String userImage = await Provider.of<Images>(context, listen: false)
          .addImage(pickedImage.path);
      await Provider.of<User>(context, listen: false).editUser(
          currentUser.fname,
          currentUser.lname,
          currentUser.gender,
          currentUser.phone.toString(),
          currentUser.location,
          currentUser.address,
          userImage);
      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (_) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: SpinKitSpinningLines(
                color: Theme.of(context).colorScheme.primary))
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: 380,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: currentUser.image != ''
                        ? InkWell(
                            onTap: () => Navigator.of(context).pushNamed(
                                DetailedImageScreen.routeName,
                                arguments: currentUser.image),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: currentUser.image == ''
                                    ? Image.asset(
                                        'assets/images/placeholder.png')
                                    : CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        height: 400,
                                        imageUrl: currentUser.image as String,
                                        placeholder: (context, url) => SizedBox(
                                            height: 480,
                                            width: 380,
                                            child: Center(
                                              child: SpinKitSpinningLines(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            )),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      )),
                          )
                        : Image.asset('assets/images/placeholder.png'),
                  ),
                  Positioned(
                      bottom: 20,
                      left: 10,
                      child: IconButton(
                          onPressed: () => _dialog(context),
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Color(0xFF323232),
                          )))
                ],
              ),
              boxWidget(
                _expandInfo,
                'معلوماتي',
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Text('الاسم: '),
                            Text('${currentUser.fname} ${currentUser.lname}')
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: <Widget>[
                            const Text('رقم الهاتف: '),
                            Text('0${currentUser.phone.toString()}')
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        if (currentUser.role == 'worker')
                          Row(
                            children: <Widget>[
                              const Text('الحرفة: '),
                              Text(currentUser.categordId as String)
                            ],
                          ),
                        if (currentUser.role == 'worker')
                          const SizedBox(
                            height: 6,
                          ),
                        if (currentUser.bDate != null)
                          Row(
                            children: <Widget>[
                              const Text('السن: '),
                              Text(calculateAge(currentUser.bDate as DateTime)
                                  .toString())
                            ],
                          ),
                        if (currentUser.bDate != null)
                          const SizedBox(
                            height: 6,
                          ),
                        Row(
                          children: <Widget>[
                            const Text('المحافظة: '),
                            Text(currentUser.location)
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: <Widget>[
                            const Text('العنوان: '),
                            Text(currentUser.address)
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        // Row(
                        // children: [
                        // const Spacer(),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 10),
                        //   child: TextButton.icon(
                        //       onPressed: () => Navigator.of(context)
                        //               .pushNamed(SettingsBody.routeName,
                        //                   arguments: {
                        //                 'currentUser': currentUser,
                        //                 'editPass': false
                        //               }),
                        //       icon: const Icon(
                        //         Icons.edit,
                        //         size: 20,
                        //       ),
                        //       label: const Text(
                        //         'تعديل',
                        //         style: TextStyle(
                        //             decoration: TextDecoration.underline),
                        //       )),
                        // ),
                        // ],
                        // )
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
              if (currentUser.role == 'worker')
                boxWidget(
                  _expandComment,
                  'اظهر التعليقات',
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(6),
                        child: comments.isEmpty
                            ? const Text('لا يوجد تعليقات')
                            : SizedBox(
                                height: 50,
                                child: ListTile(
                                  leading: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: CircleAvatar(
                                        maxRadius: 20,
                                        backgroundImage: comments[index]
                                                    .user!
                                                    .picture !=
                                                ''
                                            ? NetworkImage(comments[index]
                                                    .user!
                                                    .picture)
                                                as ImageProvider<Object>
                                            : const AssetImage(
                                                'assets/images/placeholder.png')),
                                  ),
                                  title: Text(
                                      '${comments[index].user!.fname} ${comments[index].user!.lname}'),
                                  subtitle: Text(comments[index].comment),
                                ),
                              ),
                      );
                    },
                    itemCount: comments.length,
                  ),
                  () {
                    setState(() {
                      _expandComment = !_expandComment;
                    });
                  },
                ),
            ],
          );
  }

  AnimatedContainer boxWidget(
      bool expand, String title, Widget child, void Function()? onPressed) {
    return AnimatedContainer(
      width: 380,
      duration: const Duration(milliseconds: 300),
      height: expand ? min(comments.length + 245, 300) : 68,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            ListTile(
              tileColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).textTheme.bodyText1!.color,
              iconColor: Theme.of(context).iconTheme.color,
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
              height: expand ? min(comments.length + 177, 250) : 0,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(32, 74, 64, 255),
              ),
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
