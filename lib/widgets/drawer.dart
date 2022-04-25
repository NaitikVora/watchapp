import 'package:watch_app/pages/adminContact.dart';
import 'package:watch_app/pages/adminLogin.dart';
import 'package:watch_app/pages/createReportOptions.dart';
import 'package:watch_app/pages/homepage.dart';
import 'package:watch_app/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

Widget CustomDrawer(BuildContext context) {
  final GoogleSignIn googleSignin = GoogleSignIn();
  final user = FirebaseAuth.instance.currentUser;

  return Drawer(
    child: ListView(
      children: <Widget>[
        DrawerHeader(
          padding: EdgeInsets.zero,
          child: UserAccountsDrawerHeader(
            accountName: Text(
              user!.displayName.toString(),
              textScaleFactor: 1.25,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            accountEmail: Text(
              user.email.toString(),
              textScaleFactor: 1.1,
            ),
            currentAccountPicture: ClipOval(
              child: Image.network(user.photoURL.toString()),
            ),
          ),
        ),
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
            //print("User Signed out");
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
            //print("User Signed out");
          },
        ),
      ],
    ),
  );
}
