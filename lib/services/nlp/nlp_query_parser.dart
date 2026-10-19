import '../../core/constants/panchang_constants.dart';
import '../../data/cities.dart';
import '../../data/muhurat_rules.dart';
import '../../domain/models/location_info.dart';
import '../../domain/models/query_context.dart';
import '../festivals/festival_lookup_service.dart';
import '../panchang/tithi_search_service.dart';

enum QueryIntentType {
  panchangToday,
  sunrise,
  sunset,
  nextEkadashi,
  rahuKaal,
  festivalDate,
  festivalVerification,
  datePanchang,
  tithiQuery,
  tithiSearch,
  nakshatraQuery,
  choghadiyaQuery,
  muhuratSearch,
  unknown,
}

class ParsedQueryResult {
  final QueryIntentType intent;
  final String? occasionId;
  final String? occasionTitle;
  final FestivalDefinition? festival;
  final TithiTarget? targetTithi;
  final DateTime? targetDate;
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
    this.festival,
    this.targetTithi,
    this.targetDate,
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

    // 0. Detect Festival queries (e.g. "dushera kab hai?", "10 october ko vijyadashmi hai?")
    final festival = FestivalLookupService.detectFestival(lower);
    if (festival != null) {
      final explicitDate = extractTargetDate(lower);
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final trad = _extractTradition(lower) ??
          currentContext?.tradition ??
          defaultTradition;

      if (explicitDate != null) {
        // Verification query: e.g. "10 october ko vijyadashmi hai?"
        return ParsedQueryResult(
          intent: QueryIntentType.festivalVerification,
          festival: festival,
          targetDate: explicitDate,
          location: loc,
          startDate: explicitDate,
          endDate: explicitDate,
          tradition: trad,
          updatedContext: currentContext ?? QueryContext(location: loc, tradition: trad),
        );
      } else {
        // Date inquiry: e.g. "dushera kab hai?", "diwali kab hai?"
        final now = DateTime.now();
        return ParsedQueryResult(
          intent: QueryIntentType.festivalDate,
          festival: festival,
          location: loc,
          startDate: now,
          endDate: now.add(const Duration(days: 365)),
          tradition: trad,
          updatedContext: currentContext ?? QueryContext(location: loc, tradition: trad),
        );
      }
    }

    // 1. Detect quick informational intents
    if (_isSunriseQuery(lower)) {
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final date = extractTargetDate(lower) ?? DateTime.now();
      return ParsedQueryResult(
        intent: QueryIntentType.sunrise,
        location: loc,
        startDate: date,
        endDate: date,
        targetDate: date,
        tradition: defaultTradition,
        updatedContext: currentContext ?? QueryContext(location: loc),
      );
    }

    if (_isSunsetQuery(lower)) {
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final date = extractTargetDate(lower) ?? DateTime.now();
      return ParsedQueryResult(
        intent: QueryIntentType.sunset,
        location: loc,
        startDate: date,
        endDate: date,
        targetDate: date,
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
        endDate: DateTime.now().add(const Duration(days: 30)),
        tradition: trad,
        updatedContext: currentContext ??
            QueryContext(location: loc, tradition: trad),
      );
    }

    // 1B. Detect general Tithi Inquiries (e.g. "नवमी कब है?", "अष्टमी कब है?", "पूर्णिमा कब है?", "when is navami?")
    final tithiInquiry = TithiSearchService.detectTithiInquiry(lower);
    if (tithiInquiry != null) {
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final trad = _extractTradition(lower) ??
          currentContext?.tradition ??
          defaultTradition;
      final now = DateTime.now();
      return ParsedQueryResult(
        intent: QueryIntentType.tithiSearch,
        targetTithi: tithiInquiry,
        location: loc,
        startDate: now,
        endDate: now.add(const Duration(days: 35)),
        tradition: trad,
        updatedContext: currentContext ?? QueryContext(location: loc, tradition: trad),
      );
    }

    if (_isRahuKaalQuery(lower)) {
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final date = extractTargetDate(lower) ?? DateTime.now();
      return ParsedQueryResult(
        intent: QueryIntentType.rahuKaal,
        location: loc,
        startDate: date,
        endDate: date,
        targetDate: date,
        tradition: defaultTradition,
        updatedContext: currentContext ?? QueryContext(location: loc),
      );
    }

    if (_isTithiQuery(lower)) {
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final date = extractTargetDate(lower) ?? DateTime.now();
      return ParsedQueryResult(
        intent: QueryIntentType.tithiQuery,
        location: loc,
        startDate: date,
        endDate: date,
        targetDate: date,
        tradition: defaultTradition,
        updatedContext: currentContext ?? QueryContext(location: loc),
      );
    }

