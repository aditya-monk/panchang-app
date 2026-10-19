import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:panchang_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:panchang_app/services/auth/auth_service.dart';
import 'package:panchang_app/services/location/location_service.dart';
import 'package:panchang_app/services/storage/local_storage_service.dart';

void main() {
  setUp(() {
    LocalStorageService.isOnboardingComplete = false;
    LocalStorageService.appLanguage = 'hi';
    LocalStorageService.elderMode = false;
    AuthService.signOut();
    AuthService.init();
  });

  testWidgets('Onboarding flow switches language without resetting', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool completed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(
          onComplete: () {
            completed = true;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify initial step is Language (Step 0)
    expect(find.text('अपनी पसंदीदा भाषा चुनें\nChoose Your Language'), findsOneWidget);
    expect(find.text('ગુજરાતી'), findsOneWidget);

    // Tap Gujarati
    await tester.tap(find.text('ગુજરાતી'));
    await tester.pumpAndSettle();

    // Verify that we are STILL on the language selection screen, NOT reset to splash
    expect(find.text('अपनी पसंदीदा भाषा चुनें\nChoose Your Language'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    // Tap Next to go to Elder Mode (Step 1)
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify Elder Mode screen is displayed in Gujarati
    expect(find.textContaining('શું તમે વાંચવા માટે મોટા અક્ષરો'), findsOneWidget);

    // Toggle Elder Mode
    await tester.tap(find.textContaining('મોટા અક્ષર રાખો'));
    await tester.pumpAndSettle();

    // Verify still on step 1 with preview updated
    expect(find.textContaining('શું તમે વાંચવા માટે મોટા અક્ષરો'), findsOneWidget);

    // Proceed to Step 2 (Tour)
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify Tour screen
    expect(find.textContaining('Tour'), findsWidgets);

    // Skip tour to go directly to Step 3 (Sign In)
    final skipBtn = find.textContaining('Skip');
    expect(skipBtn, findsOneWidget);
    await tester.tap(skipBtn);
    await tester.pumpAndSettle();

    // Verify Step 3: Sign In / Register
    expect(find.textContaining('Sign In / Register'), findsOneWidget);
    expect(find.textContaining('Continue with Google'), findsOneWidget);
    expect(find.textContaining('Sign in with Apple'), findsOneWidget);
    expect(find.textContaining('Auto-detected'), findsOneWidget);

    // Tap Skip to App to complete onboarding
    final finishBtn = find.textContaining('Skip & Get Started');
    expect(finishBtn, findsOneWidget);
    await tester.tap(finishBtn);
    await tester.pumpAndSettle();

    expect(completed, isTrue);
    expect(LocalStorageService.isOnboardingComplete, isTrue);
  });
}
