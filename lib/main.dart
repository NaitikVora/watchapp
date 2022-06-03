import 'package:watch_app/pages/garbageTracking.dart';
import 'package:watch_app/pages/homepage.dart';
import 'package:watch_app/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/getlocation.dart';
import 'services/showNotification.dart';

var user;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Get location on startup
  GetLocation.getLocation();
  //Initialize firebse for login and reporting
  await Firebase.initializeApp();
  user = FirebaseAuth.instance.currentUser;
  //print(user);

  //Notifications init
  ShowNotification.init();

  //Run app
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false, //Hides the debug banner
      title: 'The Neighbourhood Watch App',
      theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
      home: (user == null) ? Login() : HomePage(),
    );
  }
}
