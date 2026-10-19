import 'speech_platform_interface.dart';

class SpeechPlatformImplementation implements SpeechPlatform {
  @override
  bool get isSupported => false;

  @override
  bool get isListening => false;

  @override
  bool startListening({
    required String langCode,
    required SpeechResultCallback onResult,
    required SpeechErrorCallback onError,
    required SpeechEndCallback onEnd,
  }) {
    onError('Speech recognition is only supported in web/mobile environments.');
    return false;
  }

  @override
  void stopListening() {}
}

SpeechPlatform createSpeechPlatform() => SpeechPlatformImplementation();
