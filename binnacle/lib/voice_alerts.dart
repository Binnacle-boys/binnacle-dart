import 'package:flutter_tts/flutter_tts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/enums.dart';
import 'package:sos/providers/navigation_provider.dart';

class VoiceAlerts {
  BehaviorSubject<NavigationEvent> _eventBus;

  FlutterTts _tts;

  VoiceAlerts(this._eventBus) {
    _tts = new FlutterTts();

    _eventBus.listen((event) {
      switch (event.eventType) {
        case NavigationEventType.start:
          _tts.speak("Starting course");
          break;
        case NavigationEventType.tackNow:
          _tts.speak("Tack now");
          break;
        case NavigationEventType.offCourse:
          _tts.speak("You are off course");
          break;
        default:
      }
    });
  }
}
