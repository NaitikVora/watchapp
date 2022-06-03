import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PredictionsUser extends StatefulWidget {
  @override
  _PredictionsUser createState() => _PredictionsUser();
}

class _PredictionsUser extends State<PredictionsUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Crime Prediction'),
        ),
        body: const WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: 'https://resilient-marigold-c833fa.netlify.app/',
        ));
  }
}
