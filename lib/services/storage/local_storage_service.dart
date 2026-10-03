import '../../core/constants/panchang_constants.dart';
import '../../domain/models/location_info.dart';

class LocalStorageService {
  static CalendarTradition selectedTradition = CalendarTradition.standardHindu;
  static RegionalProfile selectedRegion = RegionalProfile.gujarat;
  static String appLanguage = 'en';
  static String voiceLanguage = 'hi'; // Can differ from UI language per Section 41
  static bool elderMode = false;
  static bool isOnboardingComplete = true;

  // Notification toggles
  static bool notifyDailyPanchang = true;
  static bool notifySunrise = false;
  static bool notifySunset = false;
  static bool notifyEkadashi = true;
  static bool notifyEkadashiParana = true;
  static bool notifyFestivals = true;
  static bool notifyMuhurat = true;

  // Saved occasions / bookmarks
  static final List<Map<String, dynamic>> savedOccasions = [];

  static void saveOccasion({
    required String occasion,
    required String location,
    required String date,
    required String timing,
  }) {
    savedOccasions.add({
      'occasion': occasion,
      'location': location,
      'date': date,
      'timing': timing,
      'savedAt': DateTime.now().toIso8601String(),
    });
  }
}
