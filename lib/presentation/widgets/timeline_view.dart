import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/panchang_day.dart';
import '../../l10n/app_localizations.dart';
import '../../services/storage/local_storage_service.dart';

class DayTimelineView extends StatelessWidget {
  final PanchangDay panchang;

  const DayTimelineView({super.key, required this.panchang});

  @override
  Widget build(BuildContext context) {
    final lang = LocalStorageService.appLanguage;
    final isElder = LocalStorageService.elderMode;

    return Container(
      padding: EdgeInsets.all(isElder ? 18 : 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSubtle, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline, color: AppTheme.saffronPrimary, size: isElder ? 22 : 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.tr('day_timeline', lang),
                style: TextStyle(
                  fontSize: isElder ? 18.0 : 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.deepText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimelineNode(
            time: _formatTime(panchang.astronomicalSunrise),
            title: AppLocalizations.tr('astronomical_sunrise', lang),
            icon: '🌅',
            color: AppTheme.saffronPrimary,
            isPoint: true,
            isElder: isElder,
          ),
          _buildTimelineBar(
            startTime: _formatTime(panchang.brahmaMuhuratStart),
            endTime: _formatTime(panchang.brahmaMuhuratEnd),
            title: '${AppLocalizations.tr("brahma_muhurat", lang)} ${AppLocalizations.tr("early_morning", lang)}',
            icon: '🧘',
            color: Colors.indigo,
            isAuspicious: true,
            isElder: isElder,
          ),
          _buildTimelineBar(
            startTime: _formatTime(panchang.rahuKaalStart),
            endTime: _formatTime(panchang.rahuKaalEnd),
            title: '${AppLocalizations.tr("rahu_kaal", lang)} ${AppLocalizations.tr("avoid_auspicious", lang)}',
            icon: '🔴',
            color: AppTheme.notSuitableRed,
            isAuspicious: false,
            isElder: isElder,
          ),
          _buildTimelineBar(
            startTime: _formatTime(panchang.abhijitMuhuratStart),
            endTime: _formatTime(panchang.abhijitMuhuratEnd),
            title: '${AppLocalizations.tr("abhijit_muhurat", lang)} ${AppLocalizations.tr("auspicious_midday", lang)}',
            icon: '🟢',
            color: AppTheme.suitableGreen,
            isAuspicious: true,
            isElder: isElder,
          ),
          _buildTimelineNode(
            time: _formatTime(panchang.astronomicalSunset),
            title: AppLocalizations.tr('astronomical_sunset', lang),
            icon: '🌇',
            color: Colors.deepOrange,
            isPoint: true,
            isLast: true,
            isElder: isElder,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode({
    required String time,
    required String title,
    required String icon,
    required Color color,
    bool isPoint = false,
    bool isLast = false,
    bool isElder = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: isElder ? 84 : 76,
          child: Text(
            time,
            style: TextStyle(
              fontSize: isElder ? 14.5 : 13.0,
              fontWeight: FontWeight.bold,
              color: AppTheme.deepText,
            ),
          ),
        ),
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: isElder ? 42 : 36,
                color: AppTheme.borderSubtle,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Row(
            children: [
              Text(icon, style: TextStyle(fontSize: isElder ? 18 : 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isElder ? 15.5 : 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineBar({
    required String startTime,
    required String endTime,
    required String title,
    required String icon,
    required Color color,
    required bool isAuspicious,
    bool isElder = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: isElder ? 84 : 76,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                startTime,
                style: TextStyle(
                  fontSize: isElder ? 13.5 : 12.0,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.subtleText,
                ),
              ),
              Text(
                endTime,
                style: TextStyle(
                  fontSize: isElder ? 12.5 : 11.0,
                  color: AppTheme.subtleText,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 2,
              height: isElder ? 56 : 48,
              color: color.withOpacity(0.4),
            ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: isElder ? 10 : 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.25), width: 1),
            ),
            child: Row(
              children: [
                Text(icon, style: TextStyle(fontSize: isElder ? 16 : 14)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isElder ? 14.5 : 13.0,
                      fontWeight: FontWeight.w600,
                      color: isAuspicious
                          ? AppTheme.suitableGreen
                          : AppTheme.notSuitableRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}
