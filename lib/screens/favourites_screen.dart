import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/models/employee.dart';
import 'package:project/providers/favourites.dart';
import 'package:project/screens/worker_details_screen.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  var _isInit = true;
  var _isLoading = false;
  late List<Employee> employees;
  late Employee currentUser;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      employees = await Provider.of<Favourites>(context).getAllFavourites();
      final userId = Provider.of<User>(context, listen: false).userId;
      currentUser =
          await Provider.of<User>(context, listen: false).getUser(userId);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: const Center(child: Text('مفضلاتي'))),
        body: _isLoading
            ? Center(
                child: SpinKitSpinningLines(
                    color: Theme.of(context).colorScheme.primary),
              )
            : Padding(
                padding: const EdgeInsets.all(6),
                child: GridView(
                  children: <Widget>[
                    ...employees.map((e) => InkWell(
                        onTap: () => Navigator.of(context).pushNamed(
                                WorkerDetailsScreen.routeName,
                                arguments: {
                                  'currentWorker': e,
                                  'currentUser': currentUser
                                }),
                        splashColor: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GridTile(
                            child: Hero(
                              tag: e.id,
                              child: CachedNetworkImage(
                                imageUrl: e.image!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    SpinKitSpinningLines(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            footer: GridTileBar(
                              backgroundColor:
                                  const Color.fromARGB(150, 0, 0, 0),
                              title: Text(
                                '${e.fname} ${e.lname}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )))
                  ],
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2.7 / 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  padding: const EdgeInsets.all(25),
                ),
              ),
      ),
    );
  }
}
