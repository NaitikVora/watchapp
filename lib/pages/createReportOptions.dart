import 'package:watch_app/pages/createReport.dart';
import 'package:watch_app/pages/mapview.dart';
import 'package:flutter/material.dart';
import 'package:watch_app/services/locationinfo.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong2/latlong.dart';
import 'homepage.dart';
import 'package:location/location.dart';

class CreateReportOptions extends StatefulWidget {
  @override
  _CreateReportOptionsState createState() => _CreateReportOptionsState();
}

class _CreateReportOptionsState extends State<CreateReportOptions> {
  Widget retButton(text, textColor, color, from) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        height: 50.0,
        child: InkWell(
          onTap: () {
            switch (from) {
              case "current":
                getCurrentLocation().then((address) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateReport(address)));
                });
                break;

              case "choose":
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MapView(false)));
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
      appBar: AppBar(title: Text("Select Location")),
      body: Container(
        padding: EdgeInsets.all(80.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              retButton(
                  "CURRENT LOCATION", Colors.white, Colors.blue, "current"),
              Text(
                "OR",
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              retButton("CHOOSE ON MAP", Colors.white, Colors.blue, "choose"),
            ],
          ),
        ),
      ),
    );
  }
}
