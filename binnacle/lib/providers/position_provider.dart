import 'dart:async';
import '../models/position_model.dart';
import '../models/provider_data.dart';

class PositionProvider {
  
  IPositionService _service;
  StreamController<PositionModel> _stream = StreamController();
  StreamController _providerData = StreamController();
  

  PositionProvider({IPositionService service}){
    this._service = service;

    this._stream.addStream(this._service.positionStream.stream);
    _providerData.sink.add(ProviderData('position', 'manual'));

  }




  changeService(IPositionService service)  async {
 
    await this._service.positionStream.close();
    _service = service;
    await this._stream.addStream(this._service.positionStream.stream);

  }

  StreamController<PositionModel> get position => this._stream;
  StreamController get providerData => _providerData;

}
abstract class IPositionService {
  StreamController <PositionModel> get positionStream;

}

