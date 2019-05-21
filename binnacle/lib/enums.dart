enum ProviderType { compass, wind, position, list_angle }

enum NavigationEventType {
  awaitingInit,
  init,
  start,
  info,
  finish,
  tackNow,
  offCourse,
  calculatingRoute
}
