import 'speech_platform_interface.dart';
import 'speech_platform_stub.dart'
    if (dart.library.js_interop) 'speech_platform_web.dart';

export 'speech_platform_interface.dart';

class SpeechRecognitionService {
  static final SpeechPlatform _platform = createSpeechPlatform();

  static bool get isSupported => _platform.isSupported;
  static bool get isListening => _platform.isListening;

  static bool startListening({
    required String langCode,
    required SpeechResultCallback onResult,
    required SpeechErrorCallback onError,
    required SpeechEndCallback onEnd,
  }) {
    return _platform.startListening(
      langCode: langCode,
      onResult: onResult,
      onError: onError,
      onEnd: onEnd,
    );
  }

  static void stopListening() {
    _platform.stopListening();
  }
}
