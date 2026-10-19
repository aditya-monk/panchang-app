import 'tts_platform_interface.dart';

class TtsPlatformImplementation implements TtsPlatform {
  @override
  bool get isSupported => false;

  @override
  bool speak({required String text, required String langCode}) {
    return false;
  }

  @override
  void stop() {}
}

TtsPlatform createTtsPlatform() => TtsPlatformImplementation();
