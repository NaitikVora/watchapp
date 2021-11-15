import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';

late FirebaseAuth _auth;

class CreateReport extends StatefulWidget {
  final Address _location;
  CreateReport(this._location);
  @override
  _CreateReportState createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('reports');

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  String? _title = "";
  String? _info = "";

  void _showSubmitDialog(String msg) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Report successfully submitted"),
          content: new Text("Thank you for contributing"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Continue"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
          ],
        );
      },
    );
  }

  submitReport() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      if (_title!.length > 0 && _info!.length > 0) {
        var x = {
          'Title': _title,
          'Information': _info,
          'Location': widget._location.addressLine,
          'Subloc': widget._location.subLocality,
          'City': widget._location.locality,
          'State': widget._location.adminArea,
          'Report time': DateTime.now().toString(),
        };
        await collectionReference.add(x).catchError((err) {
          print("Error $err");
        });
        _showSubmitDialog(x.toString());
      } else {
        print("Error");
        showError("Enter Proper Report Data");
      }
    }
  }

  //Show a snackbar at the bottom
  showError(String error) {
    final snackbar = SnackBar(
      content: new Text(error),
    );
    _scaffoldKey.currentState!.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Create Report"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(35.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                    ),
                    onSaved: (value) => _title = value,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Information",
                      labelStyle: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                    ),
                    onSaved: (value) => _info = value,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Location Selected:",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${widget._location.addressLine}",
                    //"${widget._location.addressLine}",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  MaterialButton(
                    child: Text("Submit Report"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: submitReport,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
