import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (contex) => IndividualPage(
        //               chatModel: chatModel,
        //               sourchat: sourchat,
        //             )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            // child: SvgPicture.asset(
            //   chatModel.isGroup ? "assets/groups.svg" : "assets/person.svg",
            //   color: Colors.white,
            //   height: 36,
            //   width: 36,
            // ),
            backgroundColor: Colors.blueGrey,
          ),
          title: Text(
            'chatModel.name',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: FittedBox(
            child: Row(
              children: [
                Icon(Icons.done_all),
                SizedBox(
                  width: 3,
                ),
                Text(
                  'chatModel.currentMessage',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          trailing: Text('chatModel.time'),
        ),
      ),
    );
  }
}
