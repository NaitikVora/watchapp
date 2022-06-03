import 'package:watch_app/chat/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_app/services/getlocation.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:convert';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:watch_app/services/showNotification.dart';

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
              const number = '1916'; //Add 1916 BMC Helpline here
              bool? res = await FlutterPhoneDirectCaller.callNumber(number);
            },
          ),
        ]);
  }

  static var getValue = 0;
  //Get real time values
  DatabaseReference ref = FirebaseDatabase.instance.refFromURL(
      "https://watchapp-e17ee-default-rtdb.asia-southeast1.firebasedatabase.app/");

  Widget getData() {
    if (true) {
      // Get the Stream
      Stream<DatabaseEvent> stream = ref.onValue;

      // Subscribe to the stream!
      stream.listen((DatabaseEvent event) {
        var realTimeValue = event.snapshot.child("-N2R83Llz6l4KuG68boq").value;
        var intValue = int.parse(realTimeValue.toString());
        //print("Internal = " + intValue.toString());

        setState(() {
          getValue = intValue;
        });
      });
    }
    return Text(getValue.toString());
  }

  //Notif Fire counter
  static var notiFireCounter = 0;
  //static var temp = 0;

  Widget getCircular() {
    //1st get real time value
    var percentagefilled = getValue; //0-100
    //Fire here
    FireNotif.fireNotif();
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
      /* //First Fire
      if (notiFireCounter == 0) {
        fireNotif();
        notiFireCounter++;
        temp = percentagefilled;
        //ADD : If per% changed, only then fire again
      } else if (notiFireCounter > 0 && percentagefilled != temp) {
        fireNotif();
        notiFireCounter++;
      }*/
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
    } else if (getValue > 60 && getValue <= 79) {
      return Text("Some space left");
    } else {
      return ElevatedButton(
          onPressed: handleGarbageCall, child: Text("Take Action"));
    }
  }
  //Implementing within class not accessible outside in main, so trying in new class
  /*static void fireNotif() {
    var per = getValue;
    if (notiFireCounter == 0) {
      if (per > 79) {
        String bodyval = "Garbage level is at " + per.toString() + "% capacity";
        ShowNotification.showNotification(title: 'Take Action!', body: bodyval);
        temp = per;
        notiFireCounter++;
      }
    } else if (notiFireCounter > 0 && temp != per) {
      if (per > 79) {
        String bodyval = "Garbage level is at " + per.toString() + "% capacity";
        ShowNotification.showNotification(title: 'Take Action!', body: bodyval);
        temp = per;
        notiFireCounter++;
      }
    }
  }*/

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
                instructions(), //Display addn info
              ],
            ),
          ),
        ));
  }
}

//Currently only works properly if garbage module is opened, not on other pages.
class FireNotif extends _GarbageTracking {
  //Var
  static var temp = 0;
  //Method
  static void fireNotif() {
    var per = _GarbageTracking.getValue;
    if (_GarbageTracking.notiFireCounter == 0) {
      if (per > 79) {
        String bodyval = "Garbage level is at " + per.toString() + "% capacity";
        ShowNotification.showNotification(title: 'Take Action!', body: bodyval);
        temp = per;
        _GarbageTracking.notiFireCounter++;
      }
    } else if (_GarbageTracking.notiFireCounter > 0 && temp != per) {
      if (per > 79) {
        String bodyval = "Garbage level is at " + per.toString() + "% capacity";
        ShowNotification.showNotification(title: 'Take Action!', body: bodyval);
        temp = per;
        _GarbageTracking.notiFireCounter++;
      }
    }
  }
}
