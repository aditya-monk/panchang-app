import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/user_profile.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/location/location_service.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  static Future<UserProfile?> show(BuildContext context) {
    return showModalBottomSheet<UserProfile>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const LoginModal(),
    );
  }

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final TextEditingController _phoneCtrl = TextEditingController(text: '+91 ');
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  bool _isCustomInput = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final profile = await AuthService.signInWithGoogle(
        customName: _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : null,
        customEmail: _emailCtrl.text.trim().isNotEmpty ? _emailCtrl.text.trim() : null,
        phoneNumber: _phoneCtrl.text.trim().length > 5 ? _phoneCtrl.text.trim() : null,
      );

      if (mounted) {
        Navigator.of(context).pop(profile);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              profile.isAdmin
                  ? '👑 स्वागत है व्यवस्थापक (Admin)! व्यवस्थापक नियंत्रण अनलॉक हो गया।'
                  : '✅ स्वागत है ${profile.name}! आप सफलतापूर्वक लॉग इन हो गए हैं।',
            ),
            backgroundColor: profile.isAdmin ? AppTheme.maroonSecondary : AppTheme.suitableGreen,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final profile = await AuthService.signInWithApple(
        customName: _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : null,
        customEmail: _emailCtrl.text.trim().isNotEmpty ? _emailCtrl.text.trim() : null,
        phoneNumber: _phoneCtrl.text.trim().length > 5 ? _phoneCtrl.text.trim() : null,
      );

      if (mounted) {
        Navigator.of(context).pop(profile);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              profile.isAdmin
                  ? '👑 स्वागत है व्यवस्थापक (Admin)! व्यवस्थापक नियंत्रण अनलॉक हो गया।'
                  : '✅ स्वागत है ${profile.name}! आप सफलतापूर्वक लॉग इन हो गए हैं।',
            ),
            backgroundColor: profile.isAdmin ? AppTheme.maroonSecondary : AppTheme.suitableGreen,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = LocationService.currentLocation;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sacred Badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B0000), Color(0xFFE65100)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🪔 ', style: TextStyle(fontSize: 14)),
                    Text(
                      'हरे कृष्ण! (Panchang Account)',
                      style: TextStyle(
                        color: Color(0xFFFFE082),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Title
            const Text(
              'साइन इन / लॉग इन करें',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C1810),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'साइन इन करने पर आपका स्थान और प्राथमिकताएं सुरक्षित रहेंगी। आप हमेशा लॉग इन रहेंगे।',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Location auto-capture pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.saffronPrimary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.saffronPrimary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: AppTheme.saffronPrimary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'स्वतः संकलित स्थान (Auto-detected Location):',
                          style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${location.name}, ${location.state} (${location.country})',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle, color: AppTheme.suitableGreen, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Phone Number Input
            const Text(
              'मोबाइल नंबर (संपर्क एवं सहायता हेतु):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone_android, color: AppTheme.saffronPrimary),
                hintText: '+91 98765 43210',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 14),

            // Toggle custom account inputs (useful for testing admin vs regular users)
            GestureDetector(
              onTap: () => setState(() => _isCustomInput = !_isCustomInput),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isCustomInput ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: AppTheme.saffronPrimary,
                  ),
                  Text(
                    _isCustomInput
                        ? 'सरल साइन इन पर वापस जाएं'
                        : 'विशिष्ट ईमेल / नाम दर्ज करें (व्यवस्थापक / कस्टम)',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.saffronPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            if (_isCustomInput) ...[
              const SizedBox(height: 10),
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                  labelText: 'पूरा नाम (Full Name)',
                  hintText: 'Aditya Dwivedi',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                  labelText: 'ईमेल पता (Email)',
                  hintText: 'amdwivedi160302@gmail.com',
                  helperText: 'व्यवस्थापक ईमेल डालने पर एडमिन पैनल स्वतः सक्रिय हो जाएगा।',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ],
            const SizedBox(height: 16),

            if (_isLoading)
              const Center(child: CircularProgressIndicator(color: AppTheme.saffronPrimary))
            else ...[
              // Google Sign-In Button
              ElevatedButton(
                onPressed: _handleGoogleSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                      height: 22,
                      width: 22,
                      errorBuilder: (ctx, err, stack) => const Icon(
                        Icons.account_circle,
                        color: Colors.red,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Google के साथ जारी रखें (Sign in with Google)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Apple ID Sign-In Button
              ElevatedButton(
                onPressed: _handleAppleSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.apple, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Apple ID के साथ जारी रखें (Sign in with Apple)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Persistent Session Note
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 13, color: AppTheme.suitableGreen),
                const SizedBox(width: 6),
                Text(
                  'सुरक्षित सत्र • आप हमेशा लॉग इन रहेंगे (Stay Logged In)',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
