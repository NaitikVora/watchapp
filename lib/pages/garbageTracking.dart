import 'package:flutter/material.dart';

class GarbageTracking extends StatefulWidget {
  @override
  _GarbageTracking createState() => _GarbageTracking();
}

class _GarbageTracking extends State<GarbageTracking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("Garbage Tracking"),
    ));
  }
}
