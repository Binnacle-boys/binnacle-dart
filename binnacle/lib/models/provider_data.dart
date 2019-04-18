
class ProviderData {
  final String _type;
  String _mode;

  ProviderData(this._type, this._mode);

  set mode(String newMode) => this._mode = newMode;
  String get mode => this._mode;
  String get type => this._type;
  
}
