import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:validators/validators.dart';

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
    double scale = MediaQuery.of(context).size.height / 500;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Rate My Vehicle'),
          backgroundColor: Colors.lightBlue,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50 * scale - (50 / scale)),
              VehicleID(),
              SizedBox(height: 50 * scale - (50 / scale)),
              QRScanner(),
              SizedBox(height: 50 * scale - (50 / scale)),
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
    double scale = MediaQuery.of(context).size.height / 500;
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
    // async because the QR scanning can happen at any moment
    try {
      String qrResult =
          await BarcodeScanner.scan(); //wait for result from qr scanner
      setState(() {
        if (isNumeric(qrResult)) {
          // check if it's not some random QR code
          cvehicleid.text = qrResult; //fills in the vehicle id section
        } else {
          Dialog dialogs = new Dialog();
          dialogs.information(context,
              "Invalid QR code"); // if it was a bad QR code it will pop up saying Invalid QR Code
        }
      });
    } on PlatformException {
      // exception if the QR read went into error for some reason
      setState(() {
        cvehicleid.text = '';
      });
    } on FormatException {
      // exception if you back out of the QR scanner
      setState(() {
        cvehicleid.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    double scale = MediaQuery.of(context).size.height / 500;
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
  Map<String,double> currentLocation = new Map();
  Location location = new Location();
  String error;

  void addData() async {
    try {
      currentLocation =
          await location.getLocation(); // wait for current location
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }
      currentLocation = null;
    }
    var url =
        "http://10.0.2.2/SE7/public/review"; //10.0.2.2    Special alias to your host loopback interface for android use.
    final response = await http.post(url, body: {
      "message": cmessage.text,
      "rating": rating.toString(),
      "vehicle_id": cvehicleid.text,
      "img_path": reviewImage,
      "lng": currentLocation['longitude'].toString(),
      "lat": currentLocation['latitude'].toString()
    });
    String status = json.decode(response.body);
    if (status == 'Error: Wrong vehicle ID') {
      Dialog dialogs = new Dialog();
      dialogs.information(context, status);
    } else if (status == 'Thank you for your review') {
      Dialog dialogs = new Dialog();
      dialogs.information(context, status);
      emptyReview();
    }
  }

  void emptyReview() {
    setState(() {
      cmessage.text = '';
      cvehicleid.text = '';
      reviewImage = '';
      rating = 1;
      updateButtons();
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
    double scale = MediaQuery.of(context).size.height / 500;
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              iconSize: 70 * scale,
              icon: Icon(
                Icons.mood_bad,
                size: 70 * scale,
                color: buttonColor[0],
              ),
              onPressed: () {
                setState(() {
                  rating = 0;
                  updateButtons();
                });
              }),
          IconButton(
              iconSize: 70 * scale,
              icon: Icon(
                Icons.sentiment_neutral,
                size: 70 * scale,
                color: buttonColor[1],
              ),
              onPressed: () {
                setState(() {
                  rating = 1;
                  updateButtons();
                });
              }),
          IconButton(
              iconSize: 70 * scale,
              icon: Icon(
                Icons.mood,
                size: 70 * scale,
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
      SizedBox(height: 30 * scale - (30 / scale)),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              width: 120 * scale - (120 / scale),
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
    // async because it can happen at any moment
    File img = await ImagePicker.pickImage(
        source: ImageSource
            .camera); //wait for the camera to deliver a picture, put it in a variable.
    if (img != null) {
      // if you back out of the camera app we don't want something to be encoded
      reviewImage = base64Encode(
          img.readAsBytesSync()); //create a string out of the image
    }
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    double scale = MediaQuery.of(context).size.height / 500;
    return IconButton(
      // button to press on screen
      iconSize: 15 * scale,
      icon: Icon(
        Icons.camera_alt,
        size: 15 * scale,
      ),
      onPressed: picker,
    );
  }
}

class Dialog {
  information(BuildContext context, String title) {
    //Making the class like this so we can use this code for multiple types of popups
    return showDialog(
        // sets it so whatever comes next will be above the current application
        context: context,
        barrierDismissible:
            true, // Allows popup to be closed by clicking anywhere on the screen
        builder: (BuildContext context) {
          return AlertDialog(
            //actual alert popup
            title: Text(title), //What the alert says
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context), //closes popup on press
                child: Text("Ok"),
              )
            ],
          );
        });
  }
}
