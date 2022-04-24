import 'dart:math';

import 'package:intl/intl.dart';
import 'package:watch_app/main.dart';
import 'package:watch_app/services/locationinfo.dart';
import 'package:watch_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';
import 'package:file_picker/file_picker.dart';

late FirebaseAuth _auth;

class CreateReport extends StatefulWidget {
  final Address _location;
  CreateReport(this._location);
  @override
  _CreateReportState createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  final user = FirebaseAuth.instance.currentUser;
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
  String download_url = "None";
  String? selectedCrime = "";

  void _showSubmitDialog(String msg) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Report Successfully Submitted"),
          content: new Text("Thank you for contributing!"),
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
    print(DateTime.now());
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      if (_title!.length > 0 && _info!.length > 0) {
        var now = DateTime.now();
        var formatterDate = DateFormat('dd/MM/yy');
        var formatterTime = DateFormat('kk:mm');
        String actualDate = formatterDate.format(now);
        String actualTime = formatterTime.format(now);
        var x = {
          'Title': _title,
          'Information': _info,
          'Location': widget._location.addressLine,
          'Subloc': widget._location.subLocality,
          'City': widget._location.locality,
          'State': widget._location.adminArea,
          'Date': actualDate,
          'Time': actualTime,
          //'Report_time': DateTime.now().toString(),
          //'Report_time': FieldValue.serverTimestamp(),
          'Evidence': download_url,
          //'Downvote': 0, //To report as fake counter
          'owner': user?.uid, //Owner of report in uid terms
          'crime_type': selectedCrime, //To be filled by user
          'lat': widget._location.coordinates.latitude.toString(),
          'long': widget._location.coordinates.longitude.toString(),
          //'Evidence': download_url.toString(),
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
    var crimetype = [
      "Accident",
      "Assault",
      "Fire",
      "Theft",
      "Vehicle related",
      "Drug incident",
      "Disaster",
      "Women safety related",
      "Other"
    ];
    final Storage storage = Storage();
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
                          color: Colors.black),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                    ),
                    onSaved: (value) => _title = value,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //Dropdown for incident type

                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Crime Type",
                      labelStyle: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                    ),
                    items: crimetype.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCrime = value.toString();
                      });
                    },
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
                          color: Colors.black),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                    ),
                    onSaved: (value) => _info = value,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  //Evidence upload
                  ElevatedButton(
                      onPressed: () async {
                        final results = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                        ); //Add multiple files and filetype filters in future

                        if (results == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("File not selected"),
                            ),
                          );
                          return null;
                        }

                        String? path = results.files.single.path;
                        String fileName = results.files.single.name;

                        storage.uploadFile(path!, fileName).then((value) =>
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Evidence Uploaded"),
                            )));

                        /*storage
                            .downloadUrl(fileName)
                            .then((value) => download_url = value);*/

                        download_url = fileName;
                      },
                      child: Text("Upload file evidence if any")),
                  //Evidence upload
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Location Selected:",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
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
                      color: Colors.black,
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
