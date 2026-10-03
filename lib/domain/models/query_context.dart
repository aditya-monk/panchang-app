import '../../core/constants/panchang_constants.dart';
import 'location_info.dart';

/// Retains conversation context for multi-turn natural language queries.
class QueryContext {
  final String? occasion;
  final String? occasionTitle;
  final LocationInfo? location;
  final CalendarTradition? tradition;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? year;
  final int? month;
  final List<int>? preferredWeekdays; // 0=Sunday, 6=Saturday
  final int? earliestHour;
  final int? latestHour;
  final int? minimumDurationMinutes;
  final String? lastQuery;

  const QueryContext({
    this.occasion,
    this.occasionTitle,
    this.location,
    this.tradition,
    this.startDate,
    this.endDate,
    this.year,
    this.month,
    this.preferredWeekdays,
    this.earliestHour,
    this.latestHour,
    this.minimumDurationMinutes,
    this.lastQuery,
  });

  QueryContext copyWith({
    String? occasion,
    String? occasionTitle,
    LocationInfo? location,
    CalendarTradition? tradition,
    DateTime? startDate,
    DateTime? endDate,
    int? year,
    int? month,
    List<int>? preferredWeekdays,
    int? earliestHour,
    int? latestHour,
    int? minimumDurationMinutes,
    String? lastQuery,
  }) {
    return QueryContext(
      occasion: occasion ?? this.occasion,
      occasionTitle: occasionTitle ?? this.occasionTitle,
      location: location ?? this.location,
      tradition: tradition ?? this.tradition,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      year: year ?? this.year,
      month: month ?? this.month,
      preferredWeekdays: preferredWeekdays ?? this.preferredWeekdays,
      earliestHour: earliestHour ?? this.earliestHour,
      latestHour: latestHour ?? this.latestHour,
      minimumDurationMinutes:
          minimumDurationMinutes ?? this.minimumDurationMinutes,
      lastQuery: lastQuery ?? this.lastQuery,
    );
  }
}
