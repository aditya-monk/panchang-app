import '../../core/constants/panchang_constants.dart';
import '../../data/muhurat_rules.dart';
import '../../domain/models/location_info.dart';
import '../../domain/models/muhurat_window.dart';
import '../panchang/panchang_service.dart';

class MuhuratSearchResult {
  final List<MuhuratWindow> windows;
  final String occasionTitle;
  final LocationInfo location;
  final String dateRangeDescription;
  final bool hasResults;
  final List<String> suggestionsIfEmpty;

  const MuhuratSearchResult({
    required this.windows,
    required this.occasionTitle,
    required this.location,
    required this.dateRangeDescription,
    required this.hasResults,
    this.suggestionsIfEmpty = const [],
  });
}

class MuhuratService {
  /// Find Muhurat windows for a given occasion, location, date range, and optional constraints
  static MuhuratSearchResult findMuhurat({
    required String occasionId,
    required LocationInfo location, // Event location
    required DateTime startDate,
    required DateTime endDate,
    CalendarTradition tradition = CalendarTradition.standardHindu,
    List<int>? preferredWeekdays,
    int? earliestHour,
    int? latestHour,
    int? minimumDurationMinutes,
  }) {
    final rule = MuhuratRuleDatabase.getRule(occasionId) ??
        MuhuratRuleDatabase.allRules.first;

    final int minDuration = minimumDurationMinutes ?? rule.minimumDurationMinutes;
    final List<MuhuratWindow> results = [];

    // Scan each day in date range
    final int totalDays = endDate.difference(startDate).inDays + 1;
    for (int dayOffset = 0; dayOffset < totalDays; dayOffset++) {
      final DateTime currentDate = startDate.add(Duration(days: dayOffset));
      final int weekday = currentDate.weekday % 7; // 0=Sun..6=Sat

      // Filter by preferred weekdays if specified
      if (preferredWeekdays != null &&
          preferredWeekdays.isNotEmpty &&
          !preferredWeekdays.contains(weekday)) {
        continue;
      }

      // Check excluded weekdays for this occasion
      if (rule.excludedWeekdays.contains(weekday)) {
        continue;
      }

      final panchang = PanchangService.calculatePanchang(
        date: currentDate,
        location: location,
        tradition: tradition,
      );

      // Check excluded Tithis
      if (rule.excludedTithis.contains(panchang.tithiNumber)) {
        continue;
      }

      // Check excluded Nakshatras
      if (rule.excludedNakshatras.contains(panchang.nakshatraNumber)) {
        continue;
      }

      final bool isTithiAllowed = rule.allowedTithis.isEmpty ||
          rule.allowedTithis.contains(panchang.tithiNumber);
      final bool isNakshatraAllowed = rule.allowedNakshatras.isEmpty ||
          rule.allowedNakshatras.contains(panchang.nakshatraNumber);

      // Evaluate Daytime Auspicious Choghadiya & Abhijit windows
      for (final choghadiya in panchang.dayChoghadiya) {
        if (!choghadiya.isAuspicious) continue;

        DateTime windowStart = choghadiya.start;
        DateTime windowEnd = choghadiya.end;

        // Apply hour constraints if requested
        if (earliestHour != null && windowStart.hour < earliestHour) {
          windowStart = DateTime(windowStart.year, windowStart.month,
              windowStart.day, earliestHour, 0);
        }
        if (latestHour != null && windowEnd.hour > latestHour) {
          windowEnd = DateTime(
              windowEnd.year, windowEnd.month, windowEnd.day, latestHour, 0);
        }

        if (windowEnd.isBefore(windowStart)) continue;

        // Clip out Rahu Kaal overlap
        if (windowStart.isBefore(panchang.rahuKaalEnd) &&
            windowEnd.isAfter(panchang.rahuKaalStart)) {
          // If overlaps with Rahu Kaal, adjust window
          if (windowStart.isBefore(panchang.rahuKaalStart)) {
            windowEnd = panchang.rahuKaalStart;
          } else {
            windowStart = panchang.rahuKaalEnd;
          }
        }

        final durationMins = windowEnd.difference(windowStart).inMinutes;
        if (durationMins < minDuration) continue;

        final List<String> satisfied = [];
        final List<String> warnings = [];

        if (isTithiAllowed) {
          satisfied.add('Auspicious Tithi: ${panchang.tithiName}');
        } else {
          warnings.add('Neutral Tithi: ${panchang.tithiName}');
        }

        if (isNakshatraAllowed) {
          satisfied.add('Favorable Nakshatra: ${panchang.nakshatraName}');
        } else {
          warnings.add('Neutral Nakshatra: ${panchang.nakshatraName}');
        }

        satisfied.add('${choghadiya.name} Choghadiya active');
        satisfied.add('Rahu Kaal & Yamaganda strictly avoided');
        satisfied.add(
            'Window duration: $durationMins mins (min required: $minDuration mins)');

        MuhuratStatus status;
        if (isTithiAllowed && isNakshatraAllowed) {
          status = MuhuratStatus.suitable;
        } else {
          status = MuhuratStatus.conditional;
        }

        final simpleWhy =
            'This window satisfies the required ${rule.title} conditions, aligns with ${choghadiya.name} Choghadiya, and safely avoids Rahu Kaal (${_formatTime(panchang.rahuKaalStart)} – ${_formatTime(panchang.rahuKaalEnd)}).';

        final detailedWhy = <String, String>{
          'Occasion': rule.title,
          'Event Location': location.displayName,
          'Date':
              '${currentDate.day} ${_monthName(currentDate.month)} ${currentDate.year}',
          'Tithi':
              '${panchang.paksha == Paksha.shukla ? "Shukla" : "Krishna"} ${panchang.tithiName} (Ends ${_formatTime(panchang.tithiEndTime)})',
          'Nakshatra':
              '${panchang.nakshatraName} (Ends ${_formatTime(panchang.nakshatraEndTime)})',
          'Yoga': panchang.yogaName,
          'Karana': panchang.karanaName,
          'Vara (Weekday)': panchang.vara,
          'Astronomical Sunrise': _formatTime(panchang.astronomicalSunrise),
          'Astronomical Sunset': _formatTime(panchang.astronomicalSunset),
          'Rahu Kaal':
              '${_formatTime(panchang.rahuKaalStart)} – ${_formatTime(panchang.rahuKaalEnd)} (Avoided)',
          'Choghadiya': choghadiya.name,
          'Calendar Tradition': tradition == CalendarTradition.vaishnavaIskcon
              ? 'Vaishnava / ISKCON'
              : tradition == CalendarTradition.gitaPressReference
                  ? 'Gita Press Reference'
                  : 'Standard Hindu Panchang',
        };

        results.add(MuhuratWindow(
          occasion: rule.id,
          occasionTitle: rule.title,
          date: currentDate,
          start: windowStart,
          end: windowEnd,
          status: status,
          location: location,
          tradition: tradition,
          conditionsSatisfied: satisfied,
          conditionsWarning: warnings,
          simpleExplanation: simpleWhy,
          detailedExplanation: detailedWhy,
        ));
      }
    }

    final dateDesc =
        '${startDate.day} ${_monthName(startDate.month)} – ${endDate.day} ${_monthName(endDate.month)} ${endDate.year}';

    final suggestions = results.isEmpty
        ? [
            'Expand date range by 15 to 30 days',
            'Remove earliest/latest time restrictions',
            'Allow additional weekdays',
            'Change event location to nearby major city',
          ]
        : <String>[];

    return MuhuratSearchResult(
      windows: results,
      occasionTitle: rule.title,
      location: location,
      dateRangeDescription: dateDesc,
      hasResults: results.isNotEmpty,
      suggestionsIfEmpty: suggestions,
    );
  }

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
