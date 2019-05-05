import 'package:flutter/material.dart';

//TODO extend theme data instead of Object
class GlobalTheme extends Object {
  Brightness _brightness;
  Color _primaryColor;
  Color _windArrowColor;
  Color _boomColor;
  Color _listAngleColor;
  Color _backgroundColor;
  Color _infoPanelBackground;
  Color _bottomAppBarColor;
  TextTheme _textTheme;

  Brightness get brightness => _brightness;
  Color get primaryColor => _primaryColor;
  Color get windArrowColor => _windArrowColor;
  Color get boomColor => _boomColor;
  Color get listAngleColor => _listAngleColor;
  Color get backgroundColor => _backgroundColor;
  Color get infoPanelBackground => _infoPanelBackground;
  Color get bottomAppBarColor => _bottomAppBarColor;
  TextTheme get textTheme => _textTheme;

  GlobalTheme() {
    this._brightness = Brightness.dark;
    this._primaryColor = Colors.yellow[100];
    this._windArrowColor = Colors.teal[500];
    this._boomColor = Colors.deepPurple[300];
    this._listAngleColor = Colors.deepPurple[300];

    this._backgroundColor = Colors.grey[850];
    this._infoPanelBackground = Colors.grey[900];
    this._bottomAppBarColor = Colors.grey[900];
    this._textTheme = new TextTheme(
      body1: new TextStyle(color: this._primaryColor, fontFamily: "Arial", fontWeight: FontWeight.bold, fontSize: 20),
      body2: new TextStyle(color: this._primaryColor, fontFamily: "Arial", fontSize: 50, fontWeight: FontWeight.bold),
      headline: new TextStyle(color: this._primaryColor, fontFamily: "Arial", fontSize: 65, fontWeight: FontWeight.bold),
      title: new TextStyle(color: this._primaryColor, fontFamily: "Arial", fontSize: 120, fontWeight: FontWeight.bold),
    );
  }
  toThemeData() {
    return new ThemeData(
        brightness: this._brightness,
        backgroundColor: this._backgroundColor,
        primaryColor: this._primaryColor,
        bottomAppBarColor: this._infoPanelBackground,
        textTheme: this._textTheme);
  }
}
