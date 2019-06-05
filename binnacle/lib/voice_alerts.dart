// import 'dart:math';

// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:sos/enums.dart';
// import 'package:sos/providers/navigation_provider.dart';

// class VoiceAlerts {
//   BehaviorSubject<NavigationEvent> _eventBus;

//   FlutterTts _tts;

//   VoiceAlerts(this._eventBus) {
//     _tts = new FlutterTts();

//     _eventBus.listen((event) {
//       switch (event.eventType) {
//         case NavigationEventType.start:
//           _tts.speak("Starting course");
//           break;
//         case NavigationEventType.tackNow:
//           _tts.speak("Tack now");
//           break;
//         case NavigationEventType.offCourse:
//           _tts.speak("You are off course");
//           break;
//         default:
//       }
//     });
//   }

//   void test() {
//     List<String> phrases = [
//       "On board",
//       "Batten down the hatches",
//       "In deep water",
//       "All at sea",
//       "Sink or swim",
//       "Dead in the water",
//       "Rock the boat",
//       "All hands on deck",
//       "Loose cannon",
//       "Making waves",
//       "Land lubber",
//       "Bottoms up",
//     ];

//     final _random = new Random();
//     String phrase = phrases[_random.nextInt(phrases.length)];

//     _tts.speak(phrase);
//   }
// }
