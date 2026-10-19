import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/location_info.dart';
import '../../../domain/models/panchang_day.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/ekadashi/ekadashi_service.dart';
import '../../../services/location/location_service.dart';
import '../../../services/panchang/panchang_service.dart';
import '../../../services/storage/local_storage_service.dart';
import '../../widgets/now_indicator_card.dart';
import '../../widgets/timeline_view.dart';
import '../settings/settings_screen.dart';
import 'full_panchang_screen.dart';

class TodayScreen extends StatefulWidget {
  final Function(int tabIndex)? onNavigateTab;

  const TodayScreen({super.key, this.onNavigateTab});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  late LocationInfo _location;
  late DateTime _selectedDate;
  late PanchangDay _panchang;

  @override
  void initState() {
    super.initState();
    _location = LocationService.currentLocation;
    _selectedDate = DateTime.now();
    _recalculate();
  }

  void _recalculate() {
    setState(() {
      _panchang = PanchangService.calculatePanchang(
        date: _selectedDate,
        location: _location,
        tradition: LocalStorageService.selectedTradition,
        regionalProfile: LocalStorageService.selectedRegion,
      );
    });
  }

  void _showCitySearchDialog() {
    final TextEditingController searchCtrl = TextEditingController();
    List<LocationInfo> results = LocationService.search('');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Location',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search city (e.g. Ahmedabad, Varanasi)...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.saffronPrimary),
                  filled: true,
                  fillColor: AppTheme.borderSubtle.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  setModalState(() {
                    results = LocationService.search(val);
                  });
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, idx) {
                    final city = results[idx];
                    return ListTile(
                      leading: const Icon(Icons.location_on, color: AppTheme.saffronPrimary),
                      title: Text(city.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${city.coordinatesString} | IST'),
                      onTap: () {
                        LocationService.setCurrentLocation(city);
                        setState(() {
                          _location = city;
                          _recalculate();
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = LocalStorageService.appLanguage;
    final isElder = LocalStorageService.elderMode;
    final nextEkadashi = EkadashiService.getNextEkadashi(
      fromDate: _selectedDate,
      location: _location,
      tradition: LocalStorageService.selectedTradition,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🪔 ${AppLocalizations.tr('app_title', lang)}',
          style: TextStyle(
            fontSize: isElder ? 20 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          InkWell(
            onTap: _showCitySearchDialog,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppTheme.saffronPrimary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.saffronPrimary.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: AppTheme.saffronPrimary),
                  const SizedBox(width: 4),
                  Text(
                    _location.name,
                    style: TextStyle(
                      color: AppTheme.saffronPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: isElder ? 14.5 : 13.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: AppLocalizations.tr('settings', lang),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ).then((_) {
                setState(() {
                  _location = LocationService.currentLocation;
                  _recalculate();
                });
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Date
          Text(
            '${AppLocalizations.getVaraName(_selectedDate.weekday, lang)} · ${_selectedDate.day} ${AppLocalizations.getMonthName(_selectedDate.month, lang)} ${_selectedDate.year}',
            style: TextStyle(
              fontSize: isElder ? 18.0 : 16.0,
              fontWeight: FontWeight.w600,
              color: AppTheme.subtleText,
            ),
          ),
          const SizedBox(height: 8),

          // Live NOW Indicator Card
          NowIndicatorCard(
            panchang: _panchang,
            currentTime: DateTime.now(),
          ),

          // Main Hero Panchang Card
          Container(
            padding: EdgeInsets.all(isElder ? 22 : 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.saffronPrimary.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.saffronPrimary.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalizations.getLunarMonthName(_panchang.lunarMonthName, lang)} ${AppLocalizations.getPakshaName(_panchang.paksha, lang)}',
                      style: TextStyle(
                        fontSize: isElder ? 18.5 : 16.0,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.deepMaroon,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.deepMaroon.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        AppLocalizations.getVaraName(_selectedDate.weekday, lang),
                        style: TextStyle(
                          fontSize: isElder ? 14.0 : 12.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepMaroon,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocalizations.getTithiName(_panchang.tithiNumber, lang),
                  style: TextStyle(
                    fontSize: isElder ? 32 : 27,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.deepText,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${AppLocalizations.tr("nakshatra_label", lang)}: ${AppLocalizations.getNakshatraName(_panchang.nakshatraName, lang)} | ${AppLocalizations.tr("yoga_label", lang)}: ${AppLocalizations.getYogaName(_panchang.yogaName, lang)}',
                  style: TextStyle(
                    fontSize: isElder ? 15.5 : 14.0,
                    color: AppTheme.deepText,
                    height: 1.3,
                  ),
                ),
                const Divider(height: 24),

                // Astronomical Sunrise & Sunset Row (Labelled per 53A.5)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSunStat(
                      icon: '🌅',
                      title: AppLocalizations.tr('astronomical_sunrise', lang),
                      time: _formatTime(_panchang.astronomicalSunrise),
                      isElder: isElder,
                    ),
                    Container(width: 1, height: 40, color: AppTheme.borderSubtle),
                    _buildSunStat(
                      icon: '🌇',
                      title: AppLocalizations.tr('astronomical_sunset', lang),
                      time: _formatTime(_panchang.astronomicalSunset),
                      isElder: isElder,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Important Times Card
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: EdgeInsets.all(isElder ? 18 : 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.tr('popular_occasions', lang).toUpperCase(),
                    style: TextStyle(
                      fontSize: isElder ? 14.5 : 13.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: AppTheme.subtleText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimeBadge(
                          '${AppLocalizations.tr('rahu_kaal', lang)} 🔴',
                          '${_formatTime(_panchang.rahuKaalStart)} – ${_formatTime(_panchang.rahuKaalEnd)}',
                          AppTheme.notSuitableRed,
                          isElder,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTimeBadge(
                          '${AppLocalizations.tr('abhijit_muhurat', lang)} 🟢',
                          '${_formatTime(_panchang.abhijitMuhuratStart)} – ${_formatTime(_panchang.abhijitMuhuratEnd)}',
                          AppTheme.suitableGreen,
                          isElder,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimeBadge(
                          AppLocalizations.tr('yamaganda', lang),
                          '${_formatTime(_panchang.yamagandaStart)} – ${_formatTime(_panchang.yamagandaEnd)}',
                          AppTheme.deepText,
                          isElder,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTimeBadge(
                          AppLocalizations.tr('brahma_muhurat', lang),
                          '${_formatTime(_panchang.brahmaMuhuratStart)} – ${_formatTime(_panchang.brahmaMuhuratEnd)}',
                          Colors.indigo,
                          isElder,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Next Ekadashi Highlight Card
          Card(
            color: const Color(0xFFF0FDF4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFBBF7D0)),
            ),
            child: Padding(
              padding: EdgeInsets.all(isElder ? 18 : 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('🌙', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.localizeFestivalName(nextEkadashi.name, lang),
                            style: TextStyle(
                              fontSize: isElder ? 18.0 : 16.0,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.sacredGreen,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        nextEkadashi.formattedDate,
                        style: TextStyle(
                          fontSize: isElder ? 15.5 : 14.0,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.sacredGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${AppLocalizations.tr("parana_label", lang)}: ${nextEkadashi.formattedParana}',
                    style: TextStyle(
                      fontSize: isElder ? 15.0 : 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.deepText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.localizeFastingRule(nextEkadashi.fastingRule, lang),
                    style: TextStyle(
                      fontSize: isElder ? 13.5 : 12.0,
                      color: AppTheme.subtleText,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Day Timeline View
          DayTimelineView(panchang: _panchang),
          const SizedBox(height: 16),

          // Full Panchang Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.saffronPrimary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: isElder ? 16 : 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.menu_book),
              label: Text(
                AppLocalizations.tr('view_full_panchang', lang),
                style: TextStyle(
                  fontSize: isElder ? 17 : 15.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => FullPanchangScreen(panchang: _panchang),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSunStat({
    required String icon,
    required String title,
    required String time,
    bool isElder = false,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(icon, style: TextStyle(fontSize: isElder ? 20 : 18)),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: isElder ? 14.5 : 13.0,
                color: AppTheme.subtleText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: isElder ? 20 : 17.5,
            fontWeight: FontWeight.bold,
            color: AppTheme.deepText,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeBadge(String title, String time, Color color, [bool isElder = false]) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: isElder ? 9 : 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isElder ? 13.5 : 12.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            time,
            style: TextStyle(
              fontSize: isElder ? 13.0 : 11.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepText,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}
