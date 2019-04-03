import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    )); //=> Shortcut for running one single line of code.

MediaQueryData
    queryData; // Used to get the devicePixelRatio for scaling purpeses.

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    double scale = MediaQuery.of(context).size.height*1.005/500;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Rate My Vehicle'),
          backgroundColor: Colors.lightBlue,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20 * scale),
              VehicleID(),
              SizedBox(height: 20 * scale),
              QRScanner(),
              SizedBox(height: 40 * scale),
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
    queryData = MediaQuery.of(context);
    double scale = MediaQuery.of(context).size.height*1.005/500;
    return Column(
      children: <Widget>[
        Icon(
          Icons.train,
          size: 130 * scale,
          color: Colors.lightBlue,
        ),
      ],
    );
  }
}

class QRScanner extends StatefulWidget {
  @override
  _QRScanner createState() => _QRScanner();
}

class _QRScanner extends State<QRScanner> {
  scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        cvehicleid.text = qrResult;
      });
    } on PlatformException {
      setState(() {
        cvehicleid.text = '';
      });
    } on FormatException {
      setState(() {
        cvehicleid.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    double scale = MediaQuery.of(context).size.height*1.005/500;
    return Column(
      children: <Widget>[
        IconButton(
          iconSize: 50 * scale,
          icon: Icon(Icons.center_focus_weak),
          onPressed: scanQR,
        ),
        SizedBox(
            height: 10 * scale,
            child: FittedBox(
                child: Text(
              'Scan vehicle QR-code',
            )))
      ],
    );
  }
}

class ReviewData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReviewData();
}

TextEditingController cvehicleid = new TextEditingController(text: '');

class _ReviewData extends State<ReviewData> {
  TextEditingController cmessage = new TextEditingController(text: '');
  int rating = 1;
  Map<String, double> currentLocation = <String, double>{};
  Location location = new Location();

  void addData() async {
    try {
      currentLocation = await location.getLocation();
    } on PlatformException {
      currentLocation =  null;
    }
    var url =
        "http://10.0.2.2/SE7/public/review"; //10.0.2.2    Special alias to your host loopback interface for android use.
    http.post(url, body: {
      "message": cmessage.text,
      "rating": rating.toString(),
      "vehicle_id": cvehicleid.text,
      "img_path": reviewImage,
      "lng": currentLocation["longitude"].toString(),
      "lat": currentLocation["latitude"].toString()
    });
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
    queryData = MediaQuery.of(context);
    double scale = MediaQuery.of(context).size.height*1.005/500;
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              iconSize: 60 * scale,
              icon: Icon(
                Icons.mood_bad,
                size: 60 * scale,
                color: buttonColor[0],
              ),
              onPressed: () {
                setState(() {
                  rating = 0;
                  updateButtons();
                });
              }),
          IconButton(
              iconSize: 60 * scale,
              icon: Icon(
                Icons.sentiment_neutral,
                size: 60 * scale,
                color: buttonColor[1],
              ),
              onPressed: () {
                setState(() {
                  rating = 1;
                  updateButtons();
                });
              }),
          IconButton(
              iconSize: 60 * scale,
              icon: Icon(
                Icons.mood,
                size: 60 * scale,
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
      SizedBox(height: 13 * scale),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              width: 70 * scale,
              child: TextField(
                controller: cvehicleid,
                decoration: InputDecoration(hintText: "Vehicle ID"),
                keyboardType: TextInputType.number,
              )),
          CameraPicker(),
          IconButton(
              iconSize: 15 * scale,
              icon: Icon(
                Icons.send,
                size: 15 * scale,
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

String reviewImage = '';

class CameraPicker extends StatefulWidget {
  @override
  _CameraPicker createState() => _CameraPicker();
}

class _CameraPicker extends State<CameraPicker> {
  picker() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      reviewImage = base64Encode(img.readAsBytesSync());
    }
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    double scale = MediaQuery.of(context).size.height*1.005/500;
    return IconButton(
      iconSize: 15 * scale,
      icon: Icon(
        Icons.camera_alt,
        size: 15 * scale,
      ),
      onPressed: picker,
    );
  }
}
