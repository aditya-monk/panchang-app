import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/location_info.dart';
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
    final comparisons = TraditionEngine.compareCalendars(
      date: date,
      location: location,
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚖️ Compare Traditions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            '${date.day}/${date.month}/${date.year} · ${location.displayName}',
            style: const TextStyle(fontSize: 13, color: AppTheme.subtleText),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.saffronPrimary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.traditionTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppTheme.deepMaroon,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text('Tithi: ${item.tithi}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text('Fasting: ${item.fasting}', style: const TextStyle(fontSize: 13)),
                if (item.parana != null)
                  Text('Parana: ${item.parana}', style: const TextStyle(fontSize: 13, color: AppTheme.sacredGreen)),
                if (item.festivals.isNotEmpty)
                  Text('Observances: ${item.festivals.join(", ")}', style: const TextStyle(fontSize: 12, color: AppTheme.subtleText)),
                const SizedBox(height: 4),
                Text(
                  item.explanation,
                  style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppTheme.subtleText),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
