import 'package:flutter/foundation.dart';
import '../../core/constants/panchang_constants.dart';
import '../../domain/models/location_info.dart';
import '../location/location_service.dart';
import 'web_storage.dart';

class LocalStorageService {
  // ValueNotifiers for dynamic reactivity across all screens
  static final ValueNotifier<String> appLanguageNotifier = ValueNotifier<String>('hi');
  static final ValueNotifier<String> voiceLanguageNotifier = ValueNotifier<String>('hi');
  static final ValueNotifier<CalendarTradition> traditionNotifier =
      ValueNotifier<CalendarTradition>(CalendarTradition.standardHindu);
  static final ValueNotifier<RegionalProfile> regionNotifier =
      ValueNotifier<RegionalProfile>(RegionalProfile.gujarat);
  static final ValueNotifier<bool> elderModeNotifier = ValueNotifier<bool>(false);
  static final ValueNotifier<LocationInfo> locationNotifier =
      ValueNotifier<LocationInfo>(LocationService.currentLocation);

  // App Version & In-App Update Notifiers
  static const String currentAppVersion = '1.0.0';
  static final ValueNotifier<String> latestBroadcastVersionNotifier = ValueNotifier<String>('1.0.0');
  static final ValueNotifier<String> apkDownloadUrlNotifier =
      ValueNotifier<String>('https://panchang-app-eta.vercel.app/panchang.apk');
  static final ValueNotifier<String> updateNotesNotifier =
      ValueNotifier<String>('सटीक गणना, नया ऑनबोर्डिंग और वॉइस टूर');
  static final ValueNotifier<bool> updateAvailableNotifier = ValueNotifier<bool>(false);

  // First-time onboarding flag
  static final ValueNotifier<bool> onboardingCompleteNotifier = ValueNotifier<bool>(false);

  /// Initialize and restore user choices from persistent storage
  static void init() {
    final savedLang = WebStorage.getItem('panchang_app_language');
    if (savedLang != null && savedLang.isNotEmpty) {
      appLanguageNotifier.value = savedLang;
      voiceLanguageNotifier.value = savedLang;
    }

    final savedElder = WebStorage.getItem('panchang_elder_mode');
    if (savedElder != null) {
      elderModeNotifier.value = (savedElder == 'true');
    }

    final savedOnboarding = WebStorage.getItem('panchang_onboarding_complete');
    if (savedOnboarding != null) {
      onboardingCompleteNotifier.value = (savedOnboarding == 'true');
    }

    final savedTradition = WebStorage.getItem('panchang_tradition');
    if (savedTradition != null) {
      try {
        traditionNotifier.value = CalendarTradition.values.firstWhere((t) => t.name == savedTradition);
      } catch (_) {}
    }

    final savedRegion = WebStorage.getItem('panchang_region');
    if (savedRegion != null) {
      try {
        regionNotifier.value = RegionalProfile.values.firstWhere((r) => r.name == savedRegion);
      } catch (_) {}
    }
  }

  // Getters and Setters that trigger notifiers & persist to storage
  static CalendarTradition get selectedTradition => traditionNotifier.value;
  static set selectedTradition(CalendarTradition val) {
    traditionNotifier.value = val;
    WebStorage.setItem('panchang_tradition', val.name);
  }

  static RegionalProfile get selectedRegion => regionNotifier.value;
  static set selectedRegion(RegionalProfile val) {
    regionNotifier.value = val;
    WebStorage.setItem('panchang_region', val.name);
  }

  static String get appLanguage => appLanguageNotifier.value;
  static set appLanguage(String val) {
    appLanguageNotifier.value = val;
    WebStorage.setItem('panchang_app_language', val);
  }

  static String get voiceLanguage => voiceLanguageNotifier.value;
  static set voiceLanguage(String val) {
    voiceLanguageNotifier.value = val;
    WebStorage.setItem('panchang_voice_language', val);
  }

  static bool get elderMode => elderModeNotifier.value;
  static set elderMode(bool val) {
    elderModeNotifier.value = val;
    WebStorage.setItem('panchang_elder_mode', val.toString());
  }

  static LocationInfo get currentLocation => locationNotifier.value;
  static set currentLocation(LocationInfo val) {
    LocationService.currentLocation = val;
    locationNotifier.value = val;
  }

  static bool get isOnboardingComplete => onboardingCompleteNotifier.value;
  static set isOnboardingComplete(bool val) {
    onboardingCompleteNotifier.value = val;
    WebStorage.setItem('panchang_onboarding_complete', val.toString());
  }

  static String get latestBroadcastVersion => latestBroadcastVersionNotifier.value;
  static String get apkDownloadUrl => apkDownloadUrlNotifier.value;
  static String get updateNotes => updateNotesNotifier.value;
  static bool get hasPendingUpdate => updateAvailableNotifier.value;

  static void broadcastUpdate({
    required String newVersion,
    required String downloadUrl,
    required String notes,
  }) {
    latestBroadcastVersionNotifier.value = newVersion;
    apkDownloadUrlNotifier.value = downloadUrl;
    updateNotesNotifier.value = notes;
    updateAvailableNotifier.value = (newVersion != currentAppVersion);
  }

  static void dismissUpdate() {
    updateAvailableNotifier.value = false;
  }

  // User Session & Persistent Registration Storage
  static Map<String, dynamic>? savedUserSession;
  static List<Map<String, dynamic>>? savedRegisteredUsers;

  static void saveUserSession(Map<String, dynamic> session) {
    savedUserSession = session;
  }

  static void clearUserSession() {
    savedUserSession = null;
  }

  static void saveRegisteredUsers(List<Map<String, dynamic>> users) {
    savedRegisteredUsers = users;
  }

  static void resetFirstTimeUser() {
    onboardingCompleteNotifier.value = false;
    WebStorage.removeItem('panchang_onboarding_complete');
  }

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
