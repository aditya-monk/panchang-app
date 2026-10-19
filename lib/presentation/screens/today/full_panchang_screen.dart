import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/panchang_day.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/storage/local_storage_service.dart';
import '../settings/settings_screen.dart';

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
    final lang = LocalStorageService.appLanguage;
    final isElder = LocalStorageService.elderMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.tr('view_full_panchang', lang),
          style: TextStyle(fontSize: isElder ? 20 : 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              Text(
                _isDetailedView
                    ? AppLocalizations.tr('detailed_view', lang)
                    : AppLocalizations.tr('simple_view', lang),
                style: TextStyle(
                  fontSize: isElder ? 14 : 12.5,
                  fontWeight: FontWeight.bold,
                ),
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
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: AppLocalizations.tr('settings', lang),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ).then((_) => setState(() {}));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header info
              Container(
                padding: EdgeInsets.all(isElder ? 18 : 15),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isElder ? 18 : 16,
                          ),
                        ),
                        Text(
                          '${p.localDate.day}/${p.localDate.month}/${p.localDate.year}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: isElder ? 16 : 14,
                            color: AppTheme.deepMaroon,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${AppLocalizations.getLunarMonthName(p.lunarMonthName, lang)} · ${AppLocalizations.getPakshaName(p.paksha, lang)} · ${AppLocalizations.getVaraName(p.localDate.weekday, lang)}',
                      style: TextStyle(
                        fontSize: isElder ? 16 : 14,
                        color: AppTheme.subtleText,
                      ),
                    ),
                    if (_isDetailedView) ...[
                      const Divider(height: 16),
                      Text(
                        'Tradition: ${AppLocalizations.getTraditionName(p.tradition, lang)} | Month System: ${p.monthSystem.name.toUpperCase()}',
                        style: TextStyle(fontSize: isElder ? 13.5 : 12, color: AppTheme.subtleText),
                      ),
                      Text(
                        'Coordinates: ${p.location.coordinatesString} | TZ: +${p.location.timezoneHours}h',
                        style: TextStyle(fontSize: isElder ? 13.5 : 12, color: AppTheme.subtleText),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 5 Limbs (Pancha-Anga)
              _buildSectionTitle(AppLocalizations.tr('panchang_elements', lang), isElder),
              _buildPanchangRow(
                'Tithi (${AppLocalizations.tr("legend_ekadashi", lang) == "एकादशी" ? "तिथि" : "Tithi"})',
                '${AppLocalizations.getPakshaName(p.paksha, lang)} ${AppLocalizations.getTithiName(p.tithiNumber, lang)}',
                '${AppLocalizations.tr("ends_at", lang)}: ${_formatTime(p.tithiEndTime)} (${AppLocalizations.tr("next_label", lang)}: ${AppLocalizations.getTithiName((p.tithiNumber % 30) + 1, lang)})',
                isElder,
              ),
              _buildPanchangRow(
                '${AppLocalizations.tr("nakshatra_label", lang)}',
                AppLocalizations.getNakshatraName(p.nakshatraName, lang),
                '${AppLocalizations.tr("ends_at", lang)}: ${_formatTime(p.nakshatraEndTime)}',
                isElder,
              ),
              _buildPanchangRow(
                '${AppLocalizations.tr("yoga_label", lang)}',
                AppLocalizations.getYogaName(p.yogaName, lang),
                '${AppLocalizations.tr("ends_at", lang)}: ${_formatTime(p.yogaEndTime)}',
                isElder,
              ),
              _buildPanchangRow(
                '${AppLocalizations.tr("karana_label", lang)}',
                AppLocalizations.getKaranaName(p.karanaName, lang),
                '${AppLocalizations.tr("next_label", lang)}: ${AppLocalizations.getKaranaName(p.nextKaranaName, lang)}',
                isElder,
              ),
              _buildPanchangRow(
                '${AppLocalizations.tr("vara_label", lang)}',
                AppLocalizations.getVaraName(p.localDate.weekday, lang),
                '${AppLocalizations.getVaraName(p.localDate.weekday, lang)}',
                isElder,
              ),
              const SizedBox(height: 16),

              // Astronomical Timings
              _buildSectionTitle(AppLocalizations.tr('astronomical_timings', lang), isElder),
              _buildPanchangRow(
                AppLocalizations.tr('astronomical_sunrise', lang),
                _formatTime(p.astronomicalSunrise),
                'Refraction & dip corrected (50\' depression)',
                isElder,
              ),
              _buildPanchangRow(
                AppLocalizations.tr('astronomical_sunset', lang),
                _formatTime(p.astronomicalSunset),
                'Center of Sun crosses apparent horizon',
                isElder,
              ),
              _buildPanchangRow(
                AppLocalizations.tr('moonrise', lang),
                p.moonrise != null ? _formatTime(p.moonrise!) : '—',
                'Topocentric parallax corrected',
                isElder,
              ),
              _buildPanchangRow(
                AppLocalizations.tr('moonset', lang),
                p.moonset != null ? _formatTime(p.moonset!) : '—',
                'Local horizon crossing',
                isElder,
              ),
              _buildPanchangRow(
                AppLocalizations.tr('solar_noon', lang),
                _formatTime(p.solarNoon),
                'Madhyahna / Meridian transit',
                isElder,
              ),
              const SizedBox(height: 16),

              // Auspicious & Inauspicious Periods
              _buildSectionTitle(AppLocalizations.tr('auspicious_inauspicious', lang), isElder),
              _buildPanchangRow(
                '${AppLocalizations.tr("brahma_muhurat", lang)} 🧘',
                '${_formatTime(p.brahmaMuhuratStart)} – ${_formatTime(p.brahmaMuhuratEnd)}',
                '96 min to 48 min before sunrise',
                isElder,
              ),
              _buildPanchangRow(
                '${AppLocalizations.tr("abhijit_muhurat", lang)} 🟢',
                '${_formatTime(p.abhijitMuhuratStart)} – ${_formatTime(p.abhijitMuhuratEnd)}',
                'Midday auspicious window',
                isElder,
              ),
              _buildPanchangRow(
                '${AppLocalizations.tr("rahu_kaal", lang)} 🔴',
                '${_formatTime(p.rahuKaalStart)} – ${_formatTime(p.rahuKaalEnd)}',
                'Inauspicious daytime octant',
                isElder,
              ),
              _buildPanchangRow(
                AppLocalizations.tr('yamaganda', lang),
                '${_formatTime(p.yamagandaStart)} – ${_formatTime(p.yamagandaEnd)}',
                'Inauspicious daytime octant',
                isElder,
              ),
              _buildPanchangRow(
                AppLocalizations.tr('gulika', lang),
                '${_formatTime(p.gulikaStart)} – ${_formatTime(p.gulikaEnd)}',
                'Saturnian daytime octant',
                isElder,
              ),
              const SizedBox(height: 16),

              // Choghadiya Section
              _buildSectionTitle(AppLocalizations.tr('day_choghadiya', lang), isElder),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: p.dayChoghadiya.map((c) {
                  final color = c.isAuspicious ? AppTheme.suitableGreen : AppTheme.notSuitableRed;
                  return Container(
                    width: (MediaQuery.of(context).size.width.clamp(320, 880) - 48) / 2,
                    padding: EdgeInsets.all(isElder ? 12 : 10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.getChoghadiyaName(c.name, lang),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: color,
                            fontSize: isElder ? 16 : 14.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatTime(c.start)} – ${_formatTime(c.end)}',
                          style: TextStyle(
                            fontSize: isElder ? 13.5 : 12.0,
                            color: AppTheme.deepText,
                          ),
                        ),
                        Text(
                          c.isAuspicious
                              ? AppLocalizations.tr('auspicious', lang)
                              : AppLocalizations.tr('inauspicious', lang),
                          style: TextStyle(
                            fontSize: isElder ? 12.5 : 11.0,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, [bool isElder = false]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: isElder ? 18.5 : 16.0,
          fontWeight: FontWeight.bold,
          color: AppTheme.deepMaroon,
        ),
      ),
    );
  }

  Widget _buildPanchangRow(String title, String mainValue, String subValue, [bool isElder = false]) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: isElder ? 12 : 10),
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isElder ? 14.5 : 13.0,
                    color: AppTheme.subtleText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mainValue,
                  style: TextStyle(
                    fontSize: isElder ? 17.0 : 15.0,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.deepText,
                  ),
                ),
              ],
            ),
          ),
          if (_isDetailedView)
            Expanded(
              child: Text(
                subValue,
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: isElder ? 12.5 : 11.0, color: AppTheme.subtleText),
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
