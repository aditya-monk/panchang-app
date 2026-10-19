abstract class TtsPlatform {
  bool get isSupported;
  bool speak({required String text, required String langCode});
  void stop();
}
