import '../../core/constants/panchang_constants.dart';
import '../../domain/models/location_info.dart';
import '../../domain/models/panchang_day.dart';
import '../panchang/panchang_service.dart';

class CalendarComparisonItem {
  final CalendarTradition tradition;
  final String traditionTitle;
  final String tithi;
  final String fasting;
  final String? ekadashi;
  final String? parana;
  final List<String> festivals;
  final String explanation;

  const CalendarComparisonItem({
    required this.tradition,
    required this.traditionTitle,
    required this.tithi,
    required this.fasting,
    this.ekadashi,
    this.parana,
    required this.festivals,
    required this.explanation,
  });
}

class TraditionEngine {
  /// Compare how all three calendar tradition profiles interpret a specific date and location
  static List<CalendarComparisonItem> compareCalendars({
    required DateTime date,
    required LocationInfo location,
  }) {
    final standard = PanchangService.calculatePanchang(
      date: date,
      location: location,
      tradition: CalendarTradition.standardHindu,
    );

    final vaishnava = PanchangService.calculatePanchang(
      date: date,
      location: location,
      tradition: CalendarTradition.vaishnavaIskcon,
    );

    final gitaPress = PanchangService.calculatePanchang(
      date: date,
      location: location,
      tradition: CalendarTradition.gitaPressReference,
    );

    return [
      _buildComparisonItem(
        tradition: CalendarTradition.standardHindu,
        title: 'Standard Hindu Panchang',
        day: standard,
        explanation:
            'Follows Smarta Dharma-shastra principles where Udaya Tithi (Tithi at local astronomical sunrise) determines the day’s religious observances.',
      ),
      _buildComparisonItem(
        tradition: CalendarTradition.vaishnavaIskcon,
        title: 'Vaishnava / ISKCON Profile',
        day: vaishnava,
        explanation:
            'Applies strict Hari-bhakti-vilasa Shuddha Ekadashi rules. If Dashami touches Arunodaya (96 mins before sunrise), fast is observed on Dvadashi. Includes Mahadvadashis and Vaishnava appearance days.',
      ),
      _buildComparisonItem(
        tradition: CalendarTradition.gitaPressReference,
        title: 'Gita Press Reference',
        day: gitaPress,
        explanation:
            'Data-driven model matching published Gita Press / Kalyan reference almanacs, primarily adhering to standard North Indian Purnimanta month definitions.',
      ),
    ];
  }

  static CalendarComparisonItem _buildComparisonItem({
    required CalendarTradition tradition,
    required String title,
    required PanchangDay day,
    required String explanation,
  }) {
    String fasting = 'None';
    if (day.isEkadashi) {
      fasting = '${day.ekadashiName ?? "Ekadashi"} Fast';
    } else if (day.vrats.isNotEmpty) {
      fasting = day.vrats.join(', ');
    }

    String? paranaText;
    if (day.tithiNumber == 12 || day.tithiNumber == 27) {
      // Dvadashi morning
      final paranaEnd = day.tithiEndTime;
      paranaText =
          '${_formatTime(day.astronomicalSunrise)} – ${_formatTime(paranaEnd)}';
    }

    return CalendarComparisonItem(
      tradition: tradition,
      traditionTitle: title,
      tithi: '${day.paksha == Paksha.shukla ? "Shukla" : "Krishna"} ${day.tithiName}',
      fasting: fasting,
      ekadashi: day.isEkadashi ? day.ekadashiName : null,
      parana: paranaText,
      festivals: [...day.festivals, ...day.vaishnavaEvents],
      explanation: explanation,
    );
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}
