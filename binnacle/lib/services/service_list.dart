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

  //TODO casey this errors out (assertion error) when I try to change to the mock compass (--Daniel)
  ServiceWrapper service(ServiceData serviceData) {
    _list.firstWhere((wrapper) {
      identical(serviceData, wrapper.serviceData);
    });
  }

  ServiceWrapper nextPriority(ServiceData serviceData) {
    _list.firstWhere((serviceWrapper) {
      return (_isPriority(serviceData, serviceWrapper));
    });
  }

  add(ServiceWrapper serviceWrapper) {
    _list.add(serviceWrapper);
  }

  remove(ServiceWrapper serviceWrapper) {
    _list.remove(serviceWrapper);
  }
}

//TODO what is this?
/// Compares [serviceData] to [serviceWrapper] and returns
/// true if [serviceWrapper] should be prioritized
bool _isPriority(ServiceData serviceData, ServiceWrapper wrapper) {
  return wrapper.serviceData.priority > serviceData.priority && !identical(serviceData, wrapper.serviceData);
}
