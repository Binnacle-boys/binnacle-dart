import '../enums.dart';
class ServiceData {
  /*
  * category --> the type of data that this service serves. compass, wind, etc.
  * name ---> The name of the service as displayed in the UI
  * priority --- > used to automatically switch services when one fails
  */
  final ProviderType category;
  final String name;
  final int priority;
  ServiceData(this.category, this.name, this.priority);
}
