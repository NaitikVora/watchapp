import 'package:feel_safe/chat/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feel_safe/services/getlocation.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:convert';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class GarbageTracking extends StatefulWidget {
  @override
  _GarbageTracking createState() => _GarbageTracking();
  FirebaseDatabase database = FirebaseDatabase.instance;
}

class _GarbageTracking extends State<GarbageTracking> {
  handleGarbageCall() {
    final popup = BeautifulPopup(
      context: context,
      template: TemplateGeolocation,
    );
    popup.show(
        title: 'Call for pickup ?',
        content:
            '\nIf you need to contact BMC Mumbai for help regarding garbage collection,\n\nProceed to call the official BMC Helpline numbers.',
        actions: [
          popup.button(
            label: 'BMC Helpline No.',
            onPressed: () async {
              const number = '09930854717'; //Add 1916 BMC Helpline here
              bool? res = await FlutterPhoneDirectCaller.callNumber(number);
            },
          ),
        ]);
  }

  var getValue = 0;
  //Get real time values
  DatabaseReference ref = FirebaseDatabase.instance.refFromURL(
      "https://watchapp-e17ee-default-rtdb.asia-southeast1.firebasedatabase.app/");

  Widget getData() {
    if (true) {
      // Get the Stream
      Stream<DatabaseEvent> stream = ref.onValue;

      // Subscribe to the stream!
      stream.listen((DatabaseEvent event) {
        var realTimeValue = event.snapshot.child("Distance").value;
        var intValue = int.parse(realTimeValue.toString());
        //print("Internal = " + intValue.toString());

        setState(() {
          getValue = intValue;
        });
      });
    }
    return getCircular();
  }

  Widget getCircular() {
    //1st get real time value
    var percentagefilled = getValue; //0-100

    //2nd compare the value and returning correct colour
    if (percentagefilled <= 30) {
      return CircularPercentIndicator(
        radius: 200,
        lineWidth: 25,
        percent: percentagefilled / 100,
        animateFromLastPercent: true,
        //animation: true,
        center: new Text(
          percentagefilled.toString() + "%",
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        progressColor: Colors.greenAccent,
      );
    } else if (percentagefilled > 30 && percentagefilled <= 60) {
      return CircularPercentIndicator(
        radius: 200,
        lineWidth: 25,
        percent: percentagefilled / 100,
        animateFromLastPercent: true,
        //animation: true,
        center: new Text(
          percentagefilled.toString() + "%",
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        progressColor: Colors.yellow,
      );
    } else if (percentagefilled > 60 && percentagefilled <= 90) {
      return CircularPercentIndicator(
        radius: 200,
        lineWidth: 25,
        percent: percentagefilled / 100,
        animateFromLastPercent: true,
        //animation: true,
        center: new Text(
          percentagefilled.toString() + "%",
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
        percent: percentagefilled / 100,
        animateFromLastPercent: true,
        //animation: true,
        center: new Text(
          percentagefilled.toString() + "%",
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

  Widget instructions() {
    if (getValue == 0) {
      return Text("Plenty space left");
    } else if (getValue > 0 && getValue <= 60) {
      return Text("Garbage started occupying space");
    } else if (getValue > 60 && getValue <= 80) {
      return Text("Some space left");
    } else {
      return ElevatedButton(
          onPressed: handleGarbageCall, child: Text("Take Action"));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                getData(), //Get the correct circular progress bar color widget
                SizedBox(
                  height: 30,
                ),
                instructions(),
              ],
            ),
          ),
        ));
  }
}
