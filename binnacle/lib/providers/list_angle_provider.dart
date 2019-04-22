import 'dart:async';
import 'package:sos/models/list_angle_model.dart';

class ListAngleProvider {
  IListAngleService _service;
  StreamController<ListAngleModel> _stream = StreamController();

  ListAngleProvider({IListAngleService service}) {
    this._service = service;
    print(this._service.runtimeType);
    this._stream.addStream(this._service.listAngleStream.asBroadcastStream());
  }
  changeService(IListAngleService service) async {
    await this._service.listAngleStream.drain();
    this._service = service;
    await this._stream.addStream(this._service.listAngleStream);
  }

  StreamController<ListAngleModel> get listAngle => this._stream;
}

abstract class IListAngleService {
  Stream<ListAngleModel> get listAngleStream;
}
