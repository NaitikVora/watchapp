import 'package:feel_safe/pages/adminPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLogin createState() => _AdminLogin();
}

class _AdminLogin extends State<AdminLogin> {
  final uid = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[700],
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
          ),
          Center(
            child: Text("Admin Login",
                style: TextStyle(
                    fontSize: 52,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            "Username: ",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Enter username"),
            style: TextStyle(fontSize: 28, color: Colors.white),
            controller: uid,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Password: ",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter password",
                fillColor: Colors.white),
            style: TextStyle(fontSize: 28, color: Colors.white),
            controller: pass,
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                  textStyle:
                      MaterialStateProperty.all(TextStyle(fontSize: 22))),
              child: Text("Login"),
              onPressed: () => adminChecker(),
            ),
          )
        ],
      )),
    );
  }

  void adminChecker() {
    if (uid.text == "admin" && pass.text == "admin") {
      const snackBar = SnackBar(
        content: Text('Admin authenticated'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AdminPage())); //AdminPage
    } else {
      const snackBar = SnackBar(
        content: Text('Invalid admin credentials'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
