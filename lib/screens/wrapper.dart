import "package:file_observer/screens/home_page.dart";
import 'package:file_observer/models/tender.dart';
import 'package:file_observer/models/user.dart';
import 'package:file_observer/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:file_observer/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    //return either Home or Authenticate widget

    final currentUser = Provider.of<AppUser>(context);

    if (currentUser.uid == 'x uid') {
      return const Authenticate();
    } else {
      return MultiProvider(
        providers: [
          //Provider(create:(context) => DatabaseService().tenders),
          StreamProvider<UserData?>(
            create: (_) => DatabaseService(uid: currentUser.uid).userData,
            initialData: UserData(uid: '', userName: '', userSection: ''),
          ),
          StreamProvider<List<Tender>?>(
            create: (_) => DatabaseService().tenders,
            initialData: const [],
          ),
          StreamProvider<String?>(
            create: (_) => DatabaseService().currentAppVersion,
            initialData: '',
          ),
        ],
        child:const HomePage(),
      );
      // return StreamProvider<UserData>.value(
      //   value: DatabaseService(uid: currentUser.uid).userData,
      //   child: HomePage());
    }
  }
}
