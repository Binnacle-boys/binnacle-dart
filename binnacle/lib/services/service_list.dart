import 'package:sos/models/service_data.dart';
import 'package:sos/services/service_wrapper_interface.dart';
import '../enums.dart';

class ServiceList {
  final ProviderType type;
  List<ServiceWrapper> _list;
  ServiceList(this.type, this._list);

  List<ServiceWrapper> get serviceList => _list;

  // NOTE: This is O(N) operation, N=number of elements in list
  ServiceWrapper get defaultService => _list.firstWhere((wrapper) => wrapper.isDefault == true);

  ServiceWrapper service(ServiceData data) => _list.firstWhere((wrapper) => 
    identical(wrapper.serviceData, data));
  

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