    if (_isNakshatraQuery(lower)) {
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final date = extractTargetDate(lower) ?? DateTime.now();
      return ParsedQueryResult(
        intent: QueryIntentType.nakshatraQuery,
        location: loc,
        startDate: date,
        endDate: date,
        targetDate: date,
        tradition: defaultTradition,
        updatedContext: currentContext ?? QueryContext(location: loc),
      );
    }

    if (_isChoghadiyaQuery(lower)) {
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final date = extractTargetDate(lower) ?? DateTime.now();
      return ParsedQueryResult(
        intent: QueryIntentType.choghadiyaQuery,
        location: loc,
        startDate: date,
        endDate: date,
        targetDate: date,
        tradition: defaultTradition,
        updatedContext: currentContext ?? QueryContext(location: loc),
      );
    }

    // Specific Date Query: e.g. "10 october ko kya hai?", "10 october ka panchang", "कल क्या है?"
    final explicitDate = extractTargetDate(lower);
    if (explicitDate != null &&
        (lower.contains('kya hai') ||
            lower.contains('का पंचांग') ||
            lower.contains('ka panchang') ||
            lower.contains('panchang') ||
            lower.contains('पंचांग') ||
            lower.contains('त्यौहार') ||
            lower.contains('tyohar') ||
            lower.contains('festival') ||
            lower.contains('holiday') ||
            lower.contains('छुट्टी'))) {
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      return ParsedQueryResult(
        intent: QueryIntentType.datePanchang,
        location: loc,
        startDate: explicitDate,
        endDate: explicitDate,
        targetDate: explicitDate,
        tradition: defaultTradition,
        updatedContext: currentContext ?? QueryContext(location: loc),
      );
    }

