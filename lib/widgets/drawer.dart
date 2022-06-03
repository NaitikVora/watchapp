import 'package:watch_app/pages/adminContact.dart';
import 'package:watch_app/pages/adminLogin.dart';
import 'package:watch_app/pages/createReportOptions.dart';
import 'package:watch_app/pages/homepage.dart';
import 'package:watch_app/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

Widget CustomDrawer(BuildContext context) {
  final GoogleSignIn googleSignin = GoogleSignIn();
  final user = FirebaseAuth.instance.currentUser;

  return Drawer(
    child: ListView(
      children: <Widget>[
        Text(
          "Anonymous session active",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.red),
            foregroundColor:
                MaterialStateColor.resolveWith((states) => Colors.white),
            padding: MaterialStateProperty.all(
              EdgeInsets.all(20.0),
            ),
          ),
          onPressed: () {
            final popup = BeautifulPopup(
              context: context,
              template: TemplateGeolocation,
            );
            popup.show(
              title: 'Emergency Dial',
              content:
                  '\nAre you in danger and require immediate help? \n\nProceed to call Indian Emergency Helpline Numbers. Never misuse the Emergency Helplines.',
              actions: [
                popup.button(
                  label: 'POLICE',
                  onPressed: () async {
                    const number =
                        '100'; //Add 100 POLICE Emergency Helpline here
                    bool? res =
                        await FlutterPhoneDirectCaller.callNumber(number);
                  },
                ),
                popup.button(
                  label: 'FIRE',
                  onPressed: () async {
                    const number = '101'; //Add 101 FIRE Emergency Helpline here
                    bool? res =
                        await FlutterPhoneDirectCaller.callNumber(number);
                  },
                ),
                popup.button(
                  label: 'AMBULANCE',
                  onPressed: () async {
                    const number =
                        '102'; //Add 102 Ambulance Emergency Helpline here
                    bool? res =
                        await FlutterPhoneDirectCaller.callNumber(number);
                  },
                ),
              ],
            );
          }, //Call emergency handle
          child: Text(
            "Emergency",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ],
    ),
  );
}
