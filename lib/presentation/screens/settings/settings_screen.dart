import 'package:flutter/material.dart';
import '../../../core/constants/panchang_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/location_info.dart';
import '../../../services/location/location_service.dart';
import '../../../services/storage/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onSettingsChanged;

  const SettingsScreen({super.key, required this.onSettingsChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ Settings & Preferences'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Accessibility & Elder Mode (Section 43)
          _buildSectionHeader('Accessibility & Display'),
          SwitchListTile(
            title: const Text('Elder Mode (बड़े अक्षर)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Increases text size by 25%, enlarges touch targets, and enhances contrast.'),
            value: LocalStorageService.elderMode,
            activeColor: AppTheme.saffronPrimary,
            onChanged: (val) {
              setState(() {
                LocalStorageService.elderMode = val;
              });
              widget.onSettingsChanged();
            },
          ),
          const Divider(),

          // 2. Calendar Tradition & Region (Section 16 & 48)
          _buildSectionHeader('Panchang Tradition'),
          ListTile(
            title: const Text('Calendar Tradition'),
            subtitle: Text(_traditionName(LocalStorageService.selectedTradition)),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showTraditionDialog,
          ),
          ListTile(
            title: const Text('Regional Profile'),
            subtitle: Text(LocalStorageService.selectedRegion.name.toUpperCase()),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showRegionDialog,
          ),
          const Divider(),

          // 3. Languages (Section 40 & 41: Voice language can differ from UI language)
          _buildSectionHeader('Languages'),
          ListTile(
            title: const Text('App UI Language'),
            subtitle: Text(LocalStorageService.appLanguage.toUpperCase()),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showUiLangDialog,
          ),
          ListTile(
            title: const Text('Voice Assistant Language'),
            subtitle: Text(
              '${LocalStorageService.voiceLanguage.toUpperCase()} (Can differ from UI language)',
              style: const TextStyle(color: AppTheme.saffronPrimary, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showVoiceLangDialog,
          ),
          const Divider(),

          // 4. Locations (Section 44, 45)
          _buildSectionHeader('Location Management'),
          ListTile(
            leading: const Icon(Icons.my_location, color: AppTheme.saffronPrimary),
            title: const Text('Current Location'),
            subtitle: Text(LocationService.currentLocation.displayName),
          ),
          ListTile(
            leading: const Icon(Icons.event_seat, color: AppTheme.deepMaroon),
            title: const Text('Event Location (For Muhurat)'),
            subtitle: Text(LocationService.activeMuhuratLocation.displayName),
          ),
          const Divider(),

          // 5. Notifications (Section 47)
          _buildSectionHeader('Notifications & Reminders'),
          SwitchListTile(
            title: const Text('Daily Panchang at Sunrise'),
            value: LocalStorageService.notifyDailyPanchang,
            activeColor: AppTheme.saffronPrimary,
            onChanged: (v) => setState(() => LocalStorageService.notifyDailyPanchang = v),
          ),
          SwitchListTile(
            title: const Text('Ekadashi Reminders'),
            value: LocalStorageService.notifyEkadashi,
            activeColor: AppTheme.saffronPrimary,
            onChanged: (v) => setState(() => LocalStorageService.notifyEkadashi = v),
          ),
          SwitchListTile(
            title: const Text('Ekadashi Parana Window'),
            value: LocalStorageService.notifyEkadashiParana,
            activeColor: AppTheme.saffronPrimary,
            onChanged: (v) => setState(() => LocalStorageService.notifyEkadashiParana = v),
          ),
          SwitchListTile(
            title: const Text('Major Festivals & Vrat'),
            value: LocalStorageService.notifyFestivals,
            activeColor: AppTheme.saffronPrimary,
            onChanged: (v) => setState(() => LocalStorageService.notifyFestivals = v),
          ),
          const Divider(),

          // 6. Astronomy Configuration & Licensing Transparency (Section 53A)
          _buildSectionHeader('Astronomy Engine & Transparency'),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('• Astronomical Engine: Pure Dart Meeus/VSOP87 series (Offline)', style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text('• Ayanamsa: Lahiri / Chitra Paksha (23° 51\' 25.53")', style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text('• Sunrise/Sunset: Standard 50\' depression (-0.8333°)', style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text('• Licensing: Permissive MIT. Zero Swiss Ephemeris AGPL code.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.sacredGreen)),
                SizedBox(height: 4),
                Text('• Privacy: Privacy-first. All calculations occur locally on device.', style: TextStyle(fontSize: 12, color: AppTheme.deepMaroon)),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.deepMaroon),
      ),
    );
  }

  String _traditionName(CalendarTradition t) {
    switch (t) {
      case CalendarTradition.standardHindu:
        return 'Standard Hindu Panchang';
      case CalendarTradition.vaishnavaIskcon:
        return 'Vaishnava / ISKCON Profile';
      case CalendarTradition.gitaPressReference:
        return 'Gita Press Reference';
    }
  }

  void _showTraditionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Calendar Tradition'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: CalendarTradition.values.map((t) {
            return ListTile(
              title: Text(_traditionName(t)),
              trailing: LocalStorageService.selectedTradition == t
                  ? const Icon(Icons.check, color: AppTheme.saffronPrimary)
                  : null,
              onTap: () {
                setState(() => LocalStorageService.selectedTradition = t);
                widget.onSettingsChanged();
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showRegionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Regional Profile'),
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
                  widget.onSettingsChanged();
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
        title: const Text('Select App UI Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: langs.map((l) {
            return ListTile(
              title: Text(l['title']!),
              onTap: () {
                setState(() => LocalStorageService.appLanguage = l['code']!);
                widget.onSettingsChanged();
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showVoiceLangDialog() {
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
        title: const Text('Select Voice Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: langs.map((l) {
            return ListTile(
              title: Text(l['title']!),
              onTap: () {
                setState(() => LocalStorageService.voiceLanguage = l['code']!);
                widget.onSettingsChanged();
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
