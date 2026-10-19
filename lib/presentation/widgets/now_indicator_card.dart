import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/panchang_day.dart';
import '../../l10n/app_localizations.dart';
import '../../services/storage/local_storage_service.dart';

class NowIndicatorCard extends StatelessWidget {
  final PanchangDay panchang;
  final DateTime currentTime;

  const NowIndicatorCard({
    super.key,
    required this.panchang,
    required this.currentTime,
  });

  @override
  Widget build(BuildContext context) {
    final lang = LocalStorageService.appLanguage;
    final indicator = panchang.getNowIndicator(currentTime);
    if (indicator == null) return const SizedBox.shrink();

    final bool isGreen = indicator.isAuspicious;
    final Color badgeColor =
        isGreen ? AppTheme.suitableGreen : AppTheme.notSuitableRed;
    final Color bgColor =
        isGreen ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2);
    final Color borderColor =
        isGreen ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA);

    // Localize the title dynamically
    String localizedTitle = indicator.title;
    if (panchang.isInsideRahuKaal(currentTime)) {
      localizedTitle = AppLocalizations.tr('rahu_kaal_active', lang);
    } else if (panchang.isInsideAbhijit(currentTime)) {
      localizedTitle = AppLocalizations.tr('abhijit_active', lang);
    } else {
      for (final c in panchang.dayChoghadiya) {
        if (currentTime.isAfter(c.start) && currentTime.isBefore(c.end)) {
          localizedTitle = '${c.name} ${AppLocalizations.tr('choghadiya_active', lang)}';
          break;
        }
      }
    }

    final bool isElder = LocalStorageService.elderMode;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: isElder ? 14 : 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: isElder ? 14 : 12,
            height: isElder ? 14 : 12,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizedTitle,
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: isElder ? 16.5 : 14.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  indicator.timing,
                  style: TextStyle(
                    color: AppTheme.deepText.withOpacity(0.85),
                    fontSize: isElder ? 15.0 : 13.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: isElder ? 10 : 8, vertical: isElder ? 5 : 4),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              AppLocalizations.tr('live_badge', lang),
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.bold,
                fontSize: isElder ? 13.0 : 11.0,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
