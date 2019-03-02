import 'package:flutter/material.dart';

import 'UI/happiness_button.dart';

import 'CustomClippers/custom_shape_clipper.dart';

void main() {
  runApp(new MaterialApp(
    home: new HomePage()
  ));
}

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          HomeScreenArt(),
          HomeScreenButtons()
        ],
      ),
    );
  }
}


class HomeScreenButtons extends StatefulWidget{
  @override
  _HomeScreenButtonsState createState() => _HomeScreenButtonsState();
}

class _HomeScreenButtonsState extends State<HomeScreenButtons>{
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new HappinessButton('D:', false),
        new HappinessButton(':|', false),
        new HappinessButton(':D', false),
      ],
    );
  }
}


class HomeScreenArt extends StatefulWidget{
  @override
  _HomeScreenArtState createState() => _HomeScreenArtState();
}

class _HomeScreenArtState extends State<HomeScreenArt>{
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            alignment: AlignmentDirectional.bottomStart,
            height: 500.0,
            color: Colors.lightBlue,
          ),
        ),
      ],
    );
  }
}