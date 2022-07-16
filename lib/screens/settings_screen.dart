import 'package:flutter/material.dart';
import 'package:project/widgets/settings_body_widget.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class MainSettingsScreen extends StatelessWidget {
  const MainSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> deleteAccount() async {
      await Provider.of<Auth>(context, listen: false).logOut();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Center(child: Text('الاعدادات')),
      ),
      body: Column(
        children: [
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)),
            child: ListTile(
                title: const Text('تعديل حسابي'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.of(context)
                    .pushNamed(SettingsBody.routeName, arguments: true)),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)),
            child: ListTile(
                title: const Text('تعديل معلوماتي'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.of(context)
                    .pushNamed(SettingsBody.routeName, arguments: false)),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)),
            child: ListTile(
                title: const Text('حذف الحساب'),
                trailing: const Icon(Icons.delete),
                onTap: () => showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          actionsAlignment: MainAxisAlignment.start,
                          title: const Text(
                            'هل انت متأكد؟ لا يمكنك استرجاع الحساب بعد حذفه.',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  deleteAccount();
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text(
                                  'نعم',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ))
                          ],
                        ))),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)),
            child: ListTile(
                title: const Text('تسجيل الخروج'),
                trailing: const Icon(Icons.logout),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<Auth>(context, listen: false).logOut();
                }),
          ),
        ],
      ),
    );
  }
}
