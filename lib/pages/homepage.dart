import 'package:feel_safe/pages/createReportOptions.dart';
import 'package:feel_safe/pages/mapview.dart';
import 'package:feel_safe/pages/result.dart';
import 'package:feel_safe/services/locationinfo.dart';
import 'package:feel_safe/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _locationEntered = getCurrentLocation().toString();

  handleReport() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreateReportOptions()));
  }

  handleLocation(val) {
    _locationEntered = val;
  }

  goToResult() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ShowResult(_locationEntered)));
  }

  goToMap() {}

  Widget retButton(text, textColor, color, from) {
    return Padding(
      padding: from == "report now"
          ? EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0)
          : EdgeInsets.all(10.0),
      child: Container(
        height: 50.0,
        child: InkWell(
          onTap: () {
            switch (from) {
              case "report now":
                handleReport();
                break;

              case "status":
                getCurrentLocation().then((address) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShowResult(address.subLocality)));
                });

                break;

              case "chat":
                break;
            }
          },
          child: Material(
            borderRadius: BorderRadius.circular(40.0),
            shadowColor: Colors.greenAccent,
            color: color,
            elevation: 7.0,
            child: Center(
              child: Text(
                "$text",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("The Neighbourhood Watch App"),
      ),
      drawer: CustomDrawer(context),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Text(
                    "Dashboard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                      child: Text(
                        "Your neighbourhood's safety, now in your hands.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70.0,
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(0.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Fetching Report options
                          retButton("Report Crime", Colors.white,
                              Colors.redAccent, "report now"),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(0.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Fetching Report options
                          retButton("Chat Anonymously", Colors.white,
                              Colors.purple[900], "chat"),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(0.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Fetching Report options
                          retButton("Your Neighbourhood", Colors.white,
                              Color.fromRGBO(72, 189, 13, 1), "status"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}