import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:geolocator/geolocator.dart';
import './repository.dart';
import  'models/position_model.dart';
import 'models/weather_model.dart';


class Bloc extends Object {

  final _repository = Repository();
  final _weatherFetcher = PublishSubject<WeatherModel>();

  Observable<WeatherModel> get weather => _weatherFetcher.stream;
  
  fetchWeather() async {
    WeatherModel weatherModel = await _repository.fetchWeather("52.386560", "1.671404");
    print(weatherModel);
    _weatherFetcher.sink.add(weatherModel);
  }




  final _speedController = BehaviorSubject<Position>();
  final _headingController = BehaviorSubject<String>();
  final _positionController = BehaviorSubject<PositionModel>();

  initPosition() {
      Stream<PositionModel> positionStream = _repository.getPositionStream();
      _positionController.stream.mergeWith([positionStream]);
    }


  Stream<Position> get speed => _speedController.stream;
  Stream<String> get heading => _headingController.stream;
  BehaviorSubject<PositionModel> get position => _positionController; // .stream? 


    // change data
  Function(Position) get changeSpeed => _speedController.sink.add;
  Function(String) get changeHeading => _headingController.sink.add;
  Function(PositionModel) get changePosition => _positionController.sink.add;

  





  void dispose() async {
    await _speedController?.drain();
    await _speedController?.close();
    await _headingController?.drain();
    await _headingController?.close();
    await _positionController?.drain();
    await _positionController?.close();
    await _weatherFetcher?.close();

  }

}