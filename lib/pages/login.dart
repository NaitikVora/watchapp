import 'dart:async';

import 'package:watch_app/pages/adminLogin.dart';
import 'package:watch_app/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  static late GoogleSignInAccount userForDrawer;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignin = GoogleSignIn();

  Future<User?> currentUser() async {
    final GoogleSignInAccount account =
        await (GoogleSignIn().signIn() as FutureOr<GoogleSignInAccount>);
    Login.userForDrawer = account;
    final GoogleSignInAuthentication authentication =
        await account.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken) as GoogleAuthCredential;

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User? user = authResult.user;

    //print("User Name : ${user?.displayName}");

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));

    return user;
  }

  User? userData() {
    var user = FirebaseAuth.instance.currentUser;
    return user;
  }

  void adminlogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AdminLogin()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              'assets/images/login_back.jpeg',
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "The Neighbourhood Watch App",
                        style: TextStyle(
                          color: Color.fromRGBO(56, 191, 25, 1),
                          fontSize: 65.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Container(
                        height: 50.0,
                        child: InkWell(
                          onTap: () {
                            currentUser(); //Opens up the google sign in dialog box and works correctly
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(40.0),
                            shadowColor: Colors.greenAccent,
                            color: Colors.white,
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                "USER SIGN IN",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0),
                      child: Container(
                        height: 50.0,
                        child: InkWell(
                          onTap: () {
                            //ADD ADMIN SIGNIN
                            adminlogin();
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(40.0),
                            shadowColor: Colors.lightGreen,
                            color: Colors.black,
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                "ADMIN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
