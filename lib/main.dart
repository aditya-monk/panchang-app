import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/onboarding/onboarding_flow.dart';
import 'services/storage/local_storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PanchangApp());
}

class PanchangApp extends StatefulWidget {
  const PanchangApp({super.key});

  @override
  State<PanchangApp> createState() => _PanchangAppState();
}

class _PanchangAppState extends State<PanchangApp> {
  bool _elderMode = LocalStorageService.elderMode;
  bool _isOnboarding = !LocalStorageService.isOnboardingComplete;

  void _refreshTheme() {
    setState(() {
      _elderMode = LocalStorageService.elderMode;
    });
  }

  void _completeOnboarding() {
    setState(() {
      _isOnboarding = false;
      LocalStorageService.isOnboardingComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panchang',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(elderMode: _elderMode),
      home: _isOnboarding
          ? OnboardingFlow(onComplete: _completeOnboarding)
          : HomeScreen(onRefreshTheme: _refreshTheme),
    );
  }
}
