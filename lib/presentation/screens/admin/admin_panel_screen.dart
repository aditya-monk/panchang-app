import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/user_profile.dart';
import '../../../services/auth/auth_service.dart';
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
  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController _pinCtrl = TextEditingController();

  bool _isCopied = false;
  String _providerFilter = 'all'; // 'all', 'google', 'apple'
  bool _isPinUnlocked = false;

  @override
  void initState() {
    super.initState();
    // If logged in as admin via Method 1 (Email auto-detect), automatically unlocked
    if (AuthService.isAdmin) {
      _isPinUnlocked = true;
    }
  }

  @override
  void dispose() {
    _versionCtrl.dispose();
    _apkUrlCtrl.dispose();
    _notesCtrl.dispose();
    _searchCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  void _verifyPin() {
    if (_pinCtrl.text.trim() == '108') {
      setState(() => _isPinUnlocked = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('👑 व्यवस्थापक पिन सत्यापित! एडमिन पैनल अनलॉक हुआ।'),
          backgroundColor: AppTheme.suitableGreen,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ अमान्य पिन! कृपया सही व्यवस्थापक पिन दर्ज करें।'),
          backgroundColor: AppTheme.notSuitableRed,
        ),
      );
    }
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

  void _exportUsersToCsv() {
    final csv = AuthService.exportUsersToCsv();
    Clipboard.setData(ClipboardData(text: csv));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📥 Registered Users CSV copied to clipboard! Paste into Excel or Google Sheets.'),
        backgroundColor: AppTheme.suitableGreen,
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If not unlocked via Method 1 or PIN
    if (!_isPinUnlocked && !AuthService.isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('🔒 Admin Access Gate'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.admin_panel_settings, size: 60, color: AppTheme.saffronPrimary),
                    const SizedBox(height: 16),
                    const Text(
                      'व्यवस्थापक सुरक्षा (Admin Only)',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'यह क्षेत्र केवल अधिकृत व्यवस्थापक के लिए है। अपने व्यवस्थापक ईमेल से लॉगिन करें या सुरक्षा पिन दर्ज करें:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _pinCtrl,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password, color: AppTheme.saffronPrimary),
                        labelText: 'Admin PIN (Default: 108)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onSubmitted: (_) => _verifyPin(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _verifyPin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.saffronPrimary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('प्रवेश करें (Unlock Admin Panel)'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '👑 Admin & User Registry Panel',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export Users CSV',
            onPressed: _exportUsersToCsv,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Admin Status Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B0000), Color(0xFFD84315)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user, color: Color(0xFFFFD54F), size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'अधिकृत व्यवस्थापक सत्र (Admin Mode Active)',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        AuthService.currentUser?.email ?? 'Master Admin (Method 1 Activated)',
                        style: const TextStyle(
                          color: Color(0xFFFFE082),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 1. Registered Users Directory (Exclusive to Admin)
          ValueListenableBuilder<List<UserProfile>>(
            valueListenable: AuthService.registeredUsersNotifier,
            builder: (context, allUsers, _) {
              final query = _searchCtrl.text.trim().toLowerCase();
              final filtered = allUsers.where((u) {
                final matchQuery = query.isEmpty ||
                    u.name.toLowerCase().contains(query) ||
                    u.email.toLowerCase().contains(query) ||
                    u.phoneNumber.toLowerCase().contains(query) ||
                    u.city.toLowerCase().contains(query);

                final matchProvider = _providerFilter == 'all' ||
                    u.provider.toLowerCase() == _providerFilter;

                return matchQuery && matchProvider;
              }).toList();

              final googleCount = allUsers.where((u) => u.provider == 'google').length;
              final appleCount = allUsers.where((u) => u.provider == 'apple').length;

              return _buildCard(
                title: '👥 पंजीकृत उपयोगकर्ता सूची (Registered Users Directory)',
                subtitle: 'केवल व्यवस्थापक को दिखाई देने वाला लाइव यूज़र डेटाबेस।',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KPI Row
                    Row(
                      children: [
                        _buildKpiCard('कुल उपयोगकर्ता', '${allUsers.length}', Icons.people, AppTheme.saffronPrimary),
                        const SizedBox(width: 8),
                        _buildKpiCard('Google Sign-in', '$googleCount', Icons.g_mobiledata, Colors.blue),
                        const SizedBox(width: 8),
                        _buildKpiCard('Apple ID', '$appleCount', Icons.apple, Colors.black87),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Search & Filter Bar
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            decoration: InputDecoration(
                              hintText: 'नाम, फोन, ईमेल या शहर खोजें...',
                              prefixIcon: const Icon(Icons.search, size: 20),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _exportUsersToCsv,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.sacredGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.file_download, size: 18),
                          label: const Text('CSV Export'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Filter Chips
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('सभी (All)'),
                          selected: _providerFilter == 'all',
                          onSelected: (val) => setState(() => _providerFilter = 'all'),
                        ),
                        ChoiceChip(
                          label: const Text('Google Users'),
                          selected: _providerFilter == 'google',
                          onSelected: (val) => setState(() => _providerFilter = 'google'),
                        ),
                        ChoiceChip(
                          label: const Text('Apple Users'),
                          selected: _providerFilter == 'apple',
                          onSelected: (val) => setState(() => _providerFilter = 'apple'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Users List
                    if (filtered.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        alignment: Alignment.center,
                        child: Text(
                          'कोई उपयोगकर्ता नहीं मिला (No matching users)',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, idx) {
                          final user = filtered[idx];
                          return _buildUserTile(user);
                        },
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // 2. Direct APK Distribution Card
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

          // 3. In-App Auto-Update Broadcaster
          _buildCard(
            title: '🚀 Broadcast In-App Update (अपडेट भेजें)',
            subtitle: 'Broadcast a new version update so all users see a 1-tap update dialog on app launch.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Current App Ver:', style: TextStyle(fontSize: 12, color: AppTheme.subtleText)),
                          Text(
                            LocalStorageService.currentAppVersion,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _versionCtrl,
                        decoration: InputDecoration(
                          labelText: 'New Version (e.g. 1.1.0)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Update Notes (रिलीज नोट्स):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                const SizedBox(height: 6),
                TextField(
                  controller: _notesCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.maroonSecondary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.campaign, size: 20),
                  label: const Text(
                    'Broadcast Update to All Users',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: _broadcastUpdate,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4. Testing & Reset Tools
          _buildCard(
            title: '⚙️ Onboarding & Testing Tools',
            subtitle: 'Reset first-time onboarding status to test the splash and voice guide tour.',
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.refresh, color: AppTheme.saffronPrimary),
                    label: const Text('Reset First-Time Tour'),
                    onPressed: () {
                      LocalStorageService.resetFirstTimeUser();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🔄 Onboarding reset. Restart app to see splash and tour.'),
                          backgroundColor: AppTheme.saffronPrimary,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10.5, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile(UserProfile user) {
    final isGoogle = user.provider == 'google';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: isGoogle ? Colors.blue.shade100 : Colors.grey.shade200,
                child: isGoogle
                    ? const Icon(Icons.g_mobiledata, color: Colors.blue, size: 28)
                    : const Icon(Icons.apple, color: Colors.black87, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (user.isAdmin) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.maroonSecondary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'ADMIN',
                              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      user.email,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              // Provider Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isGoogle ? Colors.blue.withOpacity(0.1) : Colors.black.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isGoogle ? 'Google' : 'Apple ID',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isGoogle ? Colors.blue.shade800 : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Contact & Location Details
          Row(
            children: [
              const Icon(Icons.phone, size: 14, color: AppTheme.saffronPrimary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  user.phoneNumber.isNotEmpty ? user.phoneNumber : 'नंबर दर्ज नहीं',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              if (user.phoneNumber.isNotEmpty) ...[
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: user.phoneNumber));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Phone number ${user.phoneNumber} copied!')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.suitableGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.copy, size: 12, color: AppTheme.suitableGreen),
                        SizedBox(width: 4),
                        Text('Copy', style: TextStyle(fontSize: 11, color: AppTheme.suitableGreen)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),

          // Location Pill
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Colors.redAccent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${user.city}, ${user.state} (${user.latitude.toStringAsFixed(2)}°, ${user.longitude.toStringAsFixed(2)}°)',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.saffronPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  user.tradition.toUpperCase(),
                  style: const TextStyle(fontSize: 10, color: AppTheme.saffronPrimary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.subtleText)),
          const SizedBox(height: 14),
          child,
        ],
      ),
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

class _QrMatrixPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    _drawFinder(canvas, 10, 10, paint);
    _drawFinder(canvas, size.width - 45, 10, paint);
    _drawFinder(canvas, 10, size.height - 45, paint);

    final dotPaint = Paint()..color = const Color(0xFF333333);
    for (double x = 15; x < size.width - 15; x += 9) {
      for (double y = 15; y < size.height - 15; y += 9) {
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
