import 'package:sos/models/service_data.dart';
import 'package:sos/services/service_wrapper_interface.dart';

class ServiceList {
  final String type;
  List<ServiceWrapper> get serviceList => _list;

  // NOTE: This is O(N) operation, N=number of elements in list
  ServiceWrapper get defaultService =>
      _list.firstWhere((wrapper) => wrapper.isDefault == true);

  List<ServiceWrapper> _list;

  ServiceList(this.type, this._list);

  ///
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

  /// Compares [serviceData] to [serviceWrapper] and returns
  /// true if [serviceWrapper] should be prioritized
  bool _isPriority(ServiceData serviceData, ServiceWrapper wrapper) {
    return wrapper.serviceData.priority > serviceData.priority &&
        !identical(serviceData, wrapper.serviceData);
  }
}
