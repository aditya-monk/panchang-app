import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../models/user_profile.dart';
import '../location/location_service.dart';
import '../storage/local_storage_service.dart';

class AuthService {
  // Admin email list (Case-insensitive match for Method 1)
  static final Set<String> _adminEmails = {
    'amdwivedi160302@gmail.com',
    'aditya.monk@gmail.com',
    'adityadwivedi@gmail.com',
    'admin@panchang.app',
  };

  static final ValueNotifier<UserProfile?> currentUserNotifier =
      ValueNotifier<UserProfile?>(null);

  static final ValueNotifier<bool> isLoggedInNotifier =
      ValueNotifier<bool>(false);

  static final ValueNotifier<bool> isAdminNotifier =
      ValueNotifier<bool>(false);

  // In-memory / persisted registry of all users (visible exclusively in Admin Panel)
  static final ValueNotifier<List<UserProfile>> registeredUsersNotifier =
      ValueNotifier<List<UserProfile>>([]);

  static UserProfile? get currentUser => currentUserNotifier.value;
  static bool get isLoggedIn => isLoggedInNotifier.value;
  static bool get isAdmin => isAdminNotifier.value;
  static List<UserProfile> get registeredUsers => registeredUsersNotifier.value;

  /// Add custom admin email dynamically
  static void registerAdminEmail(String email) {
    if (email.trim().isNotEmpty) {
      _adminEmails.add(email.trim().toLowerCase());
      // Re-evaluate current user admin status
      if (currentUser != null && _isAdminEmail(currentUser!.email)) {
        isAdminNotifier.value = true;
      }
    }
  }

  static bool _isAdminEmail(String email) {
    final clean = email.trim().toLowerCase();
    if (clean.isEmpty) return false;
    return _adminEmails.contains(clean) || clean.startsWith('admin@');
  }

  /// Initialize Auth state and restore persistent session ("Stay Logged In")
  static void init() {
    _loadSeedUsers();
    _restoreSavedSession();
  }

  static void _restoreSavedSession() {
    // If a session was previously persisted, restore it
    // In browser or app restarts, this ensures users stay logged in
    final saved = LocalStorageService.savedUserSession;
    if (saved != null) {
      try {
        final profile = UserProfile.fromJson(saved);
        final admin = _isAdminEmail(profile.email);
        currentUserNotifier.value = profile.copyWith(
          isAdmin: admin,
          lastActiveAt: DateTime.now(),
        );
        isLoggedInNotifier.value = true;
        isAdminNotifier.value = admin;
        _upsertUserInRegistry(currentUserNotifier.value!);
      } catch (e) {
        debugPrint('Error restoring user session: $e');
      }
    }
  }

  /// One-Tap Sign In with Google
  static Future<UserProfile> signInWithGoogle({
    String? customName,
    String? customEmail,
    String? phoneNumber,
  }) async {
    final location = LocationService.currentLocation;
    final email = customEmail ?? 'aditya.monk@gmail.com';
    final name = customName ?? 'Aditya Dwivedi';
    final admin = _isAdminEmail(email);

    final profile = UserProfile(
      id: 'usr_g_${email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}',
      name: name,
      email: email,
      phoneNumber: phoneNumber ?? '+91 98765 43210',
      city: location.name,
      state: location.state,
      country: location.country,
      latitude: location.latitude,
      longitude: location.longitude,
      provider: 'google',
      photoUrl: 'https://lh3.googleusercontent.com/a/default-user',
      tradition: LocalStorageService.selectedTradition.name,
      language: LocalStorageService.appLanguage,
      isAdmin: admin,
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );

    _setCurrentUser(profile);
    return profile;
  }

  /// One-Tap Sign In with Apple ID
  static Future<UserProfile> signInWithApple({
    String? customName,
    String? customEmail,
    String? phoneNumber,
  }) async {
    final location = LocationService.currentLocation;
    final email = customEmail ?? 'aditya@privaterelay.appleid.com';
    final name = customName ?? 'Aditya Dwivedi';
    final admin = _isAdminEmail(email);

    final profile = UserProfile(
      id: 'usr_a_${email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}',
      name: name,
      email: email,
      phoneNumber: phoneNumber ?? '+91 98765 43210',
      city: location.name,
      state: location.state,
      country: location.country,
      latitude: location.latitude,
      longitude: location.longitude,
      provider: 'apple',
      photoUrl: null,
      tradition: LocalStorageService.selectedTradition.name,
      language: LocalStorageService.appLanguage,
      isAdmin: admin,
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );

    _setCurrentUser(profile);
    return profile;
  }

  /// Update Phone Number for currently signed-in user
  static void updatePhoneNumber(String phone) {
    if (currentUser == null) return;
    final updated = currentUser!.copyWith(
      phoneNumber: phone.trim(),
      lastActiveAt: DateTime.now(),
    );
    _setCurrentUser(updated);
  }

