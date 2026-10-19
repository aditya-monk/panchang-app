typedef SpeechResultCallback = void Function(String text, bool isFinal);
typedef SpeechErrorCallback = void Function(String error);
typedef SpeechEndCallback = void Function();

abstract class SpeechPlatform {
  bool get isSupported;
  bool get isListening;
  bool startListening({
    required String langCode,
    required SpeechResultCallback onResult,
    required SpeechErrorCallback onError,
    required SpeechEndCallback onEnd,
  });
  void stopListening();
}
