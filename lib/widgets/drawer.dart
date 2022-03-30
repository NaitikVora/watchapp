import 'package:feel_safe/pages/adminContact.dart';
import 'package:feel_safe/pages/adminLogin.dart';
import 'package:feel_safe/pages/createReportOptions.dart';
import 'package:feel_safe/pages/homepage.dart';
import 'package:feel_safe/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Widget CustomDrawer(BuildContext context) {
  final GoogleSignIn googleSignin = GoogleSignIn();
  return Drawer(
    child: ListView(
      children: <Widget>[
        ListTile(
            title: Text("Dashboard"),
            trailing: Icon(Icons.home),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => HomePage()));
            }),
        ListTile(
            title: Text("Report Crime"),
            trailing: Icon(Icons.report),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => CreateReportOptions()));
            }),
        ListTile(
          title: Text("Login as Admin"),
          trailing: Icon(Icons.admin_panel_settings_rounded),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AdminLogin()));
            googleSignin.signOut();
            print("User Signed out");
          },
        ),
        //Add admin contact for later use.
        /*
        ListTile(
          title: Text("Contact Admin"),
          trailing: Icon(Icons.admin_panel_settings_rounded),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AdminContact()));
            googleSignin.signOut();
            print("User Signed out");
          },
        ),*/
        ListTile(
          title: Text("Sign Out"),
          trailing: Icon(Icons.exit_to_app),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => Login()));
            googleSignin.signOut();
            print("User Signed out");
          },
        ),
      ],
    ),
  );
}
