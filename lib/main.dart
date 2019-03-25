import 'package:flutter/material.dart';
//import 'dart:async';
import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() =>
    runApp(HomePage()); //=> Shortcut for running one single line of code.

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('Rate My Vehicle'), backgroundColor: Colors.lightBlue),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              VehicleID(),
              SizedBox(height: 70),
              QRScanner(),
              SizedBox(height: 70),
              ReviewData()
            ],
          ),
        ),
      ),
    );
  }
}

class VehicleID extends StatefulWidget {
  @override
  _VehicleIDState createState() => _VehicleIDState();
}

class _VehicleIDState extends State<VehicleID> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(
          Icons.train,
          size: 200,
          color: Colors.lightBlue,
        ),
        Text('Vehicle ID: ')
      ],
    );
  }
}

class QRScanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(Icons.camera_alt, size: 50, color: Colors.black),
        Text('Scan your vehicle')
      ],
    );
  }
}

class ReviewData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReviewData();
}

class _ReviewData extends State<ReviewData> {
  TextEditingController cmessage = new TextEditingController();
  TextEditingController crating = new TextEditingController();
  void addData() {
    var url = "http://localhost/se7/app%20database%20connection/adddata.php";
    http.post(url, body: {
      "message": cmessage.text,
      "mobile": crating.text,
    });
  }

  IconButton buttonBad() {
    return IconButton(
        iconSize: 100,
        icon: Icon(
          Icons.mood_bad,
          size: 100,
          color: Colors.black12,
        ),
        onPressed: () {
          setState(() {
            crating.text = '1';
            updateButtons();
          });
        });
  }

  IconButton buttonNeutral() {
    return IconButton(
        iconSize: 100,
        icon: Icon(
          Icons.sentiment_neutral,
          size: 100,
          color: Colors.black12,
        ),
        onPressed: () {
          setState(() {
            crating.text = '2';
            updateButtons();
          });
        });
  }

  IconButton buttonGood() {
    return IconButton(
        iconSize: 100,
        icon: Icon(
          Icons.mood,
          size: 100,
          color: Colors.black12,
        ),
        onPressed: () {
          setState(() {
            crating.text = '3';
            updateButtons();
          });
        });
  }

  void updateButtons() {
    if (crating.text == '1') {}
    if (crating.text == '2') {}
    if (crating.text == '3') {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[buttonBad(), buttonNeutral(), buttonGood()],
      ),
      Row(
        children: <Widget>[
          IconButton(
              iconSize: 25,
              icon: Icon(
                Icons.send,
                size: 25,
              ),
              onPressed: () {
                setState(() {
                  addData();
                });
              }),
              CameraPicker()
        ],
      ),
      TextField(),
    ]);
  }
}

class CameraPicker extends StatefulWidget {
  @override
  _CameraPicker createState() => _CameraPicker();
}

class _CameraPicker extends State<CameraPicker> {
  File image;
  picker() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.camera_alt,
      ),
      onPressed: picker,
    );
  }
}
  