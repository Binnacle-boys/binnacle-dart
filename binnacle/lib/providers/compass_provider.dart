import 'dart:async';
import '../models/compass_model.dart';
import '../models/compass_service_interface.dart';

class ProviderData {
  final String provides;

  ProviderData(this.provides);
}


class CompassProvider {
  ICompassService _service;
  StreamController<CompassModel> _stream = StreamController();
  final ProviderData providerData = ProviderData('compass');

  CompassProvider({ICompassService service}){
    this._service = service;
    this._stream.addStream(this._service.compassStream.stream);
  }
  changeService(ICompassService service)  async {
    await this._service.dispose();
    // await this._service.compassStream.stream.drain();
    // await this._service.compassStream.close();

    this._service = service;
    
    await this._stream.addStream(this._service.compassStream.stream);

  }

  StreamController<CompassModel> get compass => this._stream;

}
