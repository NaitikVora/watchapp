import 'package:feel_safe/pages/homepage.dart';
import 'package:feel_safe/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/getlocation.dart';

var user;
void main() async {
  //var x = GetLocation.getLocation().toString();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  user = FirebaseAuth.instance.currentUser;
  //print(user);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'The Neighbourhood Watch App',
      theme: new ThemeData(
          scaffoldBackgroundColor: Color.fromRGBO(33, 106, 217, 0.7)),
      home: (user == null) ? Login() : HomePage(),
    );
  }
}
