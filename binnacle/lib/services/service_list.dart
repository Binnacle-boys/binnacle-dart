import 'package:sos/models/service_data.dart';
import 'package:sos/services/service_wrapper_interface.dart';

class ServiceList {

  final String type;
  List <ServiceWrapper> _list; 
  ServiceList(this.type, this._list);
  
  List<ServiceWrapper> get serviceList => _list;
  
  ServiceWrapper service(ServiceData data) => _list.firstWhere((wrapper) => 
    identical(wrapper.serviceData, data));

  ServiceWrapper get defaultService => _list.firstWhere((wrapper) => 
    wrapper.isDefault == true);

  ServiceWrapper nextPriority(ServiceData serviceData) => 
    _list.firstWhere((wrapper) => 
      ((wrapper.serviceData.priority > serviceData.priority)  
      && !identical(serviceData, wrapper.serviceData)));

  add(ServiceWrapper serviceWrapper) {
    _list.add(serviceWrapper);
  }
  remove(ServiceWrapper serviceWrapper) {
    _list.remove(serviceWrapper);
  }

}