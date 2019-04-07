import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:geolocator/geolocator.dart';
import './repository.dart';
import 'models/position_model.dart';
import 'providers/wind_provider.dart';


class Bloc extends Object {

  Repository _repository;

  final _speedController = BehaviorSubject<Position>();
  final _headingController = BehaviorSubject<String>();
  final _positionController = BehaviorSubject<PositionModel>();
  final _windContoller = PublishSubject<WindModel>();

  Bloc() {
    // * This line is just a dummy position -- delete it when Position works
    _positionController.add(PositionModel(83.4, 121.12));
    this._repository = Repository(_positionController);
    _windContoller.addStream(_repository.getWindStream());

  }


  Stream<WindModel> get wind => _windContoller;
  
  
  
  //Todo This should be moved to Bloc() constructor. 
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
    await _windContoller?.drain();
    await _windContoller?.close();

  }

}