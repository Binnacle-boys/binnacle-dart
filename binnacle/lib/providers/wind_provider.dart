import 'dart:async';
import '../models/wind_model.dart';

class WindProvider {

    IWindService _service;
    StreamController<WindModel> _stream = StreamController();
    
    WindProvider({IWindService service}){
      this._service = service;
      this._stream.addStream(this._service.windStream.stream);

    }
    changeService(IWindService service)  async {

    await this._service.windStream.close();
    
    this._service = service;
    await this._stream.addStream(this._service.windStream.stream);

  }
    StreamController<WindModel> get wind => _stream;


}
abstract class IWindService {
  StreamController <WindModel> get windStream;

}

