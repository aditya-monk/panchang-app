import 'tts_platform_interface.dart';
import 'tts_platform_stub.dart'
    if (dart.library.js_interop) 'tts_platform_web.dart';

export 'tts_platform_interface.dart';

class TtsService {
  static final TtsPlatform _platform = createTtsPlatform();

  static bool get isSupported => _platform.isSupported;

  static bool speak({required String text, required String langCode}) {
    return _platform.speak(text: text, langCode: langCode);
  }

  static void stop() {
    _platform.stop();
  }
}
