import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'services/auth/auth_service.dart';
import 'services/storage/local_storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AuthService.init();
  runApp(const PanchangApp());
}

class PanchangApp extends StatefulWidget {
  const PanchangApp({super.key});

  @override
  State<PanchangApp> createState() => _PanchangAppState();
}

class _PanchangAppState extends State<PanchangApp> {
  void _refreshTheme() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LocalStorageService.appLanguageNotifier,
      builder: (context, currentLang, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: LocalStorageService.elderModeNotifier,
          builder: (context, elder, _) {
            return MaterialApp(
              title: 'Panchang',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme(elderMode: elder),
              home: SplashScreen(onRefreshTheme: _refreshTheme),
            );
          },
        );
      },
    );
  }
}
