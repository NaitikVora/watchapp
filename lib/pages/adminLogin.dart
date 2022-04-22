import 'package:watch_app/pages/adminPage.dart';
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.all(55),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text("Admin Login",
                    style: TextStyle(
                        fontSize: 48,
                        color: Colors.black,
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
                style: TextStyle(
                  fontSize: 28,
                ),
                controller: uid,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Password: ",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter password",
                ),
                style: TextStyle(
                  fontSize: 28,
                ),
                controller: pass,
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 22))),
                    child: Text("Login"),
                    onPressed: () => adminChecker(),
                  ),
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
