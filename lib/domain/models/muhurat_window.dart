import '../../core/constants/panchang_constants.dart';
import 'location_info.dart';

class MuhuratWindow {
  final String occasion;
  final String occasionTitle;
  final DateTime date;
  final DateTime start;
  final DateTime end;
  final MuhuratStatus status;
  final LocationInfo location;
  final CalendarTradition tradition;
  final List<String> conditionsSatisfied;
  final List<String> conditionsWarning;
  final String simpleExplanation;
  final Map<String, String> detailedExplanation;

  const MuhuratWindow({
    required this.occasion,
    required this.occasionTitle,
    required this.date,
    required this.start,
    required this.end,
    required this.status,
    required this.location,
    required this.tradition,
    required this.conditionsSatisfied,
    this.conditionsWarning = const [],
    required this.simpleExplanation,
    required this.detailedExplanation,
  });

  Duration get duration => end.difference(start);

  String get formattedTiming =>
      '${_formatTime(start)} – ${_formatTime(end)}';

  String get formattedDate =>
      '${date.day} ${_monthName(date.month)} ${date.year}';

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
