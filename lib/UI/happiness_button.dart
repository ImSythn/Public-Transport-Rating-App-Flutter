import 'package:flutter/material.dart';

class HappinessButton extends StatelessWidget{
  String happiness;
  bool clicked;

  HappinessButton(this.happiness, this.clicked);

  @override
  Widget build(BuildContext context) {
    if(happiness == 'D:'){
      return InkWell(
        child: Icon(Icons.mood_bad,
          size: 100.0,
          color: Colors.black)
      );
    }
    if(happiness == ':|'){
      return InkWell(
          child: Icon(Icons.face,
            size: 100.0,
            color: Colors.black)
      );
    }
    if(happiness == ':D'){
      return InkWell(
          child: Icon(Icons.mood,
            size: 100.0,
            color: Colors.black)
      );
    }
    return null;
  }
}