    if (_isTodayPanchangQuery(lower)) {
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final date = extractTargetDate(lower) ?? DateTime.now();
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
    } else if (_isMuhuratQuery(lower)) {
      // Default to general auspicious only if user asked "when is next muhurat"
      occasionId = 'general_auspicious';
      occasionTitle = 'General Auspicious';
    } else if (explicitDate != null) {
      // If a date was given without occasion, treat as date Panchang
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      return ParsedQueryResult(
        intent: QueryIntentType.datePanchang,
        location: loc,
        startDate: explicitDate,
        endDate: explicitDate,
        targetDate: explicitDate,
        tradition: defaultTradition,
        updatedContext: currentContext ?? QueryContext(location: loc),
      );
    } else {
      // Default fallback to Today's Panchang instead of confusing Muhurat
      final loc = _extractLocation(lower) ??
          currentContext?.location ??
          defaultLocation;
      final now = DateTime.now();
      return ParsedQueryResult(
        intent: QueryIntentType.panchangToday,
        location: loc,
        startDate: now,
        endDate: now,
        tradition: defaultTradition,
        updatedContext: currentContext ?? QueryContext(location: loc),
      );
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
      q.contains('सूरज') ||
      q.contains('suraj') ||
      q.contains('surya uday');

  static bool _isSunsetQuery(String q) =>
      q.contains('sunset') ||
      q.contains('सूर्यास्त') ||
      q.contains('સૂર્યાસ્ત') ||
      q.contains('surya ast') ||
      q.contains('suraj kab doob');

  static bool _isEkadashiQuery(String q) =>
      q.contains('ekadashi') ||
      q.contains('एकादशी') ||
      q.contains('એકાદશી') ||
      q.contains('parana') ||
      q.contains('पारणा') ||
      q.contains('gyaras') ||
      q.contains('agyaras') ||
      q.contains('ग्यारस') ||
      q.contains('अग्यारस');

  static bool _isRahuKaalQuery(String q) =>
      q.contains('rahu kaal') ||
      q.contains('rahukaal') ||
      q.contains('rahu kal') ||
      q.contains('rahu kalam') ||
      q.contains('राहु काल') ||
      q.contains('રાહુ કાળ');

  static bool _isTodayPanchangQuery(String q) =>
      (q.contains('panchang') ||
          q.contains('पंचांग') ||
          q.contains('आज का दिन') ||
          q.contains('आज का पंचांग')) &&
      !q.contains('muhurat') &&
      !q.contains('मुहूर्त');

  static bool _isTithiQuery(String q) =>
      (q.contains('tithi') || q.contains('तिथि') || q.contains('તિથિ')) &&
      (q.contains('kaun') ||
          q.contains('kya') ||
          q.contains('what') ||
          q.contains('which') ||
          q.contains('કઈ') ||
          q.contains('कोणती') ||
          q.contains('का बा') ||
          q.contains('कवन'));

  static bool _isNakshatraQuery(String q) =>
      (q.contains('nakshatra') || q.contains('नक्षत्र') || q.contains('નક્ષત્ર')) &&
      (q.contains('kaun') ||
          q.contains('kya') ||
          q.contains('what') ||
          q.contains('which') ||
          q.contains('કયું') ||
          q.contains('कोणते') ||
          q.contains('कवन'));

  static bool _isChoghadiyaQuery(String q) =>
      q.contains('choghadiya') ||
      q.contains('chaughadiya') ||
      q.contains('चौघड़िया') ||
      q.contains('चौघड़िया') ||
      q.contains('ચોઘડિયું');

  static bool _isMuhuratQuery(String q) =>
      q.contains('muhurat') ||
      q.contains('muhurath') ||
      q.contains('shubh muhurat') ||
      q.contains('lagan') ||
      q.contains('auspicious time') ||
      q.contains('मुहूर्त') ||
      q.contains('लग्न') ||
      q.contains('મુહૂર્ત') ||
      q.contains('शुभ मुहूर्त');

  static String? _extractOccasion(String q) {
    if (q.contains('marriage') ||
        q.contains('wedding') ||
        q.contains('vivah') ||
        q.contains('shadi') ||
        q.contains('shaadi') ||
        q.contains('byah') ||
        q.contains('biyah') ||
        q.contains('lagna') ||
        q.contains('lagan') ||
        q.contains('विवाह') ||
        q.contains('शादी') ||
        q.contains('लग्न') ||
        q.contains('ब्याह')) {
      return 'marriage';
    }
    if (q.contains('griha pravesh') ||
        q.contains('grihapravesh') ||
        q.contains('grah pravesh') ||
        q.contains('grahpravesh') ||
        q.contains('ghar pravesh') ||
        q.contains('house warming') ||
        q.contains('housewarming') ||
        q.contains('home warming') ||
        q.contains('naya ghar') ||
        q.contains('makan me pravesh') ||
        q.contains('गृह प्रवेश') ||
        q.contains('ગૃહ પ્રવેશ') ||
        q.contains('गृहप्रवेश')) {
      return 'griha_pravesh';
    }
    if (q.contains('vehicle') ||
        q.contains('car') ||
        q.contains('bike') ||
        q.contains('scooter') ||
        q.contains('motorcycle') ||
        q.contains('two wheeler') ||
        q.contains('four wheeler') ||
        q.contains('gaadi') ||
        q.contains('gadi') ||
        q.contains('gadhi') ||
        q.contains('vahan') ||
        q.contains('vaahan') ||
        q.contains('kharid') ||
        q.contains('karid') ||
        q.contains('khareed') ||
        q.contains('kharidna') ||
        q.contains('kharidne') ||
        q.contains('karid nei') ||
        q.contains('karidna') ||
        q.contains('khareedna') ||
        q.contains('buy car') ||
        q.contains('buy vehicle') ||
        q.contains('गाड़ी') ||
        q.contains('गाड़ी') ||
        q.contains('वाहन') ||
        q.contains('વાહન')) {
      return 'vehicle_purchase';
    }
    if (q.contains('property') ||
        q.contains('land') ||
        q.contains('flat') ||
        q.contains('plot') ||
        q.contains('zameen') ||
        q.contains('zamin') ||
        q.contains('jameen') ||
        q.contains('jamin') ||
        q.contains('makan kharid') ||
        q.contains('registry') ||
        q.contains('मकान') ||
        q.contains('जमीन') ||
        q.contains('પ્રોપર્ટી')) {
      return 'property_purchase';
    }
    if (q.contains('business') ||
        q.contains('shop') ||
        q.contains('office') ||
        q.contains('store') ||
        q.contains('startup') ||
        q.contains('dukan') ||
        q.contains('dukaan') ||
        q.contains('vyapar') ||
        q.contains('kam dhandha') ||
        q.contains('karobar') ||
        q.contains('व्यापार') ||
        q.contains('दुकान') ||
        q.contains('દુકાન') ||
        q.contains('ऑफिस')) {
      return 'business_opening';
    }
    if (q.contains('mundan') ||
        q.contains('mundun') ||
        q.contains('tonsure') ||
        q.contains('chudakarana') ||
        q.contains('chulakarana') ||
        q.contains('मुंडन') ||
        q.contains('મુંડન') ||
        q.contains('ચૌલ સંસ્કાર')) {
      return 'mundan';
    }
    if (q.contains('namkaran') ||
        q.contains('naamkaran') ||
        q.contains('naam sanskar') ||
        q.contains('naming') ||
        q.contains('नामकरण') ||
        q.contains('નામકરણ')) {
      return 'namkaran';
    }
    if (q.contains('annaprashan') ||
        q.contains('annaprasana') ||
        q.contains('annaprashana') ||
        q.contains('kheer khilana') ||
        q.contains('अन्नप्राशन') ||
        q.contains('અન્નપ્રાશન')) {
      return 'annaprashan';
    }
    if (q.contains('vidyarambh') ||
        q.contains('akshararambham') ||
        q.contains('education') ||
        q.contains('school admission') ||
        q.contains('padhai') ||
        q.contains('विद्यारंभ') ||
        q.contains('વિદ્યારંભ')) {
      return 'vidyarambh';
    }
    if (q.contains('bhoomi') ||
        q.contains('bhumi') ||
        q.contains('bhoomi pujan') ||
        q.contains('bhumi pujan') ||
        q.contains('bhumipujan') ||
        q.contains('foundation') ||
        q.contains('neev') ||
        q.contains('नींव') ||
        q.contains('भूमि पूजन') ||
        q.contains('ભૂમિ પૂજન')) {
      return 'bhoomi_pujan';
    }
    if (q.contains('travel') ||
        q.contains('yatra') ||
        q.contains('safar') ||
        q.contains('tour') ||
        q.contains('यात्रा')) {
      return 'travel';
    }
    if (q.contains('puja') ||
        q.contains('pooja') ||
        q.contains('havan') ||
        q.contains('hawan') ||
        q.contains('homam') ||
        q.contains('satyanarayan') ||
        q.contains('rudrabhishek') ||
        q.contains('katha') ||
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

  static DateTime? _extractSingleDate(String q) => extractTargetDate(q);

  /// Extracts target date from explicit mentions (e.g. "10 october", "10 अक्टूबर", "10/10") or relative (today, kal, etc.)
  static DateTime? extractTargetDate(String q) {
    final lower = q.trim().toLowerCase();
    final now = DateTime.now();

    // 1. Relative checks
    if (lower.contains('day after tomorrow') ||
        lower.contains('parso') ||
        lower.contains('परसों') ||
        lower.contains('પરમ દિવસે')) {
      return now.add(const Duration(days: 2));
    }
    if (lower.contains('tomorrow') ||
        lower.contains('kal') ||
        lower.contains('कल') ||
        lower.contains('કાલે') ||
        lower.contains('काल्हि')) {
      return now.add(const Duration(days: 1));
    }
    if (lower.contains('yesterday') ||
        lower.contains('kal tha') ||
        lower.contains('बीता कल')) {
      return now.subtract(const Duration(days: 1));
    }
    if (lower.contains('today') ||
        lower.contains('aaj') ||
        lower.contains('आज') ||
        lower.contains('આજે') ||
        lower.contains('आजु')) {
      return now;
    }

    // 2. Month name mappings
    final monthMap = {
      'january': 1, 'jan': 1, 'जनवरी': 1, 'જાન્યુઆરી': 1,
      'february': 2, 'feb': 2, 'फरवरी': 2, 'ફેબ્રુઆરી': 2,
      'march': 3, 'mar': 3, 'मार्च': 3, 'માર્ચ': 3,
      'april': 4, 'apr': 4, 'अप्रैल': 4, 'એપ્રિલ': 4,
      'may': 5, 'मई': 5, 'મે': 5,
      'june': 6, 'jun': 6, 'जून': 6, 'જૂન': 6,
      'july': 7, 'jul': 7, 'जुलाई': 7, 'જુલાઈ': 7,
      'august': 8, 'aug': 8, 'अगस्त': 8, 'ઓગસ્ટ': 8,
      'september': 9, 'sep': 9, 'sept': 9, 'सितंबर': 9, 'सप्टेंबर': 9, 'સપ્ટેમ્બર': 9,
      'october': 10, 'oct': 10, 'अक्टूबर': 10, 'अक्तूबर': 10, 'ऑक्टोबर': 10, 'ઓક્ટોબર': 10,
      'november': 11, 'nov': 11, 'नवंबर': 11, 'નવેમ્બર': 11,
      'december': 12, 'dec': 12, 'दिसंबर': 12, 'ડિસેમ્બર': 12,
    };

    // Replace Devanagari numerals with ASCII numerals if any
    String normalized = lower;
    const devanagariDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
    for (int i = 0; i < 10; i++) {
      normalized = normalized.replaceAll(devanagariDigits[i], '$i');
    }

    // Check "10 october", "10th october", "10 oct", "10 को", "10 अक्टूबर"
    for (final entry in monthMap.entries) {
      final mName = entry.key;
      final mNum = entry.value;

      // Pattern 1: Day followed by Month (e.g. "10 october", "10th oct", "10 अक्टूबर", "10 तारीख अक्टूबर")
      final p1 = RegExp('\\b(\\d{1,2})(?:st|nd|rd|th)?\\s*(?:tarikh\\s+|tareekh\\s+|tariqh\\s+|of\\s+)?$mName\\b');
      final m1 = p1.firstMatch(normalized);
      if (m1 != null) {
        final day = int.tryParse(m1.group(1)!);
        if (day != null && day >= 1 && day <= 31) {
          int year = now.year;
          final yMatch = RegExp(r'\b(202[4-9]|203[0-5])\b').firstMatch(normalized);
          if (yMatch != null) year = int.parse(yMatch.group(1)!);
          return DateTime(year, mNum, day);
        }
      }

      // Pattern 2: Month followed by Day (e.g. "october 10", "अक्टूबर 10")
      final p2 = RegExp('\\b$mName\\s+(\\d{1,2})(?:st|nd|rd|th)?\\b');
      final m2 = p2.firstMatch(normalized);
      if (m2 != null) {
        final day = int.tryParse(m2.group(1)!);
        if (day != null && day >= 1 && day <= 31) {
          int year = now.year;
          final yMatch = RegExp(r'\b(202[4-9]|203[0-5])\b').firstMatch(normalized);
          if (yMatch != null) year = int.parse(yMatch.group(1)!);
          return DateTime(year, mNum, day);
        }
      }
    }

    // Pattern 3: Slash / Dash format (e.g. 10/10/2026, 10-10)
    final p3 = RegExp(r'\b(\d{1,2})[\/\-](\d{1,2})(?:[\/\-](\d{2,4}))?\b');
    final m3 = p3.firstMatch(normalized);
    if (m3 != null) {
      final day = int.tryParse(m3.group(1)!);
      final month = int.tryParse(m3.group(2)!);
      int year = now.year;
      if (m3.group(3) != null) {
        final yVal = int.tryParse(m3.group(3)!);
        if (yVal != null) {
          year = yVal < 100 ? (2000 + yVal) : yVal;
        }
      }
      if (day != null && month != null && day >= 1 && day <= 31 && month >= 1 && month <= 12) {
        return DateTime(year, month, day);
      }
    }

    return null;
  }

  static ({DateTime start, DateTime end}) _extractDateRange(
      String q, QueryContext? ctx) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Single-day target checks (e.g. "aaj", "today", "kal", "tomorrow", "parso")
    if (q.contains('today') ||
        q.contains('aaj') ||
        q.contains('आज') ||
        q.contains('આજે') ||
        q.contains('आजु')) {
      return (start: today, end: today);
    }

    if (q.contains('day after tomorrow') ||
        q.contains('parso') ||
        q.contains('परसों') ||
        q.contains('પરમ દિવસે')) {
      final target = today.add(const Duration(days: 2));
      return (start: target, end: target);
    }

    if (q.contains('tomorrow') ||
        q.contains('kal') ||
        q.contains('कल') ||
        q.contains('કાલે') ||
        q.contains('काल्हि')) {
      final target = today.add(const Duration(days: 1));
      return (start: target, end: target);
    }

    // Check week mentions
    if (q.contains('this week') ||
        q.contains('is hafte') ||
        q.contains('is saptah') ||
        q.contains('इस हफ्ते') ||
        q.contains('આ અઠવાડિયે')) {
      int daysUntilSunday = (7 - today.weekday) % 7;
      final end = today.add(Duration(days: daysUntilSunday == 0 ? 0 : daysUntilSunday));
      return (start: today, end: end);
    }

    if (q.contains('next week') ||
        q.contains('agale hafte') ||
        q.contains('agla hafta') ||
        q.contains('अगले हफ्ते')) {
      final start = today.add(const Duration(days: 7));
      final end = start.add(const Duration(days: 7));
      return (start: start, end: end);
    }

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
      final sun = sat.add(const Duration(days: 1));
      return (start: sat, end: sun);
    }

    if (q.contains('next weekend')) {
      int daysUntilSat = ((6 - now.weekday + 7) % 7) + 7;
      final sat = now.add(Duration(days: daysUntilSat));
      final sun = sat.add(const Duration(days: 1));
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

    // Context fallback
    if (ctx?.startDate != null && ctx?.endDate != null) {
      return (start: ctx!.startDate!, end: ctx.endDate!);
    }

    // Default: Next 30 days
    return (start: now, end: now.add(const Duration(days: 30)));
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
