import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/storage/local_storage_service.dart';
import 'ask/ask_screen.dart';
import 'calendar/calendar_screen.dart';
import 'muhurat/muhurat_screen.dart';
import 'settings/settings_screen.dart';
import 'today/today_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onRefreshTheme;

  const HomeScreen({super.key, required this.onRefreshTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.system_update, color: AppTheme.saffronPrimary),
            const SizedBox(width: 10),
            Text('नया अपडेट उपलब्ध (v${LocalStorageService.latestBroadcastVersion})'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'नया संस्करण उपलब्ध है। नए त्योहार, शुद्ध एकादशी पारणा समय और सुधार जोड़े गए हैं।',
              style: TextStyle(fontSize: 13.5),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.saffronPrimary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'विवरण: ${LocalStorageService.updateNotes}',
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              LocalStorageService.dismissUpdate();
              Navigator.pop(ctx);
            },
            child: const Text('बाद में (Later)'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.saffronPrimary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.download, size: 18),
            label: const Text('डाउनलोड करें (Download APK)'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: LocalStorageService.apkDownloadUrl));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('APK Download link copied to clipboard! Opening download...'),
                  backgroundColor: AppTheme.suitableGreen,
                ),
              );
              LocalStorageService.dismissUpdate();
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = LocalStorageService.appLanguage;

    final List<Widget> screens = [
      TodayScreen(onNavigateTab: _navigateToTab),
      CalendarScreen(onNavigateTab: _navigateToTab),
      const MuhuratScreen(),
      const AskScreen(),
    ];

    return Scaffold(
      body: Column(
        children: [
          // In-App Update Banner (Visible when Admin broadcasts a new version)
          ValueListenableBuilder<bool>(
            valueListenable: LocalStorageService.updateAvailableNotifier,
            builder: (context, hasUpdate, _) {
              if (!hasUpdate) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color(0xFF1B5E20), // Forest green update bar
                child: Row(
                  children: [
                    const Icon(Icons.system_update, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '🔔 नया अपडेट उपलब्ध (v${LocalStorageService.latestBroadcastVersion})!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1B5E20),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      onPressed: () => _showUpdateDialog(context),
                      child: const Text('अपडेट करें'),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => LocalStorageService.dismissUpdate(),
                    ),
                  ],
                ),
              );
            },
          ),

          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 880),
                child: IndexedStack(
                  index: _currentTab,
                  children: screens,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Center(
        heightFactor: 1.0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child: NavigationBar(
            selectedIndex: _currentTab,
            onDestinationSelected: (idx) => setState(() => _currentTab = idx),
            indicatorColor: AppTheme.saffronPrimary.withOpacity(0.2),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.wb_sunny_outlined),
                selectedIcon: const Icon(Icons.wb_sunny, color: AppTheme.saffronPrimary),
                label: AppLocalizations.tr('tab_today', lang),
              ),
              NavigationDestination(
                icon: const Icon(Icons.calendar_month_outlined),
                selectedIcon: const Icon(Icons.calendar_month, color: AppTheme.saffronPrimary),
                label: AppLocalizations.tr('tab_calendar', lang),
              ),
              NavigationDestination(
                icon: const Icon(Icons.flare_outlined),
                selectedIcon: const Icon(Icons.flare, color: AppTheme.saffronPrimary),
                label: AppLocalizations.tr('tab_muhurat', lang),
              ),
              NavigationDestination(
                icon: const Icon(Icons.mic_none_outlined),
                selectedIcon: const Icon(Icons.mic, color: AppTheme.saffronPrimary),
                label: AppLocalizations.tr('tab_ask', lang),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: AppTheme.cardBackground,
        foregroundColor: AppTheme.deepText,
        elevation: 2,
        tooltip: AppLocalizations.tr('settings', lang),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => SettingsScreen(
                onSettingsChanged: widget.onRefreshTheme,
              ),
            ),
          );
        },
        child: const Icon(Icons.settings, size: 20),
      ),
    );
  }
}
