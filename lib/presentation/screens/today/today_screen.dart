import 'package:flutter/material.dart';
import '../../../core/constants/panchang_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/location_info.dart';
import '../../../domain/models/panchang_day.dart';
import '../../../services/ekadashi/ekadashi_service.dart';
import '../../../services/location/location_service.dart';
import '../../../services/panchang/panchang_service.dart';
import '../../../services/storage/local_storage_service.dart';
import '../../widgets/now_indicator_card.dart';
import '../../widgets/timeline_view.dart';
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
    final nextEkadashi = EkadashiService.getNextEkadashi(
      fromDate: _selectedDate,
      location: _location,
      tradition: LocalStorageService.selectedTradition,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('🪔 Panchang'),
        actions: [
          InkWell(
            onTap: _showCitySearchDialog,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 16),
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
                    style: const TextStyle(
                      color: AppTheme.saffronPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Date
          Text(
            '${_panchang.vara} · ${_selectedDate.day} ${_monthName(_selectedDate.month)} ${_selectedDate.year}',
            style: const TextStyle(
              fontSize: 16,
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
            padding: const EdgeInsets.all(20),
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
                      '${_panchang.lunarMonthName} ${_panchang.paksha == Paksha.shukla ? "Shukla" : "Krishna"}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.deepMaroon,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.deepMaroon.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _panchang.vara,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepMaroon,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _panchang.tithiName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.deepText,
                  ),
                ),
                Text(
                  'Nakshatra: ${_panchang.nakshatraName} | Yoga: ${_panchang.yogaName}',
                  style: const TextStyle(fontSize: 14, color: AppTheme.deepText),
                ),
                const Divider(height: 24),

                // Astronomical Sunrise & Sunset Row (Labelled per 53A.5)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSunStat(
                      icon: '🌅',
                      title: 'Sunrise',
                      time: _formatTime(_panchang.astronomicalSunrise),
                    ),
                    Container(width: 1, height: 36, color: AppTheme.borderSubtle),
                    _buildSunStat(
                      icon: '🌇',
                      title: 'Sunset',
                      time: _formatTime(_panchang.astronomicalSunset),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Important Times Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'IMPORTANT TIMES',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: AppTheme.subtleText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTimeBadge(
                        'Rahu Kaal 🔴',
                        '${_formatTime(_panchang.rahuKaalStart)} – ${_formatTime(_panchang.rahuKaalEnd)}',
                        AppTheme.notSuitableRed,
                      ),
                      _buildTimeBadge(
                        'Abhijit 🟢',
                        '${_formatTime(_panchang.abhijitMuhuratStart)} – ${_formatTime(_panchang.abhijitMuhuratEnd)}',
                        AppTheme.suitableGreen,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTimeBadge(
                        'Yamaganda',
                        '${_formatTime(_panchang.yamagandaStart)} – ${_formatTime(_panchang.yamagandaEnd)}',
                        AppTheme.deepText,
                      ),
                      _buildTimeBadge(
                        'Brahma Muhurat',
                        '${_formatTime(_panchang.brahmaMuhuratStart)} – ${_formatTime(_panchang.brahmaMuhuratEnd)}',
                        Colors.indigo,
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('🌙', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            nextEkadashi.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.sacredGreen,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        nextEkadashi.formattedDate,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.sacredGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Parana: ${nextEkadashi.formattedParana}',
                    style: const TextStyle(fontSize: 13, color: AppTheme.deepText),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nextEkadashi.fastingRule,
                    style: const TextStyle(fontSize: 12, color: AppTheme.subtleText),
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
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.menu_book),
              label: const Text(
                'View Full Panchang Details',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: AppTheme.subtleText),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.deepText),
        ),
      ],
    );
  }

  Widget _buildTimeBadge(String title, String time, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64) / 2,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.deepText)),
        ],
      ),
    );
  }

  static String _monthName(int month) {
    const m = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return m[month - 1];
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}
