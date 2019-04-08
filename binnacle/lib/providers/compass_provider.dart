import 'dart:async';
import '../models/compass_model.dart';


class CompassProvider {
  ICompassService _service;
  StreamController<CompassModel> _stream = StreamController();

  CompassProvider({ICompassService service}){
    this._service = service;
    this._stream.addStream(this._service.compassStream.stream);
  }
  changeService(ICompassService service)  async {
    
    await this._service.compassStream.close();
    this._service = service;
    await this._stream.addStream(this._service.compassStream.stream);

  }

  StreamController<CompassModel> get compass => this._stream;

}
abstract class ICompassService {
  StreamController <CompassModel> get compassStream;

}