  /// Refresh Location automatically from device/LocationService
  static void refreshLocation() {
    if (currentUser == null) return;
    final loc = LocationService.currentLocation;
    final updated = currentUser!.copyWith(
      city: loc.name,
      state: loc.state,
      country: loc.country,
      latitude: loc.latitude,
      longitude: loc.longitude,
      lastActiveAt: DateTime.now(),
    );
    _setCurrentUser(updated);
  }

  static void _setCurrentUser(UserProfile profile) {
    currentUserNotifier.value = profile;
    isLoggedInNotifier.value = true;
    isAdminNotifier.value = profile.isAdmin;

    // Persist session so user stays logged in
    LocalStorageService.saveUserSession(profile.toJson());

    // Update the central registry
    _upsertUserInRegistry(profile);
  }

  static void _upsertUserInRegistry(UserProfile profile) {
    final list = List<UserProfile>.from(registeredUsersNotifier.value);
    final idx = list.indexWhere((u) => u.id == profile.id || u.email == profile.email);
    if (idx >= 0) {
      list[idx] = profile;
    } else {
      list.insert(0, profile);
    }
    registeredUsersNotifier.value = list;
    LocalStorageService.saveRegisteredUsers(
      list.map((u) => u.toJson()).toList(),
    );
  }

  /// Sign out
  static void signOut() {
    currentUserNotifier.value = null;
    isLoggedInNotifier.value = false;
    isAdminNotifier.value = false;
    LocalStorageService.clearUserSession();
  }

  /// Export all registered users to RFC-4180 CSV format (Admin only)
  static String exportUsersToCsv() {
    final buffer = StringBuffer();
    buffer.writeln(
      'User ID,Name,Email,Phone Number,City,State,Country,Latitude,Longitude,Sign-in Provider,Tradition,Language,Is Admin,Joined Date,Last Active',
    );

    for (final u in registeredUsers) {
      final line = [
        '"${u.id}"',
        '"${u.name.replaceAll('"', '""')}"',
        '"${u.email}"',
        '"${u.phoneNumber}"',
        '"${u.city}"',
        '"${u.state}"',
        '"${u.country}"',
        u.latitude.toStringAsFixed(4),
        u.longitude.toStringAsFixed(4),
        '"${u.provider}"',
        '"${u.tradition}"',
        '"${u.language}"',
        u.isAdmin ? 'Yes' : 'No',
        '"${u.createdAt.toIso8601String()}"',
        '"${u.lastActiveAt.toIso8601String()}"',
      ].join(',');
      buffer.writeln(line);
    }

    return buffer.toString();
  }

  /// Seed initial database for admin demonstration
  static void _loadSeedUsers() {
    final savedList = LocalStorageService.savedRegisteredUsers;
    if (savedList != null && savedList.isNotEmpty) {
      try {
        registeredUsersNotifier.value =
            savedList.map((e) => UserProfile.fromJson(e)).toList();
        return;
      } catch (e) {
        debugPrint('Error loading saved users: $e');
      }
    }

    // Default active users across major Indian cities for initial admin overview
    registeredUsersNotifier.value = [
      UserProfile(
        id: 'usr_g_aditya',
        name: 'Aditya Dwivedi (Admin)',
        email: 'amdwivedi160302@gmail.com',
        phoneNumber: '+91 98250 12345',
        city: 'Ahmedabad',
        state: 'Gujarat',
        country: 'India',
        latitude: 23.0225,
        longitude: 72.5714,
        provider: 'google',
        photoUrl: 'https://lh3.googleusercontent.com/a/default-user',
        tradition: 'vaishnava',
        language: 'hi',
        isAdmin: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastActiveAt: DateTime.now(),
      ),
      UserProfile(
        id: 'usr_a_priya',
        name: 'Priya Sharma',
        email: 'priyasharma@icloud.com',
        phoneNumber: '+91 98111 22334',
        city: 'Varanasi',
        state: 'Uttar Pradesh',
        country: 'India',
        latitude: 25.3176,
        longitude: 82.9739,
        provider: 'apple',
        photoUrl: null,
        tradition: 'smartha',
        language: 'hi',
        isAdmin: false,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        lastActiveAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      UserProfile(
        id: 'usr_g_rajesh',
        name: 'Rajesh Patel',
        email: 'rajesh.patel@gmail.com',
        phoneNumber: '+91 99240 55667',
        city: 'Vadodara',
        state: 'Gujarat',
        country: 'India',
        latitude: 22.3072,
        longitude: 73.1812,
        provider: 'google',
        photoUrl: null,
        tradition: 'vaishnava',
        language: 'gu',
        isAdmin: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        lastActiveAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      UserProfile(
        id: 'usr_g_amitabh',
        name: 'Amitabh Mishra',
        email: 'amitabh.mishra@gmail.com',
        phoneNumber: '+91 94150 99881',
        city: 'Patna',
        state: 'Bihar',
        country: 'India',
        latitude: 25.5941,
        longitude: 85.1376,
        provider: 'google',
        photoUrl: null,
        tradition: 'smartha',
        language: 'bho',
        isAdmin: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        lastActiveAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }
}
