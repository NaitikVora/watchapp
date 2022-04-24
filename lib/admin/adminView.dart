//Monitor& Moderate function -- View all the reports, sorted to desc order
//of report time and delete false reports

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watch_app/services/storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminView extends StatefulWidget {
  @override
  _AdminView createState() => _AdminView();
}

class _AdminView extends State<AdminView> {
  //Get reports variables
  late StreamSubscription<QuerySnapshot> subscription;
  late List<DocumentSnapshot> eventsData;
  int _lengthOfEventsData = 0;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('reports');

  //Fetch here
  @override
  void initState() {
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      FirebaseFirestore.instance
          .collection('/reports')
          .orderBy('Time', descending: false)
          .get()
          .then((docs) {
        setState(() {
          eventsData = docs.docs;
          _lengthOfEventsData = docs.docs.length;
          // print("len $_lengthOfEventsData");
        });
      });
    });
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    String netURLDef =
        "https://demofree.sirv.com/nope-not-here.jpg"; //By default
    return Scaffold(
      backgroundColor: Colors.blueAccent[700],
      body: ListView.builder(
        itemCount: _lengthOfEventsData,
        itemBuilder: (BuildContext context, int index) {
          //Method to check if image is provided and proceed accordingly
          Widget getEvidence() {
            String fileNameUploaded = eventsData[index]['Evidence'].toString();

            if (fileNameUploaded != "None") {
              return ElevatedButton(
                  onPressed: () async {
                    String fileNameUploaded =
                        eventsData[index]['Evidence'].toString();

                    if (fileNameUploaded != "None") {
                      storage.downloadUrl(fileNameUploaded).then((value) {
                        print(value);
                        netURLDef = value;
                        _launchURL(netURLDef);
                      });
                    }
                  },
                  child: Text("Evidence"));
            }
            return Text("Evidence unavailable");
          }

          return Container(
            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
            child: Center(
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: Text(
                          eventsData[index]['Title'],
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      Text(
                        eventsData[index]['Information'],
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      Text(
                        "Location:",
                        style: TextStyle(
                            fontSize: 11.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        eventsData[index]['Location'],
                        style: TextStyle(fontSize: 11.0),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      Text(
                        "Date: " + ((eventsData[index]['Date'].toString())),
                        style: TextStyle(
                            fontSize: 11.0, fontWeight: FontWeight.normal),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      Text(
                        "Time: " + ((eventsData[index]['Time'].toString())),
                        style: TextStyle(
                            fontSize: 11.0, fontWeight: FontWeight.normal),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      getEvidence(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            onPressed: () async {
                              await FirebaseFirestore.instance.runTransaction(
                                  (Transaction myTransaction) async {
                                myTransaction
                                    .delete(eventsData[index].reference);
                              });
                            },
                            child: Text("Remove")),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
