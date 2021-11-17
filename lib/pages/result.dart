import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_safe/services/locationinfo.dart';
import 'package:feel_safe/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ShowResult extends StatefulWidget {
  final String _location;
  ShowResult(this._location);
  @override
  _ShowResultState createState() => _ShowResultState();
}

class _ShowResultState extends State<ShowResult> {
  late StreamSubscription<QuerySnapshot> subscription;
  bool t = false;

  late List<DocumentSnapshot> eventsData;
  int _lengthOfEventsData = 0;

  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('reports');
  late String key, query, url, myText;
  List data = [];
  late int length;

  @override
  void initState() {
    super.initState();
    key = "c0dd7cc7ac9d4795a2899b239ca25dd8";
    query =
        "(+injured OR +killed OR +accident) AND (+${widget._location}) AND (-football OR -cricket) AND ${widget._location}";
    url = "https://newsapi.org/v2/everything?q=$query&apiKey=$key";
    // print(url);
    this.getJsonData();

    subscription = collectionReference.snapshots().listen((datasnapshot) {
      getCurrentLocation().then((address) {
        var x = address.subLocality.toString();
        //print(x);

        FirebaseFirestore.instance
            .collection('/reports')
            .where('Subloc', isEqualTo: x)
            .get()
            .then((docs) {
          setState(() {
            eventsData = docs.docs;
            _lengthOfEventsData = docs.docs.length;
            // print("len $_lengthOfEventsData");
          });
        });
      });
    });
    // fetch_firebase();
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<String> getJsonData() async {
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    // print(response.body);

    setState(() {
      var convertDataDataToJson = json.decode(response.body);
      data = convertDataDataToJson['articles'];
      // print(data);
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: t ? Text("NEWS") : Text("REPORTS"),
        actions: <Widget>[
          MaterialButton(
            child: t ? Text("REPORTS") : Text("NEWS"),
            color: Colors.white,
            onPressed: () {
              setState(() {
                t = !t;
              });
            },
          )
        ],
      ),
      drawer: CustomDrawer(context),
      body: t
          ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
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
                                data[index]['title'],
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                            ),
                            InkWell(
                              onTap: () {
                                _launchURL(data[index]['url']);
                              },
                              child: Text(
                                data[index]['url'],
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: _lengthOfEventsData,
              itemBuilder: (BuildContext context, int index) {
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
