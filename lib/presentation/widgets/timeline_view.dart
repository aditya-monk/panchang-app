import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/panchang_day.dart';

class DayTimelineView extends StatelessWidget {
  final PanchangDay panchang;

  const DayTimelineView({super.key, required this.panchang});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSubtle, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.timeline, color: AppTheme.saffronPrimary, size: 20),
              SizedBox(width: 8),
              Text(
                'Day Timeline',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.deepText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimelineNode(
            time: _formatTime(panchang.astronomicalSunrise),
            title: 'Astronomical Sunrise',
            icon: '🌅',
            color: AppTheme.saffronPrimary,
            isPoint: true,
          ),
          _buildTimelineBar(
            startTime: _formatTime(panchang.brahmaMuhuratStart),
            endTime: _formatTime(panchang.brahmaMuhuratEnd),
            title: 'Brahma Muhurat (Early morning)',
            icon: '🧘',
            color: Colors.indigo,
            isAuspicious: true,
          ),
          _buildTimelineBar(
            startTime: _formatTime(panchang.rahuKaalStart),
            endTime: _formatTime(panchang.rahuKaalEnd),
            title: 'Rahu Kaal (Avoid auspicious works)',
            icon: '🔴',
            color: AppTheme.notSuitableRed,
            isAuspicious: false,
          ),
          _buildTimelineBar(
            startTime: _formatTime(panchang.abhijitMuhuratStart),
            endTime: _formatTime(panchang.abhijitMuhuratEnd),
            title: 'Abhijit Muhurat (Auspicious midday)',
            icon: '🟢',
            color: AppTheme.suitableGreen,
            isAuspicious: true,
          ),
          _buildTimelineNode(
            time: _formatTime(panchang.astronomicalSunset),
            title: 'Astronomical Sunset',
            icon: '🌇',
            color: Colors.deepOrange,
            isPoint: true,
            isLast: true,
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
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 76,
          child: Text(
            time,
            style: const TextStyle(
              fontSize: 13,
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
                height: 36,
                color: AppTheme.borderSubtle,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
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
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 76,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                startTime,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.subtleText,
                ),
              ),
              Text(
                endTime,
                style: const TextStyle(
                  fontSize: 11,
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
              height: 48,
              color: color.withOpacity(0.4),
            ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.25), width: 1),
            ),
            child: Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
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
