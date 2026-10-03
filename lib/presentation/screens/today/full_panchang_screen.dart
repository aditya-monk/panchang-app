import 'package:flutter/material.dart';
import '../../../core/constants/panchang_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/panchang_day.dart';

class FullPanchangScreen extends StatefulWidget {
  final PanchangDay panchang;

  const FullPanchangScreen({super.key, required this.panchang});

  @override
  State<FullPanchangScreen> createState() => _FullPanchangScreenState();
}

class _FullPanchangScreenState extends State<FullPanchangScreen> {
  bool _isDetailedView = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.panchang;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Panchang'),
        actions: [
          Row(
            children: [
              Text(
                _isDetailedView ? 'Detailed' : 'Simple',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: _isDetailedView,
                activeColor: AppTheme.saffronPrimary,
                onChanged: (val) {
                  setState(() => _isDetailedView = val);
                },
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.saffronPrimary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.saffronPrimary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '📍 ${p.location.displayName}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '${p.localDate.day}/${p.localDate.month}/${p.localDate.year}',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.deepMaroon),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${p.lunarMonthName} Mas · ${p.paksha == Paksha.shukla ? "Shukla Paksha" : "Krishna Paksha"} · ${p.vara}',
                  style: const TextStyle(fontSize: 14, color: AppTheme.subtleText),
                ),
                if (_isDetailedView) ...[
                  const Divider(height: 16),
                  Text(
                    'Tradition: ${p.tradition.name} | Month System: ${p.monthSystem.name.toUpperCase()}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.subtleText),
                  ),
                  Text(
                    'Coordinates: ${p.location.coordinatesString} | TZ: +${p.location.timezoneHours}h',
                    style: const TextStyle(fontSize: 12, color: AppTheme.subtleText),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 5 Limbs (Pancha-Anga)
          _buildSectionTitle('Panchang Elements (पञ्चाङ्ग)'),
          _buildPanchangRow('Tithi (तिथि)', '${p.paksha == Paksha.shukla ? "Shukla" : "Krishna"} ${p.tithiName}',
              'Ends: ${_formatTime(p.tithiEndTime)} (Next: ${p.nextTithiName})'),
          _buildPanchangRow('Nakshatra (नक्षत्र)', p.nakshatraName,
              'Ends: ${_formatTime(p.nakshatraEndTime)} (Pada calculations active)'),
          _buildPanchangRow('Yoga (योग)', p.yogaName, 'Ends: ${_formatTime(p.yogaEndTime)}'),
          _buildPanchangRow('Karana (करण)', p.karanaName, 'Next: ${p.nextKaranaName}'),
          _buildPanchangRow('Vara (वार)', p.vara, 'Solar weekday from sunrise'),
          const SizedBox(height: 16),

          // Astronomical Timings
          _buildSectionTitle('Astronomical Timings (खगोलीय समय)'),
          _buildPanchangRow('Astronomical Sunrise', _formatTime(p.astronomicalSunrise), 'Refraction & dip corrected (50\' depression)'),
          _buildPanchangRow('Astronomical Sunset', _formatTime(p.astronomicalSunset), 'Center of Sun crosses apparent horizon'),
          _buildPanchangRow('Moonrise', p.moonrise != null ? _formatTime(p.moonrise!) : 'No rise today', 'Topocentric parallax corrected'),
          _buildPanchangRow('Moonset', p.moonset != null ? _formatTime(p.moonset!) : 'No set today', 'Local horizon crossing'),
          _buildPanchangRow('Solar Noon', _formatTime(p.solarNoon), 'Madhyahna / Meridian transit'),
          const SizedBox(height: 16),

          // Auspicious & Inauspicious Periods
          _buildSectionTitle('Auspicious & Inauspicious Periods'),
          _buildPanchangRow('Brahma Muhurat 🧘', '${_formatTime(p.brahmaMuhuratStart)} – ${_formatTime(p.brahmaMuhuratEnd)}', '96 min to 48 min before sunrise'),
          _buildPanchangRow('Abhijit Muhurat 🟢', '${_formatTime(p.abhijitMuhuratStart)} – ${_formatTime(p.abhijitMuhuratEnd)}', 'Midday auspicious window'),
          _buildPanchangRow('Rahu Kaal 🔴', '${_formatTime(p.rahuKaalStart)} – ${_formatTime(p.rahuKaalEnd)}', 'Inauspicious daytime octant'),
          _buildPanchangRow('Yamaganda', '${_formatTime(p.yamagandaStart)} – ${_formatTime(p.yamagandaEnd)}', 'Inauspicious daytime octant'),
          _buildPanchangRow('Gulika Kaal', '${_formatTime(p.gulikaStart)} – ${_formatTime(p.gulikaEnd)}', 'Saturnian daytime octant'),
          const SizedBox(height: 16),

          // Choghadiya Section
          _buildSectionTitle('Day Choghadiya (दिन का चौघड़िया)'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: p.dayChoghadiya.map((c) {
              final color = c.isAuspicious ? AppTheme.suitableGreen : AppTheme.notSuitableRed;
              return Container(
                width: (MediaQuery.of(context).size.width - 48) / 2,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.name,
                      style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatTime(c.start)} – ${_formatTime(c.end)}',
                      style: const TextStyle(fontSize: 12, color: AppTheme.deepText),
                    ),
                    Text(
                      c.isAuspicious ? 'Auspicious' : 'Inauspicious',
                      style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.deepMaroon),
      ),
    );
  }

  Widget _buildPanchangRow(String title, String mainValue, String subValue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderSubtle, width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, color: AppTheme.subtleText, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(mainValue, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.deepText)),
              ],
            ),
          ),
          if (_isDetailedView)
            Expanded(
              child: Text(
                subValue,
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 11, color: AppTheme.subtleText),
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
