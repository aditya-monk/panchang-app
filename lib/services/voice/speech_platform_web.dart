import 'dart:js_interop';
import 'speech_platform_interface.dart';

@JS('window.PanchangSpeechBridge')
external PanchangSpeechBridgeJS? get panchangSpeechBridge;

@JS()
@staticInterop
class PanchangSpeechBridgeJS {}

extension PanchangSpeechBridgeExtension on PanchangSpeechBridgeJS {
  external bool isSupported();
  external bool get isListening;
  external bool start(String lang, JSFunction onResult, JSFunction onError, JSFunction onEnd);
  external void stop();
}

class SpeechPlatformImplementation implements SpeechPlatform {
  @override
  bool get isSupported {
    final bridge = panchangSpeechBridge;
    if (bridge == null) return false;
    try {
      return bridge.isSupported();
    } catch (_) {
      return false;
    }
  }

  @override
  bool get isListening {
    final bridge = panchangSpeechBridge;
    if (bridge == null) return false;
    try {
      return bridge.isListening;
    } catch (_) {
      return false;
    }
  }

  @override
  bool startListening({
    required String langCode,
    required SpeechResultCallback onResult,
    required SpeechErrorCallback onError,
    required SpeechEndCallback onEnd,
  }) {
    final bridge = panchangSpeechBridge;
    if (bridge == null) {
      onError('Speech bridge not initialized');
      return false;
    }

    final jsOnResult = ((JSString text, JSBoolean isFinal) {
      onResult(text.toDart, isFinal.toDart);
    }).toJS;

    final jsOnError = ((JSString error) {
      onError(error.toDart);
    }).toJS;

    final jsOnEnd = (() {
      onEnd();
    }).toJS;

    return bridge.start(langCode, jsOnResult, jsOnError, jsOnEnd);
  }

  @override
  void stopListening() {
    try {
      panchangSpeechBridge?.stop();
    } catch (_) {}
  }
}

SpeechPlatform createSpeechPlatform() => SpeechPlatformImplementation();
