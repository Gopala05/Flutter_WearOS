import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  void requestPermission() async {
    var status = await Permission.sms.request();
    if (status.isGranted) {
      // Permission granted, you can now send the SMS.
      _sendSMS();
    } else {
      // Handle the case where the user denies permission.
    }
  }

  void _sendSMS() async {
    List<String> Sender = ["+916360318731"];
    await sendSMS(message: "Logged IN", recipients: Sender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wear OS SMS Sender'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                requestPermission();
              },
              child: Text("Send SMS"),
            ),
          ],
        ),
      ),
    );
  }
}
