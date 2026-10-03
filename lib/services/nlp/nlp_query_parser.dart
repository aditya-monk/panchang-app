import '../../core/constants/panchang_constants.dart';
import '../../data/cities.dart';
import '../../data/muhurat_rules.dart';
import '../../domain/models/location_info.dart';
import '../../domain/models/query_context.dart';

enum QueryIntentType {
  panchangToday,
  sunrise,
  sunset,
  nextEkadashi,
  rahuKaal,
  muhuratSearch,
  unknown,
}

class ParsedQueryResult {
  final QueryIntentType intent;
  final String? occasionId;
  final String? occasionTitle;
  final LocationInfo location;
  final DateTime startDate;
  final DateTime endDate;
  final CalendarTradition tradition;
  final List<int>? preferredWeekdays;
  final int? earliestHour;
  final int? latestHour;
  final int? minimumDurationMinutes;
  final QueryContext updatedContext;

  const ParsedQueryResult({
    required this.intent,
    this.occasionId,
    this.occasionTitle,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.tradition,
    this.preferredWeekdays,
    this.earliestHour,
    this.latestHour,
    this.minimumDurationMinutes,
    required this.updatedContext,
  });
}

class NlpQueryParser {
  /// Parse natural language queries with conversational context retention across EN, HI, GU, MR, BHO
  static ParsedQueryResult parse({
    required String query,
    required LocationInfo defaultLocation,
    QueryContext? currentContext,
    CalendarTradition defaultTradition = CalendarTradition.standardHindu,
  }) {
    final lower = query.trim().toLowerCase();

    // 1. Detect quick informational intents if not a Muhurat search
    if (_isSunriseQuery(lower)) {
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final date = _extractSingleDate(lower) ?? DateTime.now();
      return ParsedQueryResult(
        intent: QueryIntentType.sunrise,
        location: loc,
        startDate: date,
        endDate: date,
        tradition: defaultTradition,
        updatedContext: currentContext ?? QueryContext(location: loc),
      );
    }

    if (_isSunsetQuery(lower)) {
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final date = _extractSingleDate(lower) ?? DateTime.now();
      return ParsedQueryResult(
        intent: QueryIntentType.sunset,
        location: loc,
        startDate: date,
        endDate: date,
        tradition: defaultTradition,
        updatedContext: currentContext ?? QueryContext(location: loc),
      );
    }

    if (_isEkadashiQuery(lower)) {
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final trad = _extractTradition(lower) ??
          currentContext?.tradition ??
          defaultTradition;
      return ParsedQueryResult(
        intent: QueryIntentType.nextEkadashi,
        location: loc,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 30)),
        tradition: trad,
        updatedContext: currentContext ??
            QueryContext(location: loc, tradition: trad),
      );
    }

    if (_isRahuKaalQuery(lower)) {
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final date = _extractSingleDate(lower) ?? DateTime.now();
      return ParsedQueryResult(
        intent: QueryIntentType.rahuKaal,
        location: loc,
        startDate: date,
        endDate: date,
        tradition: defaultTradition,
        updatedContext: currentContext ?? QueryContext(location: loc),
      );
    }

    if (_isTodayPanchangQuery(lower)) {
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final date = _extractSingleDate(lower) ?? DateTime.now();
      return ParsedQueryResult(
        intent: QueryIntentType.panchangToday,
        location: loc,
        startDate: date,
        endDate: date,
        tradition: defaultTradition,
        updatedContext: currentContext ?? QueryContext(location: loc),
      );
    }

    // 2. Muhurat Intent Parsing
    // Extract Occasion (fallback to context)
    String? occasionId = _extractOccasion(lower) ?? currentContext?.occasion;
    String? occasionTitle;
    if (occasionId != null) {
      final rule = MuhuratRuleDatabase.getRule(occasionId);
      occasionTitle = rule?.title ?? occasionId;
    } else {
      // Default to general auspicious if user asked "when is next muhurat"
      occasionId = 'general_auspicious';
      occasionTitle = 'General Auspicious';
    }

    // Extract Location (fallback to context, then default)
    LocationInfo location = _extractLocation(lower) ??
        currentContext?.location ??
        defaultLocation;

    // Extract Tradition
    CalendarTradition tradition = _extractTradition(lower) ??
        currentContext?.tradition ??
        defaultTradition;

    // Extract Date Range
    final dateRange = _extractDateRange(lower, currentContext);
    DateTime startDate = dateRange.start;
    DateTime endDate = dateRange.end;

    // Extract preferred weekdays
    List<int>? weekdays = _extractWeekdays(lower) ?? currentContext?.preferredWeekdays;

    // Extract time constraints (e.g. "after 10 am", "before 6 pm")
    int? earliestHour = _extractEarliestHour(lower) ?? currentContext?.earliestHour;
    int? latestHour = _extractLatestHour(lower) ?? currentContext?.latestHour;

    // Build updated context
    final updatedContext = QueryContext(
      occasion: occasionId,
      occasionTitle: occasionTitle,
      location: location,
      tradition: tradition,
      startDate: startDate,
      endDate: endDate,
      preferredWeekdays: weekdays,
      earliestHour: earliestHour,
      latestHour: latestHour,
      lastQuery: query,
    );

    return ParsedQueryResult(
      intent: QueryIntentType.muhuratSearch,
      occasionId: occasionId,
      occasionTitle: occasionTitle,
      location: location,
      startDate: startDate,
      endDate: endDate,
      tradition: tradition,
      preferredWeekdays: weekdays,
      earliestHour: earliestHour,
      latestHour: latestHour,
      updatedContext: updatedContext,
    );
  }

  static bool _isSunriseQuery(String q) =>
      q.contains('sunrise') ||
      q.contains('सूर्योदय') ||
      q.contains('સૂર્યોદય') ||
      q.contains('सूरज');

  static bool _isSunsetQuery(String q) =>
      q.contains('sunset') ||
      q.contains('सूर्यास्त') ||
      q.contains('સૂર્યાસ્ત');

  static bool _isEkadashiQuery(String q) =>
      q.contains('ekadashi') ||
      q.contains('एकादशी') ||
      q.contains('એકાદશી') ||
      q.contains('parana') ||
      q.contains('पारणा');

  static bool _isRahuKaalQuery(String q) =>
      q.contains('rahu kaal') ||
      q.contains('rahukaal') ||
      q.contains('राहु काल') ||
      q.contains('રાહુ કાળ');

  static bool _isTodayPanchangQuery(String q) =>
      (q.contains('panchang') || q.contains('पंचांग')) &&
      !q.contains('muhurat') &&
      !q.contains('मुहूर्त');

  static String? _extractOccasion(String q) {
    if (q.contains('marriage') ||
        q.contains('wedding') ||
        q.contains('vivah') ||
        q.contains('विवाह') ||
        q.contains('शादी') ||
        q.contains('લગ્ન')) {
      return 'marriage';
    }
    if (q.contains('griha pravesh') ||
        q.contains('house warming') ||
        q.contains('गृह प्रवेश') ||
        q.contains('ગૃહ પ્રવેશ') ||
        q.contains('गृहप्रवेश')) {
      return 'griha_pravesh';
    }
    if (q.contains('vehicle') ||
        q.contains('car') ||
        q.contains('bike') ||
        q.contains('गाड़ी') ||
        q.contains('गाड़ी') ||
        q.contains('वाहन') ||
        q.contains('વાહન')) {
      return 'vehicle_purchase';
    }
    if (q.contains('property') ||
        q.contains('land') ||
        q.contains('flat') ||
        q.contains('मकान') ||
        q.contains('जमीन') ||
        q.contains('પ્રોપર્ટી')) {
      return 'property_purchase';
    }
    if (q.contains('business') ||
        q.contains('shop') ||
        q.contains('office') ||
        q.contains('व्यापार') ||
        q.contains('दुकान') ||
        q.contains('દુકાન') ||
        q.contains('ऑफिस')) {
      return 'business_opening';
    }
    if (q.contains('mundan') ||
        q.contains('मुंडन') ||
        q.contains('મુંડન') ||
        q.contains('tonsure')) {
      return 'mundan';
    }
    if (q.contains('namkaran') ||
        q.contains('नामकरण') ||
        q.contains('નામકરણ') ||
        q.contains('naming')) {
      return 'namkaran';
    }
    if (q.contains('annaprashan') ||
        q.contains('अन्नप्राशन') ||
        q.contains('અન્નપ્રાશન')) {
      return 'annaprashan';
    }
    if (q.contains('vidyarambh') ||
        q.contains('विद्यारंभ') ||
        q.contains('વિદ્યારંભ') ||
        q.contains('education')) {
      return 'vidyarambh';
    }
    if (q.contains('bhoomi') ||
        q.contains('भूमि पूजन') ||
        q.contains('ભૂમિ પૂજન')) {
      return 'bhoomi_pujan';
    }
    if (q.contains('travel') ||
        q.contains('yatra') ||
        q.contains('यात्रा')) {
      return 'travel';
    }
    if (q.contains('puja') ||
        q.contains('havan') ||
        q.contains('पूजा') ||
        q.contains('हवन')) {
      return 'puja_havan';
    }
    return null;
  }

  static LocationInfo? _extractLocation(String q) {
    for (final city in CityDatabase.cities) {
      if (q.contains(city.name.toLowerCase())) return city;
      for (final alias in city.aliases) {
        if (q.contains(alias.toLowerCase())) return city;
      }
    }
    return null;
  }

  static CalendarTradition? _extractTradition(String q) {
    if (q.contains('vaishnava') ||
        q.contains('iskcon') ||
        q.contains('वैष्णव') ||
        q.contains('ઇસ્કોન')) {
      return CalendarTradition.vaishnavaIskcon;
    }
    if (q.contains('gita press') ||
        q.contains('geeta press') ||
        q.contains('गीताप्रेस') ||
        q.contains('गीतप्रेस')) {
      return CalendarTradition.gitaPressReference;
    }
    if (q.contains('standard') ||
        q.contains('smarta') ||
        q.contains('स्मार्त')) {
      return CalendarTradition.standardHindu;
    }
    return null;
  }

  static DateTime? _extractSingleDate(String q) {
    final now = DateTime.now();
    if (q.contains('tomorrow') ||
        q.contains('कल') ||
        q.contains('કાલે') ||
        q.contains('काल्हि')) {
      return now.add(Duration(days: 1));
    }
    if (q.contains('day after tomorrow') ||
        q.contains('परसों') ||
        q.contains('પરમ દિવસે')) {
      return now.add(Duration(days: 2));
    }
    if (q.contains('today') ||
        q.contains('आज') ||
        q.contains('આજે') ||
        q.contains('आजु')) {
      return now;
    }
    return null;
  }

  static ({DateTime start, DateTime end}) _extractDateRange(
      String q, QueryContext? ctx) {
    final now = DateTime.now();

    // Check month mentions (e.g. November, December, अगले महीने)
    final months = [
      'january', 'february', 'march', 'april', 'may', 'june',
      'july', 'august', 'september', 'october', 'november', 'december'
    ];
    final hindiMonths = [
      'जनवरी', 'फरवरी', 'मार्च', 'अप्रैल', 'मई', 'जून',
      'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर'
    ];

    // Check year mentions (e.g. 2027, 2028)
    int targetYear = now.year;
    final yearMatch = RegExp(r'\b(202[4-9]|203[0-5])\b').firstMatch(q);
    if (yearMatch != null) {
      targetYear = int.parse(yearMatch.group(1)!);
    } else if (q.contains('next year') || q.contains('अगले साल')) {
      targetYear = now.year + 1;
    }

    for (int i = 0; i < 12; i++) {
      if (q.contains(months[i]) || q.contains(hindiMonths[i])) {
        final start = DateTime(targetYear, i + 1, 1);
        final end = DateTime(targetYear, i + 2, 0); // last day of month
        return (start: start, end: end);
      }
    }

    if (q.contains('this weekend') ||
        q.contains('इस वीकेंड') ||
        q.contains('આ વીકેન્ડ')) {
      // Find upcoming Saturday & Sunday
      int daysUntilSat = (6 - now.weekday + 7) % 7;
      final sat = now.add(Duration(days: daysUntilSat));
      final sun = sat.add(Duration(days: 1));
      return (start: sat, end: sun);
    }

    if (q.contains('next weekend')) {
      int daysUntilSat = ((6 - now.weekday + 7) % 7) + 7;
      final sat = now.add(Duration(days: daysUntilSat));
      final sun = sat.add(Duration(days: 1));
      return (start: sat, end: sun);
    }

    if (q.contains('next month') ||
        q.contains('अगले महीने') ||
        q.contains('આવતા મહિને') ||
        q.contains('अगिला महीना')) {
      final nextMonthDate = DateTime(now.year, now.month + 1, 1);
      final lastDay = DateTime(nextMonthDate.year, nextMonthDate.month + 1, 0);
      return (start: nextMonthDate, end: lastDay);
    }

    if (q.contains('next week') || q.contains('अगले हफ्ते')) {
      final start = now.add(Duration(days: 7));
      final end = start.add(Duration(days: 7));
      return (start: start, end: end);
    }

    // Context fallback
    if (ctx?.startDate != null && ctx?.endDate != null) {
      return (start: ctx!.startDate!, end: ctx.endDate!);
    }

    // Default: Next 30 days
    return (start: now, end: now.add(Duration(days: 30)));
  }

  static List<int>? _extractWeekdays(String q) {
    if (q.contains('weekend') ||
        q.contains('वीकेंड') ||
        q.contains('शनिवार') && q.contains('रविवार')) {
      return [6, 0]; // Saturday, Sunday
    }
    if (q.contains('sunday') || q.contains('रविवार') || q.contains('इतवार')) {
      return [0];
    }
    if (q.contains('monday') || q.contains('सोमवार')) return [1];
    if (q.contains('tuesday') || q.contains('मंगलवार')) return [2];
    if (q.contains('wednesday') || q.contains('बुधवार')) return [3];
    if (q.contains('thursday') || q.contains('गुरुवार') || q.contains('बृहस्पतिवार')) {
      return [4];
    }
    if (q.contains('friday') || q.contains('शुक्रवार')) return [5];
    if (q.contains('saturday') || q.contains('शनिवार')) return [6];
    return null;
  }

  static int? _extractEarliestHour(String q) {
    final match = RegExp(r'after\s+(\d{1,2})\s*(am|pm)?').firstMatch(q);
    if (match != null) {
      int h = int.parse(match.group(1)!);
      if (match.group(2) == 'pm' && h < 12) h += 12;
      return h;
    }
    if (q.contains('morning') || q.contains('सुबह')) return 6;
    if (q.contains('afternoon') || q.contains('दोपहर')) return 12;
    return null;
  }

  static int? _extractLatestHour(String q) {
    final match = RegExp(r'before\s+(\d{1,2})\s*(am|pm)?').firstMatch(q);
    if (match != null) {
      int h = int.parse(match.group(1)!);
      if (match.group(2) == 'pm' && h < 12) h += 12;
      return h;
    }
    if (q.contains('evening') || q.contains('शाम')) return 18;
    return null;
  }
}
