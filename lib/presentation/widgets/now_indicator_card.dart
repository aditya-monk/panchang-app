import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/panchang_day.dart';

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
    final indicator = panchang.getNowIndicator(currentTime);
    if (indicator == null) return const SizedBox.shrink();

    final bool isGreen = indicator.isAuspicious;
    final Color badgeColor =
        isGreen ? AppTheme.suitableGreen : AppTheme.notSuitableRed;
    final Color bgColor =
        isGreen ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2);
    final Color borderColor =
        isGreen ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
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
                  indicator.title,
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  indicator.timing,
                  style: TextStyle(
                    color: AppTheme.deepText.withOpacity(0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'LIVE',
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
