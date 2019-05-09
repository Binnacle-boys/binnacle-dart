import '../enums.dart';
class ProviderData {
  /*
  * Type indicates what type of provider it is
  * compass, wind, position, list angle
  * Model is either manual or auto indicating how the provider 
  * switches on error
  */
  //final String _type;
  ProviderType _type;

  String _mode;

  ProviderData(this._type, this._mode);

  set mode(String newMode) => this._mode = newMode;
  String get mode => this._mode;
  ProviderType get type => this._type;
  
}
