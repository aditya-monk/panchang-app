import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/location_info.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/storage/local_storage_service.dart';
import '../../../services/traditions/tradition_engine.dart';

class CalendarComparisonDialog extends StatelessWidget {
  final DateTime date;
  final LocationInfo location;

  const CalendarComparisonDialog({
    super.key,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final lang = LocalStorageService.appLanguage;
    final isElder = LocalStorageService.elderMode;
    final comparisons = TraditionEngine.compareCalendars(
      date: date,
      location: location,
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⚖️ ', style: TextStyle(fontSize: 20)),
              Expanded(
                child: Text(
                  AppLocalizations.tr('compare_calendars', lang),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isElder ? 21 : 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${date.day}/${date.month}/${date.year} · ${location.displayName}',
            style: TextStyle(fontSize: isElder ? 15 : 13, color: AppTheme.subtleText),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: comparisons.length,
          separatorBuilder: (_, __) => const Divider(height: 20),
          itemBuilder: (ctx, idx) {
            final item = comparisons[idx];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.saffronPrimary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppLocalizations.getTraditionName(item.tradition, lang),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isElder ? 15.5 : 13.5,
                      color: AppTheme.deepMaroon,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${AppLocalizations.tr('tithi_label', lang)}: ${item.tithi}',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: isElder ? 15.5 : 13.5),
                ),
                const SizedBox(height: 3),
                Text(
                  '${AppLocalizations.tr('fasting', lang)}: ${AppLocalizations.localizeFastingRule(item.fasting, lang)}',
                  style: TextStyle(fontSize: isElder ? 15 : 13),
                ),
                if (item.parana != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    '${AppLocalizations.tr('parana', lang)}: ${item.parana}',
                    style: TextStyle(
                      fontSize: isElder ? 15 : 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.sacredGreen,
                    ),
                  ),
                ],
                if (item.festivals.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${AppLocalizations.tr('observances_label', lang)}: ${item.festivals.join(", ")}',
                    style: TextStyle(fontSize: isElder ? 14 : 12.5, color: AppTheme.subtleText),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  item.explanation,
                  style: TextStyle(
                    fontSize: isElder ? 13.5 : 11.5,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.subtleText,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: isElder ? 20 : 14, vertical: isElder ? 12 : 8),
          ),
          child: Text(
            AppLocalizations.tr('close', lang),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isElder ? 16 : 14,
            ),
          ),
        ),
      ],
    );
  }
}

