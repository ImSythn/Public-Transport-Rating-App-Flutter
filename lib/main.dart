import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    )); //=> Shortcut for running one single line of code.

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
  TextEditingController crating = new TextEditingController(text: '1');
  int rating = 1;
  void addData() {
    var url =
        "http://192.168.178.73/se7/app%20database%20connection/adddata.php";
    http.post(url,
        body: {"message": cmessage.text, "rating": rating.toString()});
  }

  List<Color> buttonColor = [Colors.black12, Colors.black, Colors.black12];

  void updateButtons() {
    buttonColor[0] = Colors.black12;
    buttonColor[1] = Colors.black12;
    buttonColor[2] = Colors.black12;
    buttonColor[rating] = Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              iconSize: 100,
              icon: Icon(
                Icons.mood_bad,
                size: 100,
                color: buttonColor[0],
              ),
              onPressed: () {
                setState(() {
                  rating = 0;
                  updateButtons();
                });
              }),
          IconButton(
              iconSize: 100,
              icon: Icon(
                Icons.sentiment_neutral,
                size: 100,
                color: buttonColor[1],
              ),
              onPressed: () {
                setState(() {
                  rating = 1;
                  updateButtons();
                });
              }),
          IconButton(
              iconSize: 100,
              icon: Icon(
                Icons.mood,
                size: 100,
                color: buttonColor[2],
              ),
              onPressed: () {
                setState(() {
                  rating = 2;
                  updateButtons();
                });
              })
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          CameraPicker(),
          IconButton(
              iconSize: 25,
              icon: Icon(
                Icons.send,
                size: 25,
              ),
              onPressed: () {
                addData();
              })
        ],
      ),
      TextField(
        controller: cmessage,
        decoration: InputDecoration(hintText: "Type a message"),
      ),
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
