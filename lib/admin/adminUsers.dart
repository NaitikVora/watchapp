import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watch_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_admin/src/credential.dart';

class AdminUsers extends StatefulWidget {
  @override
  _AdminUsers createState() => _AdminUsers();
}

class _AdminUsers extends State<AdminUsers> {
  final user = FirebaseAuth.instance.currentUser;

  //Admin SDK wont work with flutter
  //Need to use Node.js for proper Backend functions.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Hello"),
          onPressed: displayUsers,
        ),
      ),
    );
  }
}

displayUsers() {
  var cert = FirebaseAdmin.instance.certFromPath(
      "../watchapp-e17ee-firebase-adminsdk-rvpba-6ef9b96fb5.json");

  var app = FirebaseAdmin.instance.initializeApp(AppOptions(
    credential: cert,
  ));

  app.auth().deleteUser("6khrrLdqKNRCRKLJrMUfDqTwfab2");
}
