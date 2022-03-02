import 'package:firabasenoteapp/SERVICES/auth_services.dart';
import 'package:firabasenoteapp/pages/detail_page.dart';
import 'package:firabasenoteapp/pages/home_page.dart';
import 'package:firabasenoteapp/pages/sign_in_page.dart';
import 'package:firabasenoteapp/pages/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'SERVICES/hive_db_services.dart';

void main() async {

  await Hive.initFlutter();
  await Hive.openBox(HiveBase.DB_NAME);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  Widget _startPage(){
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            HiveBase.storeUser(snapshot.data!.uid);
            return  HomePage(user: AuthServices.auth.currentUser!);
          } else {
            HiveBase.removeUser();
            return  SignInPage();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: _startPage(),
      routes: {
        SignInPage.id: (context) => SignInPage(),
        SignUpPage.id: (context) => SignUpPage(),
        DetailPage.id: (context) => DetailPage(),
      },
    );
  }
}
