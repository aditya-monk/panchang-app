import '../../core/constants/panchang_constants.dart';
import 'location_info.dart';

class ChoghadiyaPeriod {
  final ChoghadiyaType type;
  final String name;
  final DateTime start;
  final DateTime end;
  final bool isAuspicious;

  const ChoghadiyaPeriod({
    required this.type,
    required this.name,
    required this.start,
    required this.end,
    required this.isAuspicious,
  });
}

class PanchangDay {
  final DateTime localDate;
  final LocationInfo location;
  final CalendarTradition tradition;
  final RegionalProfile regionalProfile;
  final MonthSystem monthSystem;

  final String lunarMonthName;
  final Paksha paksha;
  final int tithiNumber;
  final String tithiName;
  final DateTime tithiEndTime;
  final String nextTithiName;

  final int nakshatraNumber;
  final String nakshatraName;
  final DateTime nakshatraEndTime;

  final int yogaNumber;
  final String yogaName;
  final DateTime yogaEndTime;

  final String karanaName;
  final String nextKaranaName;
  final String vara;

  // Labeled as "Astronomical Sunrise" and "Astronomical Sunset" per requirement 53A.5
  final DateTime astronomicalSunrise;
  final DateTime astronomicalSunset;
  final DateTime? moonrise;
  final DateTime? moonset;
  final DateTime solarNoon;

  // Key Muhurta and Inauspicious Intervals
  final DateTime brahmaMuhuratStart;
  final DateTime brahmaMuhuratEnd;
  final DateTime abhijitMuhuratStart;
  final DateTime abhijitMuhuratEnd;
  final DateTime rahuKaalStart;
  final DateTime rahuKaalEnd;
  final DateTime yamagandaStart;
  final DateTime yamagandaEnd;
  final DateTime gulikaStart;
  final DateTime gulikaEnd;

  final List<ChoghadiyaPeriod> dayChoghadiya;
  final List<ChoghadiyaPeriod> nightChoghadiya;

  final bool isEkadashi;
  final String? ekadashiName;
  final List<String> festivals;
  final List<String> vrats;
  final List<String> vaishnavaEvents;

  const PanchangDay({
    required this.localDate,
    required this.location,
    required this.tradition,
    required this.regionalProfile,
    required this.monthSystem,
    required this.lunarMonthName,
    required this.paksha,
    required this.tithiNumber,
    required this.tithiName,
    required this.tithiEndTime,
    required this.nextTithiName,
    required this.nakshatraNumber,
    required this.nakshatraName,
    required this.nakshatraEndTime,
    required this.yogaNumber,
    required this.yogaName,
    required this.yogaEndTime,
    required this.karanaName,
    required this.nextKaranaName,
    required this.vara,
    required this.astronomicalSunrise,
    required this.astronomicalSunset,
    this.moonrise,
    this.moonset,
    required this.solarNoon,
    required this.brahmaMuhuratStart,
    required this.brahmaMuhuratEnd,
    required this.abhijitMuhuratStart,
    required this.abhijitMuhuratEnd,
    required this.rahuKaalStart,
    required this.rahuKaalEnd,
    required this.yamagandaStart,
    required this.yamagandaEnd,
    required this.gulikaStart,
    required this.gulikaEnd,
    required this.dayChoghadiya,
    required this.nightChoghadiya,
    this.isEkadashi = false,
    this.ekadashiName,
    this.festivals = const [],
    this.vrats = const [],
    this.vaishnavaEvents = const [],
  });

  /// Check whether a given time falls inside Rahu Kaal
  bool isInsideRahuKaal(DateTime time) =>
      time.isAfter(rahuKaalStart) && time.isBefore(rahuKaalEnd);

  /// Check whether a given time falls inside Abhijit Muhurat
  bool isInsideAbhijit(DateTime time) =>
      time.isAfter(abhijitMuhuratStart) && time.isBefore(abhijitMuhuratEnd);

  /// Live "NOW" indicator for current moment
  ({String title, String timing, bool isAuspicious})? getNowIndicator(
      DateTime now) {
    if (isInsideRahuKaal(now)) {
      return (
        title: 'Rahu Kaal is currently active',
        timing:
            '${_formatTime(rahuKaalStart)} – ${_formatTime(rahuKaalEnd)}',
        isAuspicious: false,
      );
    }
    if (isInsideAbhijit(now)) {
      return (
        title: 'Abhijit Muhurat is currently active',
        timing:
            '${_formatTime(abhijitMuhuratStart)} – ${_formatTime(abhijitMuhuratEnd)}',
        isAuspicious: true,
      );
    }
    // Check current Choghadiya
    for (final c in dayChoghadiya) {
      if (now.isAfter(c.start) && now.isBefore(c.end)) {
        return (
          title: '${c.name} Choghadiya is active',
          timing: '${_formatTime(c.start)} – ${_formatTime(c.end)}',
          isAuspicious: c.isAuspicious,
        );
      }
    }
    return null;
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}
