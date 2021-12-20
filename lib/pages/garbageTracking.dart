import 'package:feel_safe/chat/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feel_safe/services/getlocation.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class GarbageTracking extends StatefulWidget {
  @override
  _GarbageTracking createState() => _GarbageTracking();
  FirebaseDatabase database = FirebaseDatabase.instance;
}

class _GarbageTracking extends State<GarbageTracking> {
  //Get real time values
  DatabaseReference ref =
      FirebaseDatabase.instance.ref("watchapp-e17ee-default-rtdb/Distance");

  void getData() {
    // Get the Stream
    Stream<DatabaseEvent> stream = ref.onValue;

    // Subscribe to the stream!
    stream.listen((DatabaseEvent event) {
      print('Event Type: ${event.type}'); // DatabaseEventType.value;
      print('Snapshot: ${event.snapshot}'); // DataSnapshot
    });
  }

  Widget getCircular() {
    //1st get real time value
    var percentagefilled = 10; //Test

    //2nd compare the value and returning correct colour
    if (percentagefilled <= 3) {
      return CircularPercentIndicator(
        radius: 200,
        lineWidth: 25,
        percent: percentagefilled / 10,
        animateFromLastPercent: true,
        animation: true,
        center: new Text(
          percentagefilled.toString() + "0%",
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        progressColor: Colors.greenAccent,
      );
    } else if (percentagefilled > 3 && percentagefilled <= 6) {
      return CircularPercentIndicator(
        radius: 200,
        lineWidth: 25,
        percent: percentagefilled / 10,
        animateFromLastPercent: true,
        animation: true,
        center: new Text(
          percentagefilled.toString() + "0%",
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        progressColor: Colors.yellow,
      );
    } else if (percentagefilled > 6 && percentagefilled <= 9) {
      return CircularPercentIndicator(
        radius: 200,
        lineWidth: 25,
        percent: percentagefilled / 10,
        animateFromLastPercent: true,
        animation: true,
        center: new Text(
          percentagefilled.toString() + "0%",
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        progressColor: Colors.orange,
      );
    } else {
      return CircularPercentIndicator(
        radius: 200,
        lineWidth: 25,
        percent: percentagefilled / 10,
        animateFromLastPercent: true,
        animation: true,
        center: new Text(
          percentagefilled.toString() + "0%",
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        progressColor: Colors.redAccent[400],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call the method here getData();
    getData();
    return Scaffold(
        appBar: AppBar(
          title: Text("Garbage Tracking"),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Live monitoring : ",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                getCircular(), //Get the correct circular progress bar color widget
              ],
            ),
          ),
        ));
  }
}
