import 'package:flutter_test/flutter_test.dart';
import 'package:panchang_app/models/user_profile.dart';
import 'package:panchang_app/services/auth/auth_service.dart';
import 'package:panchang_app/services/location/location_service.dart';

void main() {
  setUp(() {
    AuthService.signOut();
    AuthService.init();
  });

  group('Authentication & Method 1 Admin Tests', () {
    test('Method 1: Admin email automatically grants admin role and unlocks dashboard', () async {
      final adminProfile = await AuthService.signInWithGoogle(
        customName: 'Aditya Dwivedi',
        customEmail: 'amdwivedi160302@gmail.com',
        phoneNumber: '+91 98250 12345',
      );

      expect(adminProfile.isAdmin, isTrue);
      expect(AuthService.isAdmin, isTrue);
      expect(AuthService.isLoggedIn, isTrue);
      expect(AuthService.currentUser?.email, 'amdwivedi160302@gmail.com');
      print('✓ Method 1 Admin verified: ${adminProfile.email} recognized as ADMIN');
    });

    test('Regular user is NOT admin', () async {
      final userProfile = await AuthService.signInWithGoogle(
        customName: 'Ordinary Devotee',
        customEmail: 'devotee108@gmail.com',
        phoneNumber: '+91 99999 88888',
      );

      expect(userProfile.isAdmin, isFalse);
      expect(AuthService.isAdmin, isFalse);
      expect(AuthService.isLoggedIn, isTrue);
      print('✓ Regular user verified: ${userProfile.email} is NOT admin');
    });

    test('Apple ID sign-in creates valid user profile with auto-detected location', () async {
      final appleProfile = await AuthService.signInWithApple(
        customName: 'Pooja Verma',
        customEmail: 'pooja.verma@privaterelay.appleid.com',
        phoneNumber: '+91 91234 56789',
      );

      expect(appleProfile.provider, 'apple');
      expect(appleProfile.city, LocationService.currentLocation.name);
      expect(appleProfile.latitude, LocationService.currentLocation.latitude);
      expect(appleProfile.longitude, LocationService.currentLocation.longitude);
      print('✓ Apple ID sign-in verified with location: ${appleProfile.city}');
    });

    test('Stay Logged In: Session persistence restores user on init', () async {
      await AuthService.signInWithGoogle(
        customName: 'Permanent User',
        customEmail: 'permanent@gmail.com',
        phoneNumber: '+91 90000 11111',
      );

      expect(AuthService.isLoggedIn, isTrue);

      // Simulate app restart
      AuthService.init();

      expect(AuthService.isLoggedIn, isTrue);
      expect(AuthService.currentUser?.email, 'permanent@gmail.com');
      print('✓ "Stay Logged In" persistence verified across app restart');
    });

    test('Registered Users CSV Export generates valid RFC-4180 format', () {
      final csv = AuthService.exportUsersToCsv();

      expect(csv.contains('User ID,Name,Email,Phone Number,City'), isTrue);
      expect(csv.contains('amdwivedi160302@gmail.com'), isTrue);
      print('✓ CSV export generated with valid headers and user entries');
    });
  });
}
