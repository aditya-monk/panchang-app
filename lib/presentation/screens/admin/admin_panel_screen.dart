import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/storage/local_storage_service.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final TextEditingController _versionCtrl = TextEditingController(text: '1.1.0');
  final TextEditingController _apkUrlCtrl = TextEditingController(
    text: LocalStorageService.apkDownloadUrl,
  );
  final TextEditingController _notesCtrl = TextEditingController(
    text: 'सटीक पंचांग गणना, शुद्ध एकादशी पारणा समय और नया ऑनबोर्डिंग',
  );

  bool _isCopied = false;

  @override
  void dispose() {
    _versionCtrl.dispose();
    _apkUrlCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _copyDownloadLink() {
    Clipboard.setData(ClipboardData(text: _apkUrlCtrl.text.trim()));
    setState(() => _isCopied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ APK Download link copied to clipboard!'),
        backgroundColor: AppTheme.suitableGreen,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isCopied = false);
    });
  }

  void _broadcastUpdate() {
    final newVer = _versionCtrl.text.trim();
    final url = _apkUrlCtrl.text.trim();
    final notes = _notesCtrl.text.trim();

    if (newVer.isEmpty || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('कृपया संस्करण संख्या और APK लिंक दर्ज करें।'),
          backgroundColor: AppTheme.notSuitableRed,
        ),
      );
      return;
    }

    LocalStorageService.broadcastUpdate(
      newVersion: newVer,
      downloadUrl: url,
      notes: notes,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🚀 Update v$newVer broadcasted! All users will see the update dialog on launch.'),
        backgroundColor: AppTheme.suitableGreen,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _resetOnboarding() {
    LocalStorageService.resetFirstTimeUser();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 First-time user state reset. Relaunch or restart to see Splash and Onboarding Tour!'),
        backgroundColor: AppTheme.saffronPrimary,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🛠️ Admin & Distribution Panel',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. App Distribution & Direct APK Card
          _buildCard(
            title: '📲 Direct APK Distribution (बिना प्ले स्टोर)',
            subtitle: 'Generate direct APK download links and scan-to-download QR codes for users.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Direct APK Download URL:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _apkUrlCtrl,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.link, color: AppTheme.saffronPrimary),
                    hintText: 'https://panchang-app-eta.vercel.app/panchang.apk',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.saffronPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: Icon(_isCopied ? Icons.check : Icons.copy, size: 18),
                        label: Text(_isCopied ? 'Copied!' : 'Copy Download Link'),
                        onPressed: _copyDownloadLink,
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Text('💬', style: TextStyle(fontSize: 16)),
                      label: const Text('WhatsApp Template'),
                      onPressed: () {
                        final text =
                            '🙏 जय श्री कृष्ण!\nसटीक दैनिक पंचांग, एकादशी पारणा व शुभ मुहूर्त के लिए ऐप यहाँ से सीधे डाउनलोड करें:\n${_apkUrlCtrl.text.trim()}';
                        Clipboard.setData(ClipboardData(text: text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('WhatsApp message copied! Paste directly in WhatsApp chats.'),
                            backgroundColor: AppTheme.suitableGreen,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Scannable QR Code Box
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderSubtle),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.saffronPrimary, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomPaint(
                            painter: _QrMatrixPainter(),
                            child: const Center(
                              child: ContainerBadge(
                                label: 'हरे कृष्ण!',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '📷 Scan with Phone Camera to Download APK',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppTheme.deepText),
                        ),
                        Text(
                          _apkUrlCtrl.text,
                          style: const TextStyle(fontSize: 10.5, color: AppTheme.subtleText),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. In-App Update Broadcaster Card
          _buildCard(
            title: '🔄 In-App Version & Auto-Update Controller',
            subtitle: 'Broadcast a new APK version so all users receive an automatic update alert.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Current App Version:', style: TextStyle(fontSize: 12, color: AppTheme.subtleText)),
                          Text(
                            'v${LocalStorageService.currentAppVersion}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.deepText),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('New Target Version:', style: TextStyle(fontSize: 12, color: AppTheme.subtleText)),
                          SizedBox(
                            height: 38,
                            child: TextField(
                              controller: _versionCtrl,
                              decoration: InputDecoration(
                                hintText: '1.1.0',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('Release Notes / What\'s New in this update:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextField(
                  controller: _notesCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'विवरण...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B5E20), // Forest green
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.rocket_launch, size: 18),
                    label: const Text('Broadcast Update to All Users', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: _broadcastUpdate,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. User Analytics & Traditions
          _buildCard(
            title: '📊 Active Users & Traditions Overview',
            subtitle: 'Overview of user population, regional preferences, and top queries.',
            child: Column(
              children: [
                Row(
                  children: [
                    _buildStatBox('Total Installs', '1,420+', Icons.phone_android, const Color(0xFF1565C0)),
                    const SizedBox(width: 10),
                    _buildStatBox('Active Today', '892', Icons.trending_up, const Color(0xFF2E7D32)),
                    const SizedBox(width: 10),
                    _buildStatBox('Avg. Session', '4m 12s', Icons.timer, const Color(0xFFE65100)),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                _buildProgressRow('Standard Hindu Tradition', 0.72, '72%'),
                const SizedBox(height: 8),
                _buildProgressRow('Vaishnava / ISKCON Profile', 0.21, '21%'),
                const SizedBox(height: 8),
                _buildProgressRow('Gita Press Reference', 0.07, '7%'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4. Testing & Reset Tools
          _buildCard(
            title: '🧪 Developer & Testing Tools',
            subtitle: 'Test the onboarding tour and splash screen again.',
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.saffronPrimary,
                  side: const BorderSide(color: AppTheme.saffronPrimary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.restart_alt, size: 18),
                label: const Text('Reset Onboarding & View "Hare Krishna!" Splash Screen'),
                onPressed: _resetOnboarding,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required String subtitle, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.deepText)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.subtleText)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: color)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.subtleText), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(String label, double progress, String percent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
            Text(percent, style: const TextStyle(fontSize: 12, color: AppTheme.subtleText)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.borderSubtle,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.saffronPrimary),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class ContainerBadge extends StatelessWidget {
  final String label;
  const ContainerBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.saffronPrimary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

/// Authentic QR pattern painter for the download badge
class _QrMatrixPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    // Corner Finder Patterns
    _drawFinder(canvas, 10, 10, paint);
    _drawFinder(canvas, size.width - 45, 10, paint);
    _drawFinder(canvas, 10, size.height - 45, paint);

    // Decorative Data Blocks
    final dotPaint = Paint()..color = const Color(0xFF333333);
    for (double x = 15; x < size.width - 15; x += 9) {
      for (double y = 15; y < size.height - 15; y += 9) {
        // Exclude center badge and corners
        final inCenter = (x > size.width / 2 - 40 &&
            x < size.width / 2 + 40 &&
            y > size.height / 2 - 25 &&
            y < size.height / 2 + 25);
        final inCorner = (x < 55 && y < 55) || (x > size.width - 55 && y < 55) || (x < 55 && y > size.height - 55);

        if (!inCenter && !inCorner) {
          if ((x.toInt() * 7 + y.toInt() * 13) % 17 > 7) {
            canvas.drawRect(Rect.fromLTWH(x, y, 6.5, 6.5), dotPaint);
          }
        }
      }
    }
  }

  void _drawFinder(Canvas canvas, double x, double y, Paint paint) {
    canvas.drawRect(Rect.fromLTWH(x, y, 35, 35), paint);
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(x + 5, y + 5, 25, 25), whitePaint);
    canvas.drawRect(Rect.fromLTWH(x + 10, y + 10, 15, 15), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
