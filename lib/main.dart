import 'package:flutter/material.dart';

void main() => runApp(HomePage()); //=> Shortcut for running one single line of code.

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Rate My Vehicle'),
          backgroundColor: Colors.lightBlue
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              VehicleID(),
              SizedBox(height: 70),
              QRScanner(),
              SizedBox(height: 70),
              RatingButtons(),
              SizedBox(height: 70),
              MessageField()
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

class _VehicleIDState extends State<VehicleID>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(Icons.train, size: 200, color: Colors.lightBlue,),
        Text('Vehicle ID: ')
      ],
    );
  }
}

class QRScanner extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Icon(Icons.camera_alt,size: 50, color: Colors.black),
        Text('Scan your vehicle')
      ],
    );
  }
}

class RatingButtons extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _RatingButtons();
  }
}

class _RatingButtons extends State<RatingButtons> {
  List<Color> _buttonColor = [Colors.black12, Colors.black12, Colors.black12];
  List<bool> pressed = [false, false, false];
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          iconSize: 100,
          icon: Icon(Icons.mood_bad, size: 100, color: _buttonColor[0],),
          onPressed: (){
            setState((){
              if(pressed[0] == false){
                pressed[0] = true;
                pressed[1] = false;
                pressed[2] = false;
              }
              pressed[0] == true ? _buttonColor[0] = Colors.black : _buttonColor[0] = Colors.black12;
              pressed[1] == true ? _buttonColor[1] = Colors.black : _buttonColor[1] = Colors.black12;
              pressed[2] == true ? _buttonColor[2] = Colors.black : _buttonColor[2] = Colors.black12;
            });
          }  
        ),
        IconButton(
          iconSize: 100,
          icon: Icon(Icons.sentiment_neutral, size: 100, color: _buttonColor[1],),
          onPressed: (){
            setState((){
              if(pressed[1] == false){
                pressed[0] = false;
                pressed[1] = true;
                pressed[2] = false;
              }
              pressed[0] == true ? _buttonColor[0] = Colors.black : _buttonColor[0] = Colors.black12;
              pressed[1] == true ? _buttonColor[1] = Colors.black : _buttonColor[1] = Colors.black12;
              pressed[2] == true ? _buttonColor[2] = Colors.black : _buttonColor[2] = Colors.black12;
            });
          }  
        ),
        IconButton(
          iconSize: 100,
          icon: Icon(Icons.mood, size: 100, color: _buttonColor[2],),
          onPressed: (){
            setState((){
              if(pressed[2] == false){
                pressed[0] = false;
                pressed[1] = false;
                pressed[2] = true;
              }
              pressed[0] == true ? _buttonColor[0] = Colors.black : _buttonColor[0] = Colors.black12;
              pressed[1] == true ? _buttonColor[1] = Colors.black : _buttonColor[1] = Colors.black12;
              pressed[2] == true ? _buttonColor[2] = Colors.black : _buttonColor[2] = Colors.black12;
            });
          }  
        )
      ],
    );
  }
}

class MessageField extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return TextField();
  }
}


