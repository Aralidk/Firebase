import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: FutureBuilder(
        future: _initialization,
        builder: (context,snapshot)  {
          if(snapshot.hasError){
            return Center(child: Text("unwaited error"));
          }
          else{
            return HomePage();
          }
        },
      )
      //const MyHomePage(title: 'Flutter Demo Home Page')
    );
  }
}
