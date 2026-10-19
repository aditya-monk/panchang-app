import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/storage/local_storage_service.dart';
import '../home_screen.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onRefreshTheme;

  const SplashScreen({super.key, required this.onRefreshTheme});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.85).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
    );

    // Auto-proceed to onboarding or home screen after 2.4s
    _timer = Timer(const Duration(milliseconds: 2400), _proceedNext);
  }

  void _proceedNext() {
    _timer?.cancel();
    if (!mounted) return;

    final isOnboardingDone = LocalStorageService.isOnboardingComplete;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, anim1, anim2) {
          if (!isOnboardingDone) {
            return OnboardingScreen(
              onComplete: () {
                LocalStorageService.isOnboardingComplete = true;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(onRefreshTheme: widget.onRefreshTheme),
                  ),
                );
              },
            );
          } else {
            return HomeScreen(onRefreshTheme: widget.onRefreshTheme);
          }
        },
        transitionsBuilder: (context, anim1, anim2, child) {
          return FadeTransition(opacity: anim1, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: _proceedNext,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.15),
              radius: 1.25,
              colors: [
                Color(0xFF8B2500), // Deep sacred saffron red
                Color(0xFF500F00), // Rich maroon
                Color(0xFF1E0500), // Midnight temple dark
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: SafeArea(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // Golden Divine Aura & Diya / Lotus
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD54F).withOpacity(_glowAnimation.value),
                            blurRadius: 40,
                            spreadRadius: 8,
                          ),
                          BoxShadow(
                            color: const Color(0xFFFF9800).withOpacity(0.4),
                            blurRadius: 70,
                            spreadRadius: 16,
                          ),
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFFE082),
                            Color(0xFFFFB300),
                            Color(0xFFE65100),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '🪔',
                          style: TextStyle(fontSize: 54),
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Sacred "Hare Krishna!" Calligraphy
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFFFFF9C4),
                                Color(0xFFFFE082),
                                Color(0xFFFFD54F),
                                Color(0xFFFFB300),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds),
                            child: const Text(
                              'हरे कृष्ण!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2.0,
                                shadows: [
                                  Shadow(
                                    color: Color(0xFFFFB300),
                                    blurRadius: 28,
                                  ),
                                  Shadow(
                                    color: Colors.black45,
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'HARE KRISHNA',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFE082),
                              letterSpacing: 6.0,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Sacred Mahamantra Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFFFD54F).withOpacity(0.4),
                            width: 1.2,
                          ),
                        ),
                        child: const Text(
                          'हरे कृष्ण हरे कृष्ण कृष्ण कृष्ण हरे हरे ।\nहरे राम हरे राम राम राम हरे हरे ॥',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFFF3E0),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Subtle auspicious loading indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFFFFE082).withOpacity(0.8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'शुद्ध वैदिक पंचांग प्रारंभ हो रहा है...',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFFFE082),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Tap to skip hint
                    Text(
                      'टैप करके आगे बढ़ें • Tap anywhere to continue',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.white.withOpacity(0.45),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
