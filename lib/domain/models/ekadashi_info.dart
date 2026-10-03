import '../../core/constants/panchang_constants.dart';
import 'location_info.dart';

class EkadashiInfo {
  final String name;
  final DateTime date;
  final DateTime tithiStart;
  final DateTime tithiEnd;
  final String fastingRule;
  final DateTime paranaDate;
  final DateTime paranaStart;
  final DateTime paranaEnd;
  final LocationInfo location;
  final CalendarTradition tradition;
  final String whyThisDate;
  final Map<String, String> calculationDetails;

  const EkadashiInfo({
    required this.name,
    required this.date,
    required this.tithiStart,
    required this.tithiEnd,
    required this.fastingRule,
    required this.paranaDate,
    required this.paranaStart,
    required this.paranaEnd,
    required this.location,
    required this.tradition,
    required this.whyThisDate,
    required this.calculationDetails,
  });

  String get formattedDate =>
      '${date.day} ${_monthName(date.month)} ${date.year}';

  String get formattedParana =>
      '${paranaDate.day} ${_monthName(paranaDate.month)}: ${_formatTime(paranaStart)} – ${_formatTime(paranaEnd)}';

  static String _monthName(int month) {
    const m = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
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
