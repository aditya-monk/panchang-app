import 'package:flutter/material.dart';
import '../../../core/constants/panchang_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/cities.dart';
import '../../../domain/models/location_info.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/location/location_service.dart';
import '../../../services/panchang/panchang_service.dart';
import '../../../services/storage/local_storage_service.dart';
import '../today/full_panchang_screen.dart';
import '../settings/settings_screen.dart';
import 'calendar_comparison_dialog.dart';

enum CalendarViewMode {
  year,
  month,
  day,
}

class CalendarScreen extends StatefulWidget {
  final Function(int tabIndex)? onNavigateTab;

  const CalendarScreen({super.key, this.onNavigateTab});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarViewMode _viewMode = CalendarViewMode.month;
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  DateTime _selectedDay = DateTime.now();

  CalendarTradition _tradition = LocalStorageService.selectedTradition;
  late LocationInfo _location;
  bool _showMuhuratOverlay = false;

  @override
  void initState() {
    super.initState();
    _location = LocationService.currentLocation;
  }

  void _showYearPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        height: 340,
        child: Column(
          children: [
            const Text(
              'Select Any Year (Historical & Future)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2.2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 20, // 2020 to 2039
                itemBuilder: (context, idx) {
                  final year = 2020 + idx;
                  final isSelected = year == _selectedYear;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedYear = year;
                      });
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.saffronPrimary : AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppTheme.saffronPrimary : AppTheme.borderSubtle,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$year',
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.deepText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationPicker() {
    final lang = LocalStorageService.appLanguage;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCities = CityDatabase.cities.where((c) {
              if (searchQuery.trim().isEmpty) return true;
              final q = searchQuery.toLowerCase();
              return c.name.toLowerCase().contains(q) ||
                  c.state.toLowerCase().contains(q) ||
                  c.aliases.any((a) => a.toLowerCase().contains(q));
            }).toList();

            return Container(
              padding: EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '📍 ${AppLocalizations.tr('select_location', lang)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepMaroon,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.tr('search_city', lang),
                      prefixIcon: const Icon(Icons.search, color: AppTheme.saffronPrimary),
                      filled: true,
                      fillColor: AppTheme.borderSubtle.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      setModalState(() {
                        searchQuery = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  // Popular Quick City Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCityChip('Ahmedabad', ctx),
                        _buildCityChip('Varanasi', ctx),
                        _buildCityChip('New Delhi', ctx),
                        _buildCityChip('Mumbai', ctx),
                        _buildCityChip('Bengaluru', ctx),
                        _buildCityChip('Ayodhya', ctx),
                        _buildCityChip('Ujjain', ctx),
                        _buildCityChip('London', ctx),
                        _buildCityChip('New York', ctx),
                      ],
                    ),
                  ),
                  const Divider(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCities.length,
                      itemBuilder: (context, idx) {
                        final city = filteredCities[idx];
                        final isSelected = city.name == _location.name;
                        return ListTile(
                          leading: Icon(
                            Icons.location_city,
                            color: isSelected ? AppTheme.saffronPrimary : AppTheme.subtleText,
                          ),
                          title: Text(
                            city.displayName,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? AppTheme.saffronPrimary : AppTheme.deepText,
                            ),
                          ),
                          subtitle: Text(
                            '${city.latitude.toStringAsFixed(2)}°N, ${city.longitude.toStringAsFixed(2)}°E',
                            style: const TextStyle(fontSize: 11),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: AppTheme.saffronPrimary)
                              : null,
                          onTap: () {
                            setState(() {
                              _location = city;
                              LocalStorageService.currentLocation = city;
                            });
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCityChip(String cityName, BuildContext modalContext) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(cityName, style: const TextStyle(fontSize: 12)),
        onPressed: () {
          final found = CityDatabase.cities.firstWhere(
            (c) => c.name.toLowerCase() == cityName.toLowerCase(),
            orElse: () => _location,
          );
          setState(() {
            _location = found;
            LocalStorageService.currentLocation = found;
          });
          Navigator.pop(modalContext);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = LocalStorageService.appLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Year Selector
            InkWell(
              onTap: _showYearPicker,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    Text(
                      '$_selectedYear',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),

            // Tradition Selector
            DropdownButton<CalendarTradition>(
              value: _tradition,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.keyboard_arrow_down, size: 16),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.deepMaroon,
              ),
              items: [
                DropdownMenuItem(
                  value: CalendarTradition.standardHindu,
                  child: Text(AppLocalizations.tr('standard', lang)),
                ),
                DropdownMenuItem(
                  value: CalendarTradition.vaishnavaIskcon,
                  child: Text(AppLocalizations.tr('vaishnava', lang)),
                ),
                DropdownMenuItem(
                  value: CalendarTradition.gitaPressReference,
                  child: Text(AppLocalizations.tr('gita_press', lang)),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _tradition = val;
                    LocalStorageService.selectedTradition = val;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          // In-Calendar Location Switcher Button (Directly Accessible)
          InkWell(
            onTap: _showLocationPicker,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.saffronPrimary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.saffronPrimary.withOpacity(0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: 14, color: AppTheme.saffronPrimary),
                  const SizedBox(width: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 80),
                    child: Text(
                      _location.name,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.saffronPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 16, color: AppTheme.saffronPrimary),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.compare_arrows, size: 20),
            tooltip: AppLocalizations.tr('compare_calendars', lang),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => CalendarComparisonDialog(
                  date: _selectedDay,
                  location: _location,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, size: 20),
            tooltip: AppLocalizations.tr('settings', lang),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ).then((_) {
                setState(() {
                  _location = LocationService.currentLocation;
                  _tradition = LocalStorageService.selectedTradition;
                });
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // View Mode Selector (Year / Month / Day)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                _buildViewTab(CalendarViewMode.year, AppLocalizations.tr('year_view', lang)),
                const SizedBox(width: 8),
                _buildViewTab(CalendarViewMode.month, AppLocalizations.tr('month_view', lang)),
                const SizedBox(width: 8),
                _buildViewTab(CalendarViewMode.day, AppLocalizations.tr('day_view', lang)),
              ],
            ),
          ),

          // Main View Content
          Expanded(
            child: _buildCurrentView(),
          ),
        ],
      ),
    );
  }

  Widget _buildViewTab(CalendarViewMode mode, String title) {
    final bool active = _viewMode == mode;
    final bool isElder = LocalStorageService.elderMode;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _viewMode = mode),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isElder ? 12 : 10),
          decoration: BoxDecoration(
            color: active ? AppTheme.saffronPrimary : AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active ? AppTheme.saffronPrimary : AppTheme.borderSubtle,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: isElder ? 16.5 : 14.5,
              fontWeight: FontWeight.bold,
              color: active ? Colors.white : AppTheme.deepText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_viewMode) {
      case CalendarViewMode.year:
        return _buildYearView();
      case CalendarViewMode.month:
        return _buildMonthView();
      case CalendarViewMode.day:
        return _buildDayView();
    }
  }

  // 1. Year View
  Widget _buildYearView() {
    final lang = LocalStorageService.appLanguage;
    final bool isElder = LocalStorageService.elderMode;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.saffronPrimary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.saffronPrimary.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_selectedYear Overview (${_tradition == CalendarTradition.vaishnavaIskcon ? AppLocalizations.tr("vaishnava", lang) : AppLocalizations.tr("standard", lang)})',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isElder ? 18 : 16,
                  color: AppTheme.deepMaroon,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _OverviewItem(label: AppLocalizations.tr('ekadashis', lang), count: '24'),
                  _OverviewItem(label: AppLocalizations.tr('purnimas', lang), count: '12'),
                  _OverviewItem(label: AppLocalizations.tr('amavasyas', lang), count: '12'),
                  _OverviewItem(label: AppLocalizations.tr('sankrantis', lang), count: '12'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.35,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 12,
          itemBuilder: (ctx, idx) {
            final month = idx + 1;
            final monthName = AppLocalizations.getMonthShortName(month, lang);
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedMonth = month;
                  _viewMode = CalendarViewMode.month;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      monthName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isElder ? 18 : 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('🌙', style: TextStyle(fontSize: 13)),
                        SizedBox(width: 4),
                        Text('🌕', style: TextStyle(fontSize: 13)),
                        SizedBox(width: 4),
                        Text('🪔', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // 2. Month View Overhaul
  Widget _buildMonthView() {
    final lang = LocalStorageService.appLanguage;
    final int daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    final int firstWeekday = DateTime(_selectedYear, _selectedMonth, 1).weekday % 7; // 0=Sun..6=Sat
    final weekdays = AppLocalizations.getWeekdays(lang);
    final now = DateTime.now();

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final bool isElder = LocalStorageService.elderMode;
        final double elderMultiplier = isElder ? 1.25 : 1.0;
        final double widthMultiplier = (availableWidth / 440.0).clamp(0.95, 1.45);
        final double scale = widthMultiplier * elderMultiplier;

        final double dayNumFontSize = (14.5 * scale).clamp(13.5, 22.0);
        final double tithiFontSize = (10.5 * scale).clamp(9.8, 15.5);
        final double badgeFontSize = (9.8 * scale).clamp(9.2, 14.5);
        final double badgeIconSize = (11.5 * scale).clamp(11.0, 16.5);
        final double cellAspectRatio = availableWidth > 580 ? 0.88 : 0.68;

        final midMonthPanchang = PanchangService.calculatePanchang(
          date: DateTime(_selectedYear, _selectedMonth, 15),
          location: _location,
          tradition: _tradition,
        );
        final int samvat = _selectedYear + (_selectedMonth < 4 ? 56 : 57);
        final hinduMonthTitle = '${AppLocalizations.getLunarMonthName(midMonthPanchang.lunarMonthName, lang)} · ${AppLocalizations.tr("vikram_samvat", lang)} $samvat';

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            // Month Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: (26.0 * scale).clamp(24.0, 32.0), color: AppTheme.deepMaroon),
                    onPressed: () {
                      setState(() {
                        if (_selectedMonth == 1) {
                          _selectedMonth = 12;
                          _selectedYear--;
                        } else {
                          _selectedMonth--;
                        }
                      });
                    },
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${AppLocalizations.getMonthName(_selectedMonth, lang)} $_selectedYear',
                            style: TextStyle(
                              fontSize: (18.5 * scale).clamp(17.0, 24.0),
                              fontWeight: FontWeight.bold,
                              color: AppTheme.deepMaroon,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Quick "Today" jump button
                          InkWell(
                            onTap: () {
                              setState(() {
                                _selectedYear = now.year;
                                _selectedMonth = now.month;
                                _selectedDay = now;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.saffronPrimary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.saffronPrimary.withOpacity(0.4)),
                              ),
                              child: Text(
                                AppLocalizations.tr('today_btn', lang),
                                style: TextStyle(
                                  fontSize: (12.0 * scale).clamp(11.5, 15.0),
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.saffronPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hinduMonthTitle,
                        style: TextStyle(
                          fontSize: (12.5 * scale).clamp(12.0, 16.0),
                          fontWeight: FontWeight.w600,
                          color: AppTheme.saffronPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, size: (26.0 * scale).clamp(24.0, 32.0), color: AppTheme.deepMaroon),
                    onPressed: () {
                      setState(() {
                        if (_selectedMonth == 12) {
                          _selectedMonth = 1;
                          _selectedYear++;
                        } else {
                          _selectedMonth++;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Show Muhurat Overlay Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${AppLocalizations.tr('show_muhurat_overlay', lang)} 🪔',
                  style: TextStyle(
                    fontSize: (13.0 * scale).clamp(12.0, 16.5),
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepText,
                  ),
                ),
                Transform.scale(
                  scale: (0.85 * scale).clamp(0.8, 1.1),
                  child: Switch(
                    value: _showMuhuratOverlay,
                    activeColor: AppTheme.saffronPrimary,
                    onChanged: (val) {
                      setState(() => _showMuhuratOverlay = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Weekday Headers (7 Expanded columns perfectly matching the GridView!)
            Row(
              children: weekdays
                  .map((w) => Expanded(
                        child: Center(
                          child: Text(
                            w,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: (13.5 * scale).clamp(12.5, 17.5),
                              color: AppTheme.deepMaroon,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const Divider(height: 12),

            // Redesigned Month Grid with Prominent Occasion & Festival Names
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: cellAspectRatio,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
              ),
              itemCount: firstWeekday + daysInMonth,
              itemBuilder: (ctx, idx) {
                if (idx < firstWeekday) return const SizedBox.shrink();
                final day = idx - firstWeekday + 1;
                final date = DateTime(_selectedYear, _selectedMonth, day);
                final panchang = PanchangService.calculatePanchang(
                  date: date,
                  location: _location,
                  tradition: _tradition,
                );

                final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
                final isSelected = date.year == _selectedDay.year &&
                    date.month == _selectedDay.month &&
                    date.day == _selectedDay.day;

                // Identify key occasions & festival name
                String? ekadashiName;
                if (panchang.isEkadashi) {
                  ekadashiName = panchang.festivals.firstWhere(
                    (f) => f.toLowerCase().contains('ekadashi') || f.contains('एकादशी'),
                    orElse: () => 'Ekadashi',
                  );
                }

                String? majorFestivalName;
                if (panchang.festivals.isNotEmpty) {
                  final nonEkadashi = panchang.festivals.where(
                    (f) => !f.toLowerCase().contains('ekadashi') && !f.contains('एकादशी'),
                  ).toList();
                  if (nonEkadashi.isNotEmpty) {
                    majorFestivalName = nonEkadashi.first;
                  }
                }

                final bool isPurnima = panchang.tithiNumber == 15;
                final bool isAmavasya = panchang.tithiNumber == 30;

                // Background color logic
                Color cellBg = AppTheme.cardBackground;
                if (isSelected) {
                  cellBg = AppTheme.saffronPrimary.withOpacity(0.14);
                } else if (isToday) {
                  cellBg = const Color(0xFFFFF9C4).withOpacity(0.4); // soft golden glow
                } else if (panchang.isEkadashi) {
                  cellBg = const Color(0xFFF1F8E9); // soft green tint
                } else if (isPurnima) {
                  cellBg = const Color(0xFFFFFDE7); // soft amber tint
                }

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDay = date;
                      _viewMode = CalendarViewMode.day;
                    });
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cellBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.saffronPrimary
                            : (isToday ? AppTheme.saffronPrimary : AppTheme.borderSubtle),
                        width: isSelected ? 1.8 : (isToday ? 1.4 : 0.6),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top: Date Number & Tithi Abbrev
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$day',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: dayNumFontSize,
                                color: isToday
                                    ? AppTheme.saffronPrimary
                                    : (isSelected ? AppTheme.deepMaroon : AppTheme.deepText),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                AppLocalizations.getShortTithi(panchang.tithiNumber, panchang.paksha, lang),
                                style: TextStyle(
                                  fontSize: tithiFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: isToday ? AppTheme.saffronPrimary : AppTheme.subtleText,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),

                        // Badges Section (Highlighting Key Occasions by Name)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // 1. Ekadashi Badge
                              if (panchang.isEkadashi)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 2),
                                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFFA5D6A7), width: 0.5),
                                  ),
                                  child: Text(
                                    '🌙 ${AppLocalizations.localizeFestivalName(ekadashiName ?? "Ekadashi", lang)}',
                                    style: TextStyle(
                                      fontSize: badgeFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF2E7D32),
                                      height: 1.1,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                              // 2. Purnima Badge
                              if (isPurnima)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 2),
                                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF8E1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFFFFE082), width: 0.5),
                                  ),
                                  child: Text(
                                    '🌕 ${AppLocalizations.tr("purnima", lang)}',
                                    style: TextStyle(
                                      fontSize: badgeFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFE65100),
                                      height: 1.1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                              // 3. Amavasya Badge
                              if (isAmavasya)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 2),
                                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECEFF1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFFCFD8DC), width: 0.5),
                                  ),
                                  child: Text(
                                    '🌑 ${AppLocalizations.tr("amavasya", lang)}',
                                    style: TextStyle(
                                      fontSize: badgeFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF37474F),
                                      height: 1.1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                              // 4. Major Festival Badge
                              if (majorFestivalName != null)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 2),
                                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF3E0),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFFFFCC80), width: 0.5),
                                  ),
                                  child: Text(
                                    '🪔 ${AppLocalizations.localizeFestivalName(majorFestivalName, lang)}',
                                    style: TextStyle(
                                      fontSize: badgeFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFD84315),
                                      height: 1.1,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                              // 5. Muhurat Overlay Badge
                              if (_showMuhuratOverlay && (day % 3 == 0))
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDE7F6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '🏠 ${AppLocalizations.tr("muhurat", lang)}',
                                    style: TextStyle(
                                      fontSize: (badgeFontSize * 0.95).clamp(8.8, 13.0),
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF512DA8),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Prominent Visual Legends Card (Directly Below Grid)
            Container(
              margin: const EdgeInsets.only(top: 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 18, color: AppTheme.saffronPrimary),
                      const SizedBox(width: 6),
                      Text(
                        AppLocalizations.tr('legend', lang),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (14.0 * scale).clamp(13.0, 18.0),
                          color: AppTheme.deepMaroon,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildLegendBadge(
                        '🌙',
                        AppLocalizations.tr('legend_ekadashi', lang),
                        const Color(0xFFE8F5E9),
                        const Color(0xFF2E7D32),
                        scale,
                      ),
                      _buildLegendBadge(
                        '🌕',
                        AppLocalizations.tr('legend_purnima', lang),
                        const Color(0xFFFFF8E1),
                        const Color(0xFFE65100),
                        scale,
                      ),
                      _buildLegendBadge(
                        '🌑',
                        AppLocalizations.tr('legend_amavasya', lang),
                        const Color(0xFFECEFF1),
                        const Color(0xFF37474F),
                        scale,
                      ),
                      _buildLegendBadge(
                        '🪔',
                        AppLocalizations.tr('legend_festival', lang),
                        const Color(0xFFFFF3E0),
                        const Color(0xFFD84315),
                        scale,
                      ),
                      _buildLegendBadge(
                        '🏠',
                        AppLocalizations.tr('legend_muhurat', lang),
                        const Color(0xFFEDE7F6),
                        const Color(0xFF512DA8),
                        scale,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendBadge(String icon, String label, Color bg, Color textColor, [double scale = 1.0]) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (10.0 * scale).clamp(8.0, 16.0),
        vertical: (5.0 * scale).clamp(4.0, 8.0),
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withOpacity(0.3), width: 0.6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: TextStyle(fontSize: (13.0 * scale).clamp(12.0, 17.0))),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: (12.5 * scale).clamp(11.5, 16.0),
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _shortTithi(String fullTithi, Paksha paksha) {
    final prefix = paksha == Paksha.shukla ? 'शु.' : 'कृ.';
    final parts = fullTithi.split(' ');
    final name = parts.isNotEmpty ? parts.first : fullTithi;
    return '$prefix$name';
  }

  // 3. Day View
  Widget _buildDayView() {
    final lang = LocalStorageService.appLanguage;
    final isElder = LocalStorageService.elderMode;
    final panchang = PanchangService.calculatePanchang(
      date: _selectedDay,
      location: _location,
      tradition: _tradition,
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Date navigation bar
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.saffronPrimary.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () {
                  setState(() {
                    _selectedDay = _selectedDay.subtract(const Duration(days: 1));
                  });
                },
              ),
              Expanded(
                child: Text(
                  '${AppLocalizations.getVaraName(_selectedDay.weekday, lang)}, ${_selectedDay.day} ${AppLocalizations.getMonthName(_selectedDay.month, lang)} ${_selectedDay.year}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isElder ? 18.5 : 16.0,
                    color: AppTheme.deepMaroon,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 20),
                onPressed: () {
                  setState(() {
                    _selectedDay = _selectedDay.add(const Duration(days: 1));
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Day Summary Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: EdgeInsets.all(isElder ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.getLunarMonthName(panchang.lunarMonthName, lang)} ${AppLocalizations.getPakshaName(panchang.paksha, lang)} ${AppLocalizations.getTithiName(panchang.tithiNumber, lang)}',
                  style: TextStyle(
                    fontSize: isElder ? 22 : 19.5,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.deepMaroon,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${AppLocalizations.tr("nakshatra_label", lang)}: ${AppLocalizations.getNakshatraName(panchang.nakshatraName, lang)}   |   ${AppLocalizations.tr("yoga_label", lang)}: ${AppLocalizations.getYogaName(panchang.yogaName, lang)}',
                  style: TextStyle(
                    fontSize: isElder ? 15.5 : 14.0,
                    color: AppTheme.deepText,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppLocalizations.tr("karana_label", lang)}: ${AppLocalizations.getKaranaName(panchang.karanaName, lang)}   |   ${AppLocalizations.tr("vara_label", lang)}: ${AppLocalizations.getVaraName(_selectedDay.weekday, lang)}',
                  style: TextStyle(
                    fontSize: isElder ? 15.5 : 14.0,
                    color: AppTheme.deepText,
                    height: 1.35,
                  ),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '🌅 ${AppLocalizations.tr("astronomical_sunrise", lang)}: ${_formatTime(panchang.astronomicalSunrise)}',
                      style: TextStyle(
                        fontSize: isElder ? 15.0 : 13.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber.shade900,
                      ),
                    ),
                    Text(
                      '🌇 ${AppLocalizations.tr("astronomical_sunset", lang)}: ${_formatTime(panchang.astronomicalSunset)}',
                      style: TextStyle(
                        fontSize: isElder ? 15.0 : 13.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrange.shade800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Events / Observances
        if (panchang.festivals.isNotEmpty || panchang.vrats.isNotEmpty || panchang.vaishnavaEvents.isNotEmpty)
          Card(
            color: const Color(0xFFFFFBEB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFFFE082), width: 1),
            ),
            elevation: 1,
            child: Padding(
              padding: EdgeInsets.all(isElder ? 18 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🪔', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.tr('all_festivals', lang),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isElder ? 17.0 : 15.0,
                          color: AppTheme.deepMaroon,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...panchang.festivals.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '• ${AppLocalizations.localizeFestivalName(f, lang)}',
                        style: TextStyle(
                          fontSize: isElder ? 15.5 : 14.0,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.deepText,
                        ),
                      ),
                    ),
                  ),
                  ...panchang.vrats.map(
                    (v) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '• $v',
                        style: TextStyle(
                          fontSize: isElder ? 15.5 : 14.0,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.deepMaroon,
                        ),
                      ),
                    ),
                  ),
                  ...panchang.vaishnavaEvents.map(
                    (va) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '• 🦚 $va',
                        style: TextStyle(
                          fontSize: isElder ? 15.5 : 14.0,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.sacredGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 18),

        // Actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: isElder ? 14 : 12),
                  side: const BorderSide(color: AppTheme.deepMaroon),
                ),
                icon: const Icon(Icons.menu_book, color: AppTheme.deepMaroon),
                label: Text(
                  AppLocalizations.tr('view_full_panchang', lang),
                  style: TextStyle(
                    fontSize: isElder ? 15.5 : 14.0,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.deepMaroon,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => FullPanchangScreen(panchang: panchang),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.saffronPrimary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: isElder ? 14 : 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.search),
                label: Text(
                  AppLocalizations.tr('find_muhurat', lang),
                  style: TextStyle(
                    fontSize: isElder ? 15.5 : 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (widget.onNavigateTab != null) {
                    widget.onNavigateTab!(2); // Go to Muhurat tab
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _monthName(int month) {
    const m = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return m[month - 1];
  }

  static String _monthShortName(int month) {
    const m = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return m[month - 1];
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}

class _OverviewItem extends StatelessWidget {
  final String label;
  final String count;

  const _OverviewItem({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.deepText)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.subtleText)),
      ],
    );
  }
}
