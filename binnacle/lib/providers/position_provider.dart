import 'dart:async';
import '../models/position_model.dart';

class PositionProvider {
  IPositionService _service;
  StreamController<PositionModel> _stream = StreamController();

  PositionProvider({IPositionService service}) {
    this._service = service;
    this._stream.addStream(this._service.positionStream.stream);
  }

  changeService(IPositionService service) async {
    await this._service.positionStream.close();
    _service = service;
    await this._stream.addStream(this._service.positionStream.stream);
  }

  StreamController<PositionModel> get position => this._stream;
}

abstract class IPositionService {
  StreamController<PositionModel> get positionStream;
}
