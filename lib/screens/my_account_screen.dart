import 'package:flutter/material.dart';
import 'package:project/widgets/my_account_body.dart';
import '../models/employee.dart';
import '../dummy_data.dart';

class MyAccountScreen extends StatelessWidget {
  static const routeName = '/my-account-screen';
  const MyAccountScreen({Key? key}) : super(key: key);

  // String age(DateTime bdate) {
  //   var myAge = DateTime.now().difference(bdate).toString();
  //   return myAge;
  // }

  @override
  Widget build(BuildContext context) {
    var currentUser = ModalRoute.of(context)!.settings.arguments as Employee;
    var comments = DUMMY_COMMENTS
        .where(
          (e) => e.workerId == currentUser.id,
        )
        .toList();
    return
        //  Directionality(
        //     textDirection: TextDirection.rtl,
        //     child: Scaffold(
        //         appBar: AppBar(
        //           title: Text('الصفحة الشخصية'),
        //           actions: <Widget>[
        //             IconButton(onPressed: () {}, icon: const Icon(Icons.messenger)),
        //             IconButton(
        //                 onPressed: () {}, icon: const Icon(Icons.notifications)),
        //           ],
        //         ),
        //         body:
        SingleChildScrollView(
      child: Center(
          child: MyAccountBody(comments: comments, currentUser: currentUser)),

      //   Stack(children: [
      //     Padding(
      //       padding: const EdgeInsets.only(top: 25),
      //       child: IconButton(
      //           onPressed: () => Navigator.of(context).pop(),
      //           icon: const Icon(Icons.arrow_back, color: Colors.white)),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.only(top: 170),
      //       child: Column(
      //         children: <Widget>[
      //           const SizedBox(
      //             height: 10,
      //           ),
      //           Card(
      //             elevation: 4,
      //             shape: RoundedRectangleBorder(
      //                 // side: BorderSide(
      //                 //     style: BorderStyle.solid,
      //                 //     width: 2,
      //                 //     color: Color.fromARGB(255, 210, 25, 12)),
      //                 borderRadius: BorderRadius.circular(10)),
      //             child:
      // Padding(
      //               padding: const EdgeInsets.symmetric(
      //                   horizontal: 10, vertical: 20),
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: <Widget>[
      //                   Row(
      //                     children: <Widget>[
      //                       const Text('الاسم: '),
      //                       Text(
      //                           '${currentUser.fname} ${currentUser.lname}')
      //                     ],
      //                   ),
      //                   const SizedBox(
      //                     height: 6,
      //                   ),
      //                   if (!currentUser.isUser)
      //                     Row(
      //                       children: <Widget>[
      //                         const Text('الحرفة: '),
      //                         Text(currentUser.categordId as String)
      //                       ],
      //                     ),
      //                   if (!currentUser.isUser)
      //                     const SizedBox(
      //                       height: 6,
      //                     ),
      //                   if (currentUser.bDate != null)
      //                     Row(
      //                       children: <Widget>[
      //                         const Text('السن: '),
      //                         Text(age(currentUser.bDate as DateTime))
      //                       ],
      //                     ),
      //                   if (currentUser.bDate != null)
      //                     const SizedBox(
      //                       height: 6,
      //                     ),
      //                   Row(
      //                     children: <Widget>[
      //                       const Text('المحافظة: '),
      //                       Text(currentUser.location)
      //                     ],
      //                   ),
      //                   const SizedBox(
      //                     height: 6,
      //                   ),
      //                   Row(
      //                     children: [
      //                       const Spacer(),
      //                       Padding(
      //                         padding: const EdgeInsets.only(left: 10),
      //                         child: TextButton.icon(
      //                             onPressed: () {},
      //                             icon: const Icon(
      //                               Icons.edit,
      //                               size: 20,
      //                             ),
      //                             label: const Text(
      //                               'تعديل',
      //                               style: TextStyle(
      //                                   decoration:
      //                                       TextDecoration.underline),
      //                             )),
      //                       ),
      //                     ],
      //                   )
      //                 ],
      //               ),
      //             ),
      //           ),
      //           // if (!currentUser.isUser)
      //           //   const SizedBox(
      //           //     height: 4,
      //           //   ),
      //           if (!currentUser.isUser) MyComments(comments),
      //           // Expanded(
      //           //   child: Card(
      //           //     elevation: 4,
      //           //     child: ListView.builder(
      //           //       itemBuilder: (context, index) {
      //           //         // var user = DUMMY_EMP.firstWhere((e) =>
      //           //         //     e.id ==
      //           //         //     widget.items
      //           //         //         .where((e) => e.workerId == widget.workerId)
      //           //         //         .toList()[index]
      //           //         //         .userId);

      //           //         var user = DUMMY_EMP.firstWhere(
      //           //           (e) => e.id == comments[index].userId,
      //           //         );
      //           //         return Padding(
      //           //             padding: const EdgeInsets.all(6),
      //           //             child: Column(
      //           //               crossAxisAlignment: CrossAxisAlignment.start,
      //           //               children: [
      //           //                 const Padding(
      //           //                     padding: EdgeInsets.symmetric(
      //           //                         horizontal: 20),
      //           //                     child: Text('التعليقات')),
      //           //                 ListTile(
      //           //                   leading: Container(
      //           //                     height: 40,
      //           //                     width: 40,
      //           //                     decoration: BoxDecoration(
      //           //                         borderRadius:
      //           //                             BorderRadius.circular(10)),
      //           //                     child: CircleAvatar(
      //           //                         maxRadius: 20,
      //           //                         backgroundImage: user.image != null
      //           //                             ? NetworkImage(
      //           //                                 user.image as String)
      //           //                             : const AssetImage(
      //           //                                     'assets/images/placeholder.png')
      //           //                                 as ImageProvider),
      //           //                   ),
      //           //                   title:
      //           //                       Text('${user.fname} ${user.lname}'),
      //           //                   subtitle: Text(comments[index].comment),
      //           //                 ),
      //           //               ],
      //           //             ));
      //           //       },
      //           //       itemCount: comments.length,
      //           //     ),
      //           //   ),
      //           // ),
      //           // if (!currentUser.isUser)
      //           //   const SizedBox(
      //           //     height: 4,
      //           //   ),
      //           if (!currentUser.isUser)
      //             Card(
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(10)),
      //                 elevation: 4,
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.end,
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.only(left: 20),
      //                       child: TextButton.icon(
      //                           onPressed: () {},
      //                           icon: const Icon(
      //                             Icons.edit,
      //                             size: 20,
      //                           ),
      //                           label: const Text(
      //                             'تعديل',
      //                             style: TextStyle(
      //                                 decoration:
      //                                     TextDecoration.underline),
      //                           )),
      //                     ),
      //                     ImagesGallery(
      //                         images: DUMMY_IMAGES
      //                             .firstWhere(
      //                                 (e) => e.id == currentUser.id)
      //                             .url as List<String>),
      //                   ],
      //                 )),
      //         ],
      //       ),
      //     ),
      //     const Padding(
      //       padding: EdgeInsets.only(top: 50, right: 150),
      //       child: CircleAvatar(
      //         backgroundColor: Colors.red,
      //         minRadius: 103,
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.only(top: 50, right: 150),
      //       child: CircleAvatar(
      //         backgroundImage: currentUser.image != null
      //             ? NetworkImage(currentUser.image as String)
      //             : const AssetImage('assets/images/placeholder.png')
      //                 as ImageProvider,
      //         minRadius: 100,
      //       ),
      //     ),
      //   ]),
      // )));
    );
  }
}
