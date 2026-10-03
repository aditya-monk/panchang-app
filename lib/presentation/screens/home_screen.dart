import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      TodayScreen(onNavigateTab: _navigateToTab),
      CalendarScreen(onNavigateTab: _navigateToTab),
      const MuhuratScreen(),
      const AskScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentTab,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (idx) => setState(() => _currentTab = idx),
        indicatorColor: AppTheme.saffronPrimary.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            selectedIcon: Icon(Icons.wb_sunny, color: AppTheme.saffronPrimary),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month, color: AppTheme.saffronPrimary),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.flare_outlined),
            selectedIcon: Icon(Icons.flare, color: AppTheme.saffronPrimary),
            label: 'Muhurat',
          ),
          NavigationDestination(
            icon: Icon(Icons.mic_none_outlined),
            selectedIcon: Icon(Icons.mic, color: AppTheme.saffronPrimary),
            label: 'Ask',
          ),
        ],
      ),
      floatingActionButton: _currentTab == 0
          ? FloatingActionButton.small(
              backgroundColor: AppTheme.cardBackground,
              foregroundColor: AppTheme.deepText,
              elevation: 2,
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
            )
          : null,
    );
  }
}
