import 'package:watch_app/admin/predictionView.dart';
import 'package:watch_app/chat/home_screen.dart';
import 'package:watch_app/pages/createReportOptions.dart';
import 'package:watch_app/pages/mapview.dart';
import 'package:watch_app/pages/predictions.dart';
import 'package:watch_app/pages/result.dart';
import 'package:watch_app/services/locationinfo.dart';
import 'package:watch_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'garbageTracking.dart';
import 'package:watch_app/services/showNotification.dart';

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

  handleEmergency() {
    final popup = BeautifulPopup(
      context: context,
      template: TemplateGeolocation,
    );
    popup.show(
      title: 'Emergency Dial',
      content:
          '\nAre you in danger and require immediate help? \n\nProceed to call Indian Emergency Helpline Numbers. Never misuse the Emergency Helplines.',
      actions: [
        popup.button(
          label: 'POLICE',
          onPressed: () async {
            const number = '100'; //Add 100 POLICE Emergency Helpline here
            bool? res = await FlutterPhoneDirectCaller.callNumber(number);
          },
        ),
        popup.button(
          label: 'FIRE',
          onPressed: () async {
            const number = '101'; //Add 101 FIRE Emergency Helpline here
            bool? res = await FlutterPhoneDirectCaller.callNumber(number);
          },
        ),
        popup.button(
          label: 'AMBULANCE',
          onPressed: () async {
            const number = '102'; //Add 102 Ambulance Emergency Helpline here
            bool? res = await FlutterPhoneDirectCaller.callNumber(number);
          },
        ),
      ],
    );
  }

  goToMap() {}

  Widget retButton(text, textColor, color, from) {
    return Padding(
      padding: from == "report now"
          ? EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0)
          : EdgeInsets.all(10.0),
      child: Container(
        height: 65.0,
        child: InkWell(
          onTap: () {
            switch (from) {
              case "report now":
                handleReport();
                break;

              case "pred":
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PredictionsUser()));
                break;

              case "status":
                getCurrentLocation().then((address) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShowResult(address.subLocality)));
                });

                break;

              case "chat":
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
                break;

              case "emergency":
                handleEmergency();
                break;

              case "garbage":
                //Add garbage tracking page here
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => GarbageTracking()));
                break;
            }
          },
          child: Material(
            borderRadius: BorderRadius.circular(20.0),
            shadowColor: Colors.black,
            color: color,
            elevation: 7.0,
            child: Center(
              child: Text(
                "$text",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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
    //FireNotif.fireNotif(); Call once user is signed in
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("The Neighbourhood Watch App"),
      ),
      drawer: CustomDrawer(context),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Dashboard",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 48,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                        child: Text(
                          "Your neighbourhood's safety, now in your hands. Stay Alert!",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 24,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
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
                                Color.fromARGB(255, 1, 76, 180), "report now"),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(0.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //Fetching Report options
                            retButton("Predictions", Colors.white,
                                Color.fromARGB(255, 1, 76, 180), "pred"),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(0.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //Fetching Report options
                            retButton("In My Vicinity", Colors.white,
                                Color.fromARGB(255, 1, 76, 180), "status"),
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
                                Color.fromARGB(255, 1, 76, 180), "chat"),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(0.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //Fetching Report options
                            retButton("Garbage Tracking", Colors.white,
                                Color.fromARGB(255, 1, 76, 180), "garbage"),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(0.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //Fetching Report options
                            retButton(
                              "Emergency",
                              Colors.white,
                              Colors.red,
                              "emergency",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
