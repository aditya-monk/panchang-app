import 'package:flutter/material.dart';
import '../../../core/constants/panchang_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/location/location_service.dart';
import '../../../services/storage/local_storage_service.dart';
import '../admin/admin_panel_screen.dart';
import '../onboarding/onboarding_screen.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onSettingsChanged;

  const SettingsScreen({super.key, this.onSettingsChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final lang = LocalStorageService.appLanguage;
    final isElder = LocalStorageService.elderMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '⚙️ ${AppLocalizations.tr("settings", lang)}',
          style: TextStyle(fontSize: isElder ? 20 : 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Accessibility & Elder Mode (Section 43)
          _buildSectionHeader(AppLocalizations.tr('accessibility_display', lang), isElder),
          SwitchListTile(
            title: Text(
              AppLocalizations.tr('elder_mode', lang),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: isElder ? 17 : 15),
            ),
            subtitle: Text(
              AppLocalizations.tr('elder_mode_desc', lang),
              style: TextStyle(fontSize: isElder ? 14 : 12.5),
            ),
            value: LocalStorageService.elderMode,
            activeColor: AppTheme.saffronPrimary,
            onChanged: (val) {
              setState(() {
                LocalStorageService.elderMode = val;
              });
              widget.onSettingsChanged?.call();
            },
          ),
          const Divider(),

          // 2. Calendar Tradition & Region (Section 16 & 48)
          _buildSectionHeader(AppLocalizations.tr('panchang_tradition', lang), isElder),
          ListTile(
            title: Text(
              AppLocalizations.tr('calendar_tradition', lang),
              style: TextStyle(fontSize: isElder ? 16 : 14.5, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              _traditionName(LocalStorageService.selectedTradition, lang),
              style: TextStyle(fontSize: isElder ? 14 : 13),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showTraditionDialog,
          ),
          ListTile(
            title: Text(
              AppLocalizations.tr('regional_profile', lang),
              style: TextStyle(fontSize: isElder ? 16 : 14.5, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              LocalStorageService.selectedRegion.name.toUpperCase(),
              style: TextStyle(fontSize: isElder ? 14 : 13),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showRegionDialog,
          ),
          const Divider(),

          // 3. Languages (Section 40 & 41: Voice language can differ from UI language)
          _buildSectionHeader(AppLocalizations.tr('languages', lang), isElder),
          ListTile(
            title: Text(
              AppLocalizations.tr('app_ui_language', lang),
              style: TextStyle(fontSize: isElder ? 16 : 14.5, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              AppLocalizations.languageNames[LocalStorageService.appLanguage] ?? LocalStorageService.appLanguage.toUpperCase(),
              style: TextStyle(fontSize: isElder ? 14 : 13),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showUiLangDialog,
          ),
          ListTile(
            title: Text(
              AppLocalizations.tr('voice_assistant_language', lang),
              style: TextStyle(fontSize: isElder ? 16 : 14.5, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${AppLocalizations.languageNames[LocalStorageService.voiceLanguage] ?? LocalStorageService.voiceLanguage.toUpperCase()} (${AppLocalizations.tr("voice_assistant_language", lang)})',
              style: TextStyle(
                color: AppTheme.saffronPrimary,
                fontWeight: FontWeight.bold,
                fontSize: isElder ? 14 : 13,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showVoiceLangDialog,
          ),
          const Divider(),

          // 4. Locations (Section 44, 45)
          _buildSectionHeader(AppLocalizations.tr('location_management', lang), isElder),
          ListTile(
            leading: const Icon(Icons.my_location, color: AppTheme.saffronPrimary),
            title: Text(
              AppLocalizations.tr('current_location', lang),
              style: TextStyle(fontSize: isElder ? 16 : 14.5, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              LocationService.currentLocation.displayName,
              style: TextStyle(fontSize: isElder ? 14 : 13),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.event_seat, color: AppTheme.deepMaroon),
            title: Text(
              AppLocalizations.tr('event_location_muhurat', lang),
              style: TextStyle(fontSize: isElder ? 16 : 14.5, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              LocationService.activeMuhuratLocation.displayName,
              style: TextStyle(fontSize: isElder ? 14 : 13),
            ),
          ),
          const Divider(),

          // 5. Notifications (Section 47)
          _buildSectionHeader(AppLocalizations.tr('notifications_reminders', lang), isElder),
          SwitchListTile(
            title: Text(
              AppLocalizations.tr('daily_panchang_sunrise', lang),
              style: TextStyle(fontSize: isElder ? 16 : 14.5),
            ),
            value: LocalStorageService.notifyDailyPanchang,
            activeColor: AppTheme.saffronPrimary,
            onChanged: (v) => setState(() => LocalStorageService.notifyDailyPanchang = v),
          ),
          SwitchListTile(
            title: Text(
              AppLocalizations.tr('ekadashi_reminders', lang),
              style: TextStyle(fontSize: isElder ? 16 : 14.5),
            ),
            value: LocalStorageService.notifyEkadashi,
            activeColor: AppTheme.saffronPrimary,
            onChanged: (v) => setState(() => LocalStorageService.notifyEkadashi = v),
          ),
          SwitchListTile(
            title: Text(
              AppLocalizations.tr('ekadashi_parana_window', lang),
              style: TextStyle(fontSize: isElder ? 16 : 14.5),
            ),
            value: LocalStorageService.notifyEkadashiParana,
            activeColor: AppTheme.saffronPrimary,
            onChanged: (v) => setState(() => LocalStorageService.notifyEkadashiParana = v),
          ),
          SwitchListTile(
            title: Text(
              AppLocalizations.tr('major_festivals_vrat', lang),
              style: TextStyle(fontSize: isElder ? 16 : 14.5),
            ),
            value: LocalStorageService.notifyFestivals,
            activeColor: AppTheme.saffronPrimary,
            onChanged: (v) => setState(() => LocalStorageService.notifyFestivals = v),
          ),
          const Divider(),

          // 6. Astronomy Configuration & Licensing Transparency (Section 53A)
          _buildSectionHeader(AppLocalizations.tr('astronomy_transparency', lang), isElder),
          Container(
            padding: EdgeInsets.all(isElder ? 16 : 12),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Astronomical Engine: Pure Dart Meeus/VSOP87 series (Offline)',
                  style: TextStyle(fontSize: isElder ? 14 : 12.5),
                ),
                const SizedBox(height: 6),
                Text(
                  '• Ayanamsa: Lahiri / Chitra Paksha (23° 51\' 25.53")',
                  style: TextStyle(fontSize: isElder ? 14 : 12.5),
                ),
                const SizedBox(height: 6),
                Text(
                  '• Sunrise/Sunset: Standard 50\' depression (-0.8333°)',
                  style: TextStyle(fontSize: isElder ? 14 : 12.5),
                ),
                const SizedBox(height: 6),
                Text(
                  '• Licensing: Permissive MIT. Zero Swiss Ephemeris AGPL code.',
                  style: TextStyle(
                    fontSize: isElder ? 14 : 12.5,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.sacredGreen,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '• Privacy: Privacy-first. All calculations occur locally on device.',
                  style: TextStyle(
                    fontSize: isElder ? 14 : 12.5,
                    color: AppTheme.deepMaroon,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // 7. Onboarding Tour & App Help
          _buildSectionHeader('📖 App Tour & Guide', isElder),
          ListTile(
            leading: const Icon(Icons.explore_outlined, color: AppTheme.saffronPrimary),
            title: Text(
              'Replay App Tour with Voice Guide',
              style: TextStyle(fontSize: isElder ? 16 : 14.5, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Re-listen to the spoken walkthrough of the 4 core sections.',
              style: TextStyle(fontSize: isElder ? 13.5 : 12.5),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OnboardingScreen(
                    onComplete: () => Navigator.pop(context),
                  ),
                ),
              );
            },
          ),
          const Divider(),

          // 8. Admin & Distribution Panel
          _buildSectionHeader('🛠️ Admin & Distribution', isElder),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings, color: Color(0xFF1B5E20)),
            title: Text(
              'Admin Dashboard & Updates',
              style: TextStyle(fontSize: isElder ? 16 : 14.5, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Direct APK download link, QR code generator, and in-app update broadcast.',
              style: TextStyle(fontSize: isElder ? 13.5 : 12.5),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminPanelScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, [bool isElder = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isElder ? 17.5 : 15.0,
          color: AppTheme.deepMaroon,
        ),
      ),
    );
  }

  String _traditionName(CalendarTradition t, [String? langCode]) {
    return AppLocalizations.getTraditionName(t, langCode);
  }

  void _showTraditionDialog() {
    final lang = LocalStorageService.appLanguage;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.tr('select_tradition', lang)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: CalendarTradition.values.map((t) {
            return ListTile(
              title: Text(_traditionName(t, lang)),
              trailing: LocalStorageService.selectedTradition == t
                  ? const Icon(Icons.check, color: AppTheme.saffronPrimary)
                  : null,
              onTap: () {
                setState(() => LocalStorageService.selectedTradition = t);
                widget.onSettingsChanged?.call();
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showRegionDialog() {
    final lang = LocalStorageService.appLanguage;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.tr('select_region', lang)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: RegionalProfile.values.map((r) {
              return ListTile(
                title: Text(r.name.toUpperCase()),
                trailing: LocalStorageService.selectedRegion == r
                    ? const Icon(Icons.check, color: AppTheme.saffronPrimary)
                    : null,
                onTap: () {
                  setState(() => LocalStorageService.selectedRegion = r);
                  widget.onSettingsChanged?.call();
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showUiLangDialog() {
    final lang = LocalStorageService.appLanguage;
    final langs = [
      {'code': 'en', 'title': 'English'},
      {'code': 'hi', 'title': 'हिन्दी'},
      {'code': 'gu', 'title': 'ગુજરાતી'},
      {'code': 'mr', 'title': 'मराठी'},
      {'code': 'bho', 'title': 'भोजपुरी'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.tr('select_ui_lang', lang)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: langs.map((l) {
            final isSelected = LocalStorageService.appLanguage == l['code'];
            return ListTile(
              title: Text(l['title']!, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              trailing: isSelected ? const Icon(Icons.check, color: AppTheme.saffronPrimary) : null,
              onTap: () {
                setState(() => LocalStorageService.appLanguage = l['code']!);
                widget.onSettingsChanged?.call();
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showVoiceLangDialog() {
    final lang = LocalStorageService.appLanguage;
    final langs = [
      {'code': 'en', 'title': 'English'},
      {'code': 'hi', 'title': 'हिन्दी'},
      {'code': 'gu', 'title': 'ગુજરાતી'},
      {'code': 'mr', 'title': 'मराठी'},
      {'code': 'bho', 'title': 'भोजपुरी'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.tr('select_voice_lang', lang)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: langs.map((l) {
            final isSelected = LocalStorageService.voiceLanguage == l['code'];
            return ListTile(
              title: Text(l['title']!, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              trailing: isSelected ? const Icon(Icons.check, color: AppTheme.saffronPrimary) : null,
              onTap: () {
                setState(() => LocalStorageService.voiceLanguage = l['code']!);
                widget.onSettingsChanged?.call();
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
