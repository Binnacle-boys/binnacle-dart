import 'dart:async';
import '../models/compass_model.dart';


class CompassProvider {
  ICompassService _service;
  StreamController<CompassModel> _stream = StreamController();

  CompassProvider({ICompassService service}){
    this._service = service;
    print(this._service.runtimeType);
    this._stream.addStream(this._service.compassStream);
  }
  changeService(ICompassService service)  async {
    
    await this._service.compassStream.drain();
    this._service = service;
    await this._stream.addStream(this._service.compassStream);

  }

  StreamController<CompassModel> get compass => this._stream;

}
abstract class ICompassService {
  Stream <CompassModel> get compassStream;

}

