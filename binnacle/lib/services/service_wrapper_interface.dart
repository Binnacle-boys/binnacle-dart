import '../models/service_data.dart';

abstract class ServiceWrapper {

  //! dynamic get service should be Service get service
  //! but there is no Service type
  //! All services should implement a new Service interface
  dynamic get service;
  ServiceData get serviceData;
  bool get isDefault;
}