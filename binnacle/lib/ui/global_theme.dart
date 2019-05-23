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
    this._primaryColor = Colors.blue[600];
    this._windArrowColor = Colors.redAccent;
    this._boomColor = Colors.yellow[600];
    this._listAngleColor = Colors.red[700];
    this._backgroundColor = Colors.white10;
    this._infoPanelBackground = Colors.white10;
    this._bottomAppBarColor = Colors.white10;
    this._textTheme = new TextTheme(
      body1: new TextStyle(color: this._primaryColor, fontFamily: "Arial", fontWeight: FontWeight.bold, fontSize: 20),
      body2: new TextStyle(color: this._primaryColor, fontFamily: "Arial", fontSize: 50, fontWeight: FontWeight.bold),
      headline: new TextStyle(color: this._primaryColor, fontFamily: "Arial", fontSize: 50, fontWeight: FontWeight.bold),
      title: new TextStyle(color: this._primaryColor, fontFamily: "Arial", fontSize: 120, fontWeight: FontWeight.bold),
    );
  }
  toThemeData() {
    return new ThemeData(
        brightness: Brightness.light,
        );
  }
}
