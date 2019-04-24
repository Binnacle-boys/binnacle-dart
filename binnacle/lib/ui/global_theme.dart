import 'package:flutter/material.dart';
//TODO extend theme data instead of Object
class GlobalTheme extends Object {
  ThemeData get() {
    return new ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.yellow[100],
      accentColor: Colors.deepOrange,
      backgroundColor: Colors.grey[850],
      secondaryHeaderColor: Colors.grey[900],
      bottomAppBarColor: Colors.grey[900],
      textTheme: new TextTheme(
        body1: new TextStyle(
            color: Colors.amber[100],
            fontFamily: "Arial",
            fontWeight: FontWeight.bold,
            fontSize: 20),
        body2: new TextStyle(
            color: Colors.amber[100],
            fontFamily: "Arial",
            fontSize: 50,
            fontWeight: FontWeight.bold),
        headline: new TextStyle(
            color: Colors.amber[100],
            fontFamily: "Arial",
            fontSize: 65,
            fontWeight: FontWeight.bold),
        title: new TextStyle(
            color: Colors.amber[100],
            fontFamily: "Arial",
            fontSize: 120,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
