import 'package:flutter/material.dart';
import '../../../core/constants/panchang_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/location_info.dart';
import '../../../domain/models/panchang_day.dart';
import '../../../services/location/location_service.dart';
import '../../../services/panchang/panchang_service.dart';
import '../../../services/storage/local_storage_service.dart';
import '../today/full_panchang_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
              onTap: _showYearPicker,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Row(
                  children: [
                    Text(
                      '$_selectedYear',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 22),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Tradition Dropdown Switcher per Section 16
            DropdownButton<CalendarTradition>(
              value: _tradition,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.keyboard_arrow_down, size: 18),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.deepMaroon,
              ),
              items: const [
                DropdownMenuItem(
                  value: CalendarTradition.standardHindu,
                  child: Text('Standard Hindu'),
                ),
                DropdownMenuItem(
                  value: CalendarTradition.vaishnavaIskcon,
                  child: Text('Vaishnava / ISKCON'),
                ),
                DropdownMenuItem(
                  value: CalendarTradition.gitaPressReference,
                  child: Text('Gita Press Reference'),
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
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            tooltip: 'Compare Calendars',
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
        ],
      ),
      body: Column(
        children: [
          // View Mode Selector (Year / Month / Day)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildViewTab(CalendarViewMode.year, 'Year View'),
                const SizedBox(width: 8),
                _buildViewTab(CalendarViewMode.month, 'Month View'),
                const SizedBox(width: 8),
                _buildViewTab(CalendarViewMode.day, 'Day View'),
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
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _viewMode = mode),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
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
              fontSize: 13,
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

  // 1. Year View (Section 11 & 15)
  Widget _buildYearView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Annual Overview (Section 15)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.saffronPrimary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.saffronPrimary.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_selectedYear Overview (${_tradition == CalendarTradition.vaishnavaIskcon ? "Vaishnava" : "Standard"})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.deepMaroon),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _OverviewItem(label: 'Ekadashis', count: '24'),
                  _OverviewItem(label: 'Purnimas', count: '12'),
                  _OverviewItem(label: 'Amavasyas', count: '12'),
                  _OverviewItem(label: 'Sankrantis', count: '12'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 12 Months Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.25,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 12,
          itemBuilder: (ctx, idx) {
            final month = idx + 1;
            final monthName = _monthShortName(month);
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
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      monthName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('🌙', style: TextStyle(fontSize: 10)),
                        SizedBox(width: 4),
                        Text('🌕', style: TextStyle(fontSize: 10)),
                        SizedBox(width: 4),
                        Text('🪔', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        // Legend
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: const [
            _LegendItem(icon: '🌙', label: 'Ekadashi'),
            _LegendItem(icon: '🌕', label: 'Purnima'),
            _LegendItem(icon: '🌑', label: 'Amavasya'),
            _LegendItem(icon: '🪔', label: 'Festival'),
            _LegendItem(icon: '●', label: 'Vrat'),
            _LegendItem(icon: '🦚', label: 'Vaishnava'),
          ],
        ),
      ],
    );
  }

  // 2. Month View (Section 12 & 35)
  Widget _buildMonthView() {
    final int daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    final int firstWeekday = DateTime(_selectedYear, _selectedMonth, 1).weekday % 7; // 0=Sun..6=Sat

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Month Navigation Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
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
            Text(
              '${_monthName(_selectedMonth)} $_selectedYear',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
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
        const SizedBox(height: 8),

        // Show Muhurat Overlay Switch (Section 35)
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Show Muhurat Overlay 🪔',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Switch(
              value: _showMuhuratOverlay,
              activeColor: AppTheme.saffronPrimary,
              onChanged: (val) {
                setState(() => _showMuhuratOverlay = val);
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Weekday Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .map((w) => SizedBox(
                    width: 40,
                    child: Text(
                      w,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.subtleText),
                    ),
                  ))
              .toList(),
        ),
        const Divider(height: 16),

        // Month Calendar Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.95,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
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

            final isSelected = date.year == _selectedDay.year &&
                date.month == _selectedDay.month &&
                date.day == _selectedDay.day;

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedDay = date;
                  _viewMode = CalendarViewMode.day;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.saffronPrimary.withOpacity(0.15)
                      : AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppTheme.saffronPrimary : AppTheme.borderSubtle,
                    width: isSelected ? 1.5 : 0.6,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isSelected ? AppTheme.saffronPrimary : AppTheme.deepText,
                      ),
                    ),
                    Text(
                      panchang.tithiName.split(' ').first,
                      style: const TextStyle(fontSize: 9, color: AppTheme.subtleText),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (panchang.isEkadashi)
                          const Text('🌙', style: TextStyle(fontSize: 8)),
                        if (panchang.tithiNumber == 15)
                          const Text('🌕', style: TextStyle(fontSize: 8)),
                        if (panchang.tithiNumber == 30)
                          const Text('🌑', style: TextStyle(fontSize: 8)),
                        if (panchang.festivals.isNotEmpty)
                          const Text('🪔', style: TextStyle(fontSize: 8)),
                        if (_showMuhuratOverlay && (day % 3 == 0))
                          const Text('🏠', style: TextStyle(fontSize: 8)),
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

  // 3. Day View (Section 13)
  Widget _buildDayView() {
    final panchang = PanchangService.calculatePanchang(
      date: _selectedDay,
      location: _location,
      tradition: _tradition,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Date navigation bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _selectedDay = _selectedDay.subtract(const Duration(days: 1));
                });
              },
            ),
            Text(
              '${panchang.vara}, ${_selectedDay.day} ${_monthName(_selectedDay.month)} ${_selectedDay.year}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                setState(() {
                  _selectedDay = _selectedDay.add(const Duration(days: 1));
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Day Summary Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${panchang.lunarMonthName} ${panchang.paksha == Paksha.shukla ? "Shukla" : "Krishna"} ${panchang.tithiName}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.deepMaroon),
                ),
                const SizedBox(height: 4),
                Text('Nakshatra: ${panchang.nakshatraName} | Yoga: ${panchang.yogaName}'),
                Text('Karana: ${panchang.karanaName} | Weekday: ${panchang.vara}'),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('🌅 Astronomical Sunrise: ${_formatTime(panchang.astronomicalSunrise)}'),
                    Text('🌇 Sunset: ${_formatTime(panchang.astronomicalSunset)}'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Events / Observances
        if (panchang.festivals.isNotEmpty || panchang.vrats.isNotEmpty || panchang.vaishnavaEvents.isNotEmpty)
          Card(
            color: const Color(0xFFFFFBEB),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🪔 Festivals & Observances', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 6),
                  ...panchang.festivals.map((f) => Text('• $f', style: const TextStyle(fontSize: 13))),
                  ...panchang.vrats.map((v) => Text('• $v', style: const TextStyle(fontSize: 13, color: AppTheme.deepMaroon))),
                  ...panchang.vaishnavaEvents.map((va) => Text('• 🦚 $va', style: const TextStyle(fontSize: 13, color: AppTheme.sacredGreen))),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),

        // Actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.menu_book),
                label: const Text('Full Panchang'),
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
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.saffronPrimary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.search),
                label: const Text('Find Muhurat'),
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

class _LegendItem extends StatelessWidget {
  final String icon;
  final String label;

  const _LegendItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.subtleText)),
      ],
    );
  }
}
