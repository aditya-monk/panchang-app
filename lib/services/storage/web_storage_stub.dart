/// In-memory storage stub for testing and non-web platforms
class WebStorage {
  static final Map<String, String> _memory = {};

  static String? getItem(String key) => _memory[key];

  static void setItem(String key, String value) {
    _memory[key] = value;
  }

  static void removeItem(String key) {
    _memory.remove(key);
  }

  static void clear() {
    _memory.clear();
  }
}
