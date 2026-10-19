import 'dart:js_interop';
import 'tts_platform_interface.dart';

@JS('window.PanchangTtsBridge')
external PanchangTtsBridgeJS? get panchangTtsBridge;

@JS()
@staticInterop
class PanchangTtsBridgeJS {}

extension PanchangTtsBridgeExtension on PanchangTtsBridgeJS {
  external bool isSupported();
  external bool speak(String text, String lang);
  external void stop();
}

class TtsPlatformImplementation implements TtsPlatform {
  @override
  bool get isSupported {
    final bridge = panchangTtsBridge;
    if (bridge == null) return false;
    try {
      return bridge.isSupported();
    } catch (_) {
      return false;
    }
  }

  @override
  bool speak({required String text, required String langCode}) {
    final bridge = panchangTtsBridge;
    if (bridge == null) return false;
    try {
      return bridge.speak(text, langCode);
    } catch (_) {
      return false;
    }
  }

  @override
  void stop() {
    try {
      panchangTtsBridge?.stop();
    } catch (_) {}
  }
}

TtsPlatform createTtsPlatform() => TtsPlatformImplementation();
