import '../../core/constants/panchang_constants.dart';
import '../../domain/models/location_info.dart';
import '../../domain/models/panchang_day.dart';
import '../../l10n/app_localizations.dart';
import '../ekadashi/ekadashi_service.dart';
import '../festivals/festival_lookup_service.dart';
import '../muhurat/muhurat_service.dart';
import '../nlp/nlp_query_parser.dart';
import '../panchang/panchang_service.dart';
import '../panchang/tithi_search_service.dart';

enum VoiceState {
  idle,
  listening,
  processing,
  speaking,
}

class VoiceResponse {
  final String spokenText;
  final String displayText;
  final QueryIntentType intent;
  final dynamic structuredData; // PanchangDay, EkadashiInfo, MuhuratSearchResult, etc.

  const VoiceResponse({
    required this.spokenText,
    required this.displayText,
    required this.intent,
    this.structuredData,
  });
}

class VoiceService {
  /// Generate multilingual natural language spoken response and UI card data
  static VoiceResponse processVoiceQuery({
    required String query,
    required LocationInfo defaultLocation,
    required String voiceLanguageCode, // 'en', 'hi', 'gu', 'mr', 'bho'
    CalendarTradition tradition = CalendarTradition.standardHindu,
  }) {
    final parsed = NlpQueryParser.parse(
      query: query,
      defaultLocation: defaultLocation,
      defaultTradition: tradition,
    );

    switch (parsed.intent) {
      case QueryIntentType.festivalVerification:
        final verifyResult = FestivalLookupService.verifyFestivalOnDate(
          festival: parsed.festival!,
          targetDate: parsed.targetDate ?? parsed.startDate,
          location: parsed.location,
          tradition: tradition,
        );
        return _formatFestivalVerificationResponse(verifyResult, voiceLanguageCode);

      case QueryIntentType.festivalDate:
        final dateResult = FestivalLookupService.findFestivalDate(
          festival: parsed.festival!,
          location: parsed.location,
          fromDate: DateTime.now(),
          tradition: tradition,
        );
        return _formatFestivalDateResponse(parsed.festival!, dateResult, parsed.location, voiceLanguageCode);

      case QueryIntentType.datePanchang:
        final panchang = PanchangService.calculatePanchang(
          date: parsed.targetDate ?? parsed.startDate,
          location: parsed.location,
          tradition: tradition,
        );
        return _formatDatePanchangResponse(panchang, voiceLanguageCode);

      case QueryIntentType.tithiQuery:
        final panchang = PanchangService.calculatePanchang(
          date: parsed.targetDate ?? parsed.startDate,
          location: parsed.location,
          tradition: tradition,
        );
        return _formatTithiResponse(panchang, voiceLanguageCode);

      case QueryIntentType.tithiSearch:
        final tithiResult = TithiSearchService.findNextTithi(
          target: parsed.targetTithi!,
          location: parsed.location,
          fromDate: DateTime.now(),
          tradition: tradition,
        );
        return _formatTithiSearchResponse(parsed.targetTithi!, tithiResult, voiceLanguageCode);

      case QueryIntentType.nakshatraQuery:
        final panchang = PanchangService.calculatePanchang(
          date: parsed.targetDate ?? parsed.startDate,
          location: parsed.location,
          tradition: tradition,
        );
        return _formatNakshatraResponse(panchang, voiceLanguageCode);

      case QueryIntentType.choghadiyaQuery:
        final panchang = PanchangService.calculatePanchang(
          date: parsed.targetDate ?? parsed.startDate,
          location: parsed.location,
          tradition: tradition,
        );
        return _formatChoghadiyaResponse(panchang, voiceLanguageCode);

      case QueryIntentType.panchangToday:
        final panchang = PanchangService.calculatePanchang(
          date: parsed.startDate,
          location: parsed.location,
          tradition: tradition,
        );
        return _formatPanchangResponse(panchang, voiceLanguageCode);

      case QueryIntentType.sunrise:
        final panchang = PanchangService.calculatePanchang(
          date: parsed.startDate,
          location: parsed.location,
          tradition: tradition,
        );
        return _formatSunriseResponse(panchang, voiceLanguageCode);

      case QueryIntentType.sunset:
        final panchang = PanchangService.calculatePanchang(
          date: parsed.startDate,
          location: parsed.location,
          tradition: tradition,
        );
        return _formatSunsetResponse(panchang, voiceLanguageCode);

      case QueryIntentType.nextEkadashi:
        final ekadashi = EkadashiService.getNextEkadashi(
          fromDate: DateTime.now(),
          location: parsed.location,
          tradition: tradition,
        );
        return _formatEkadashiResponse(ekadashi, voiceLanguageCode);

      case QueryIntentType.rahuKaal:
        final panchang = PanchangService.calculatePanchang(
          date: parsed.startDate,
          location: parsed.location,
          tradition: tradition,
        );
        return _formatRahuKaalResponse(panchang, voiceLanguageCode);

      case QueryIntentType.muhuratSearch:
      case QueryIntentType.unknown:
        final result = MuhuratService.findMuhurat(
          occasionId: parsed.occasionId ?? 'general_auspicious',
          location: parsed.location,
          startDate: parsed.startDate,
          endDate: parsed.endDate,
          tradition: tradition,
          preferredWeekdays: parsed.preferredWeekdays,
          earliestHour: parsed.earliestHour,
          latestHour: parsed.latestHour,
        );
        return _formatMuhuratResponse(result, voiceLanguageCode);
    }
  }

  static VoiceResponse _formatPanchangResponse(
      PanchangDay p, String lang) {
    final sunrise = _formatTime(p.astronomicalSunrise);
    final sunset = _formatTime(p.astronomicalSunset);
    final tithi = p.tithiName;
    final nak = p.nakshatraName;
    final loc = p.location.name;

    String spoken;
    String display;

    switch (lang) {
      case 'hi':
        spoken =
            '$loc में आज ${p.lunarMonthName} मास की $tithi तिथि और $nak नक्षत्र है। सूर्योदय सुबह $sunrise और सूर्यास्त शाम $sunset को होगा।';
        display =
            'आज का पंचांग ($loc)\nतिथि: $tithi\nनक्षत्र: $nak\nसूर्योदय: $sunrise | सूर्यास्त: $sunset';
        break;
      case 'gu':
        spoken =
            '$loc માં આજે ${p.lunarMonthName} માસની $tithi તિથિ અને $nak નક્ષત્ર છે. સૂર્યોદય સવારે $sunrise અને સૂર્યાસ્ત સાંજે $sunset વાગ્યે થશે.';
        display =
            'આજનું પંચાંગ ($loc)\nતિથિ: $tithi\nનક્ષત્ર: $nak\nસૂર્યોદય: $sunrise | સૂર્યાસ્ત: $sunset';
        break;
      case 'mr':
        spoken =
            '$loc मध्ये आज ${p.lunarMonthName} महिन्याची $tithi तिथी आणि $nak नक्षत्र आहे. सूर्योदय सकाळी $sunrise आणि सूर्यास्त संध्याकाळी $sunset वाजता होईल.';
        display =
            'आजचे पंचांग ($loc)\nतिथी: $tithi\nनक्षत्र: $nak\nसूर्योदय: $sunrise | सूर्यास्त: $sunset';
        break;
      case 'bho':
        spoken =
            '$loc में आजु ${p.lunarMonthName} महीना के $tithi बा अउर $nak नक्षत्र बा। सूरज उगे के बेरा $sunrise अउर डूबे के बेरा $sunset बा।';
        display =
            'आजु के पंचांग ($loc)\nतिथि: $tithi\nनक्षत्र: $nak\nसूर्योदय: $sunrise | सूर्यास्त: $sunset';
        break;
      case 'en':
      default:
        spoken =
            'Today in $loc, it is ${p.lunarMonthName} $tithi with $nak Nakshatra. Astronomical sunrise is at $sunrise and sunset at $sunset.';
        display =
            'Today\'s Panchang ($loc)\nTithi: $tithi\nNakshatra: $nak\nSunrise: $sunrise | Sunset: $sunset';
        break;
    }

    return VoiceResponse(
      spokenText: spoken,
      displayText: display,
      intent: QueryIntentType.panchangToday,
      structuredData: p,
    );
  }

  static VoiceResponse _formatSunriseResponse(PanchangDay p, String lang) {
    final sunrise = _formatTime(p.astronomicalSunrise);
    final loc = p.location.displayName;

    String spoken;
    switch (lang) {
      case 'hi':
        spoken = '$loc में सूर्योदय $sunrise को होगा।';
        break;
      case 'gu':
        spoken = '$loc માં સૂર્યોદય સવારે $sunrise વાગ્યે થશે.';
        break;
      case 'mr':
        spoken = '$loc मध्ये सूर्योदय सकाळी $sunrise वाजता होईल.';
        break;
      case 'bho':
        spoken = '$loc में सूरज भोरवा $sunrise बजे उगीं।';
        break;
      default:
        spoken = 'Astronomical sunrise in $loc is at $sunrise.';
    }

    return VoiceResponse(
      spokenText: spoken,
      displayText: '🌅 Astronomical Sunrise ($loc): $sunrise',
      intent: QueryIntentType.sunrise,
      structuredData: p,
    );
  }

  static VoiceResponse _formatSunsetResponse(PanchangDay p, String lang) {
    final sunset = _formatTime(p.astronomicalSunset);
    final loc = p.location.displayName;

    String spoken;
    switch (lang) {
      case 'hi':
        spoken = '$loc में सूर्यास्त शाम $sunset को होगा।';
        break;
      case 'gu':
        spoken = '$loc માં સૂર્યાસ્ત સાંજે $sunset વાગ્યે થશે.';
        break;
      case 'mr':
        spoken = '$loc मध्ये सूर्यास्त संध्याकाळी $sunset वाजता होईल.';
        break;
      case 'bho':
        spoken = '$loc में सूरज सांझ के $sunset बजे डूबीं।';
        break;
      default:
        spoken = 'Astronomical sunset in $loc is at $sunset.';
    }

    return VoiceResponse(
      spokenText: spoken,
      displayText: '🌇 Astronomical Sunset ($loc): $sunset',
      intent: QueryIntentType.sunset,
      structuredData: p,
    );
  }

  static VoiceResponse _formatEkadashiResponse(dynamic ek, String lang) {
    final name = ek.name;
    final date = '${ek.date.day} ${_monthName(ek.date.month)}';
    final loc = ek.location.displayName;

    String spoken;
    switch (lang) {
      case 'hi':
        spoken = 'अगली एकादशी $name है, जो $date को $loc में पड़ेगी। पारणा का समय अगली सुबह है।';
        break;
      case 'gu':
        spoken = 'આગામી એકાદશી $name છે, જે $date ના રોજ $loc માં છે. પારણા નો સમય બીજા દિવસે સવારે છે.';
        break;
      case 'mr':
        spoken = 'पुढील एकादशी $name असून ती $date रोजी $loc मध्ये येईल.';
        break;
      case 'bho':
        spoken = 'अगिला एकादशी $name ह, जवन $date के $loc में पड़ी। पारना अगिला दिन के बिहाने होई।';
        break;
      default:
        spoken = 'The next Ekadashi is $name on $date in $loc. Parana begins next morning at sunrise.';
    }

    return VoiceResponse(
      spokenText: spoken,
      displayText: '🌙 Next Ekadashi: $name\nDate: $date\nLocation: $loc\nParana: ${ek.formattedParana}',
      intent: QueryIntentType.nextEkadashi,
      structuredData: ek,
    );
  }

  static VoiceResponse _formatRahuKaalResponse(PanchangDay p, String lang) {
    final start = _formatTime(p.rahuKaalStart);
    final end = _formatTime(p.rahuKaalEnd);
    final loc = p.location.displayName;

    String spoken;
    switch (lang) {
      case 'hi':
        spoken = '$loc में आज राहु काल $start से $end तक है। इस समय शुभ कार्य वर्जित हैं।';
        break;
      case 'gu':
        spoken = '$loc માં આજે રાહુ કાળ $start થી $end વાગ્યા સુધી છે.';
        break;
      case 'mr':
        spoken = '$loc मध्ये आज राहू काळ $start ते $end पर्यंत आहे.';
        break;
      case 'bho':
        spoken = '$loc में आजु राहु काल $start से $end ले बा। एहि समय कवनो शुभ काम ना कइल जाला।';
        break;
      default:
        spoken = 'Today\'s Rahu Kaal in $loc is from $start to $end. Auspicious activities should be avoided.';
    }

    return VoiceResponse(
      spokenText: spoken,
      displayText: '🔴 Rahu Kaal ($loc):\n$start – $end',
      intent: QueryIntentType.rahuKaal,
      structuredData: p,
    );
  }

  static VoiceResponse _formatMuhuratResponse(
      MuhuratSearchResult res, String lang) {
    final count = res.windows.length;
    final loc = res.location.displayName;
    final title = res.occasionTitle;

    if (!res.hasResults) {
      String spoken;
      switch (lang) {
        case 'hi':
          spoken = '$loc में इस अवधि के दौरान कोई उपयुक्त $title मुहूर्त नहीं मिला। आप तारीख सीमा बढ़ा सकते हैं।';
          break;
        case 'gu':
          spoken = '$loc માં આ સમયગાળા દરમિયાન કોઈ યોગ્ય $title મુહૂર્ત મળ્યું નથી.';
          break;
        case 'bho':
          spoken = '$loc में एह बीचे कवनो बढ़िया $title के मुहूर्त नइखे मिलल।';
          break;
        default:
          spoken = 'No suitable $title windows were found in $loc during this period. Try expanding the date range.';
      }
      return VoiceResponse(
        spokenText: spoken,
        displayText: 'No suitable Muhurat found for $title in $loc.',
        intent: QueryIntentType.muhuratSearch,
        structuredData: res,
      );
    }

    final first = res.windows.first;
    final firstDate = '${first.date.day} ${_monthName(first.date.month)}';
    final firstTime = first.formattedTiming;

    String spoken;
    switch (lang) {
      case 'hi':
        spoken = '$loc में $title के लिए $count उपयुक्त मुहूर्त मिले हैं। पहला $firstDate को $firstTime तक है।';
        break;
      case 'gu':
        spoken = '$loc માં $title માટે $count યોગ્ય મુહૂર્ત મળ્યા છે. પહેલું મુહૂર્ત $firstDate ના રોજ $firstTime છે.';
        break;
      case 'bho':
        spoken = '$loc में $title खातिर कुल $count गो नीक मुहूर्त मिलल बा। पहिला मुहूर्त $firstDate के $firstTime बा।';
        break;
      default:
        spoken = '$count suitable windows found for $title in $loc. The first window is on $firstDate from $firstTime.';
    }

    return VoiceResponse(
      spokenText: spoken,
      displayText: '🪔 $title Muhurat ($loc)\n$count suitable windows found\nFirst: $firstDate ($firstTime)',
      intent: QueryIntentType.muhuratSearch,
      structuredData: res,
    );
  }

  static String _monthName(int month) {
    const m = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return m[month - 1];
  }

  static String _localizedMonthName(int month, String lang) {
    return AppLocalizations.getMonthName(month, lang);
  }

  static String _localizedWeekdayName(DateTime date, String lang) {
    return AppLocalizations.getVaraName(date.weekday, lang);
  }

  static VoiceResponse _formatFestivalVerificationResponse(
      FestivalVerificationResult res, String lang) {
    final festName = res.festival.names[lang] ?? res.festival.names['hi']!;
    final targetDate = res.targetDate;
    final targetP = res.targetDatePanchang;
    final mName = _localizedMonthName(targetDate.month, lang);
    final vName = _localizedWeekdayName(targetDate, lang);

    String spoken;
    String display;

    if (res.isFestivalOnTargetDate) {
      final tithiName = AppLocalizations.getTithiName(targetP.tithiNumber, lang);
      final lunarMonth = AppLocalizations.getLunarMonthName(targetP.lunarMonthName, lang);
      final paksha = AppLocalizations.getPakshaName(targetP.paksha, lang);

      switch (lang) {
        case 'hi':
          spoken = 'हाँ, ${targetDate.day} $mName ${targetDate.year} को $festName है। इस दिन $lunarMonth मास के $paksha की $tithiName तिथि है।';
          break;
        case 'gu':
          spoken = 'હા, ${targetDate.day} $mName ${targetDate.year} ના રોજ $festName છે. આ દિવસે $lunarMonth માસના $paksha ની $tithiName તિથિ છે.';
          break;
        case 'mr':
          spoken = 'हो, ${targetDate.day} $mName ${targetDate.year} रोजी $festName आहे. या दिवशी $lunarMonth महिन्यातील $paksha ची $tithiName तिथी आहे.';
          break;
        case 'bho':
          spoken = 'हाँ, ${targetDate.day} $mName ${targetDate.year} के $festName बा। एह दिन $lunarMonth महीना के $tithiName तिथि बा।';
          break;
        default:
          spoken = 'Yes, $festName is on ${targetDate.day} $mName ${targetDate.year} ($lunarMonth $tithiName).';
      }

      display = '✓ $festName\nदिनांक: ${targetDate.day} $mName ${targetDate.year} ($vName)\nमास: $lunarMonth ($paksha)\nतिथि: $tithiName';
    } else {
      // Not on target date
      final targetEvents = [...targetP.festivals, ...targetP.vrats];
      final targetTithi = AppLocalizations.getTithiName(targetP.tithiNumber, lang);
      final targetMonth = AppLocalizations.getLunarMonthName(targetP.lunarMonthName, lang);
      final targetEventDesc = targetEvents.isNotEmpty
          ? targetEvents.map((e) => AppLocalizations.localizeFestivalName(e, lang)).join(', ')
          : '$targetTithi ($targetMonth)';

      final actual = res.actualFestivalDate;
      String actualStr = '';
      String actualDisplayStr = '';

      if (actual != null) {
        final actD = actual.date;
        final actM = _localizedMonthName(actD.month, lang);
        final actV = _localizedWeekdayName(actD, lang);
        final actTithi = AppLocalizations.getTithiName(actual.panchang.tithiNumber, lang);
        final actMonth = AppLocalizations.getLunarMonthName(actual.panchang.lunarMonthName, lang);
        final actPaksha = AppLocalizations.getPakshaName(actual.panchang.paksha, lang);

        switch (lang) {
          case 'hi':
            actualStr = ' $festName ${actD.day} $actM ${actD.year}, $actV को है (तिथि: $actMonth $actPaksha $actTithi)।';
            break;
          case 'gu':
            actualStr = ' $festName ${actD.day} $actM ${actD.year}, $actVના દિવસે છે (તિથિ: $actMonth $actPaksha $actTithi).';
            break;
          case 'mr':
            actualStr = ' $festName ${actD.day} $actM ${actD.year}, $actV रोजी आहे ($actMonth $actPaksha $actTithi).';
            break;
          case 'bho':
            actualStr = ' $festName ${actD.day} $actM ${actD.year}, $actV के बा ($actMonth $actTithi)।';
            break;
          default:
            actualStr = ' $festName is on ${actD.day} $actM ${actD.year}, $actV ($actMonth $actPaksha $actTithi).';
        }

        actualDisplayStr = '\n• सही दिनांक: ${actD.day} $actM ${actD.year} ($actV)\n• तिथि: $actMonth $actPaksha $actTithi';
      }

      switch (lang) {
        case 'hi':
          spoken = 'नहीं, ${targetDate.day} $mName को $festName नहीं है। उस दिन $targetEventDesc है।$actualStr';
          break;
        case 'gu':
          spoken = 'ના, ${targetDate.day} $mName ના રોજ $festName નથી. તે દિવસે $targetEventDesc છે.$actualStr';
          break;
        case 'mr':
          spoken = 'नाही, ${targetDate.day} $mName रोजी $festName नाही. त्या दिवशी $targetEventDesc आहे.$actualStr';
          break;
        case 'bho':
          spoken = 'नाहीं, ${targetDate.day} $mName के $festName नइखे। ओह दिन $targetEventDesc बा।$actualStr';
          break;
        default:
          spoken = 'No, $festName is not on ${targetDate.day} $mName ${targetDate.year}. On that day, it is $targetEventDesc.$actualStr';
      }

      display = '❌ $festName ${targetDate.day} $mName को नहीं है\n• ${targetDate.day} $mName को: $targetEventDesc$actualDisplayStr';
    }

    return VoiceResponse(
      spokenText: spoken,
      displayText: display,
      intent: QueryIntentType.festivalVerification,
      structuredData: res,
    );
  }

  static VoiceResponse _formatFestivalDateResponse(
      FestivalDefinition festival, FestivalDateResult? res, LocationInfo loc, String lang) {
    final festName = festival.names[lang] ?? festival.names['hi']!;

    if (res == null) {
      String spoken;
      switch (lang) {
        case 'hi':
          spoken = '$festName की तिथि इस वर्ष की गणना में नहीं मिली।';
          break;
        case 'gu':
          spoken = '$festName ની તારીખ આ વર્ષે મળી નથી.';
          break;
        case 'mr':
          spoken = '$festName ची तारीख या वर्षात सापडली नाही.';
          break;
        case 'bho':
          spoken = '$festName के तारीख एह साल ना मिलल।';
          break;
        default:
          spoken = 'Could not find the date for $festName in the current year.';
      }
      return VoiceResponse(
        spokenText: spoken,
        displayText: 'Date not found for $festName',
        intent: QueryIntentType.festivalDate,
      );
    }

    final d = res.date;
    final p = res.panchang;
    final mName = _localizedMonthName(d.month, lang);
    final vName = _localizedWeekdayName(d, lang);
    final tithiName = AppLocalizations.getTithiName(p.tithiNumber, lang);
    final lunarMonth = AppLocalizations.getLunarMonthName(p.lunarMonthName, lang);
    final paksha = AppLocalizations.getPakshaName(p.paksha, lang);

    String spoken;
    switch (lang) {
      case 'hi':
        spoken = '$festName ${d.day} $mName ${d.year}, $vName को है। यह $lunarMonth मास के $paksha की $tithiName तिथि को मनाया जाता है।';
        break;
      case 'gu':
        spoken = '$festName ${d.day} $mName ${d.year}, $vNameના દિવસે છે. આ $lunarMonth માસના $paksha ની $tithiName તિથિએ ઉજવાય છે.';
        break;
      case 'mr':
        spoken = '$festName ${d.day} $mName ${d.year}, $vName रोजी आहे. हा $lunarMonth महिन्यातील $paksha च्या $tithiName तिथीला साजरा केला जातो.';
        break;
      case 'bho':
        spoken = '$festName ${d.day} $mName ${d.year}, $vName के बा। ई $lunarMonth महीना के $tithiName तिथि के दिन बा।';
        break;
      default:
        spoken = '$festName is on ${d.day} $mName ${d.year}, $vName. It falls on $lunarMonth $paksha $tithiName.';
    }

    final display = '🪔 $festName\nदिनांक: ${d.day} $mName ${d.year} ($vName)\nमास: $lunarMonth ($paksha)\nतिथि: $tithiName\nनक्षत्र: ${AppLocalizations.getNakshatraName(p.nakshatraName, lang)}';

    return VoiceResponse(
      spokenText: spoken,
      displayText: display,
      intent: QueryIntentType.festivalDate,
      structuredData: res,
    );
  }

  static VoiceResponse _formatDatePanchangResponse(PanchangDay p, String lang) {
    final d = p.localDate;
    final mName = _localizedMonthName(d.month, lang);
    final vName = _localizedWeekdayName(d, lang);
    final tithiName = AppLocalizations.getTithiName(p.tithiNumber, lang);
    final lunarMonth = AppLocalizations.getLunarMonthName(p.lunarMonthName, lang);
    final paksha = AppLocalizations.getPakshaName(p.paksha, lang);
    final nakName = AppLocalizations.getNakshatraName(p.nakshatraName, lang);
    final sunrise = _formatTime(p.astronomicalSunrise);
    final sunset = _formatTime(p.astronomicalSunset);

    final events = [...p.festivals, ...p.vrats]
        .map((e) => AppLocalizations.localizeFestivalName(e, lang))
        .toList();
    final eventsStr = events.isNotEmpty ? '\nपर्व/व्रत: ${events.join(', ')}' : '';

    String spoken;
    switch (lang) {
      case 'hi':
        spoken = '${d.day} $mName ${d.year}, $vName को $lunarMonth मास के $paksha की $tithiName तिथि और $nakName नक्षत्र है। सूर्योदय $sunrise और सूर्यास्त $sunset को होगा।' +
            (events.isNotEmpty ? ' मुख्य पर्व: ${events.join(", ")}।' : '');
        break;
      case 'gu':
        spoken = '${d.day} $mName ${d.year}, $vNameના રોજ $lunarMonth માસની $tithiName તિથિ અને $nakName નક્ષત્ર છે. સૂર્યોદય $sunrise અને સૂર્યાસ્ત $sunset વાગ્યે થશે.' +
            (events.isNotEmpty ? ' તહેવારો: ${events.join(", ")}.' : '');
        break;
      default:
        spoken = 'On ${d.day} $mName ${d.year} ($vName), it is $lunarMonth $paksha $tithiName with $nakName Nakshatra. Sunrise is at $sunrise and sunset at $sunset.' +
            (events.isNotEmpty ? ' Observances: ${events.join(", ")}.' : '');
    }

    final display = '📅 पंचांग (${d.day} $mName ${d.year})\nवार: $vName\nतिथि: $tithiName ($paksha)\nनक्षत्र: $nakName\nसूर्योदय: $sunrise | सूर्यास्त: $sunset$eventsStr';

    return VoiceResponse(
      spokenText: spoken,
      displayText: display,
      intent: QueryIntentType.datePanchang,
      structuredData: p,
    );
  }

  static VoiceResponse _formatTithiResponse(PanchangDay p, String lang) {
    final tithiName = AppLocalizations.getTithiName(p.tithiNumber, lang);
    final lunarMonth = AppLocalizations.getLunarMonthName(p.lunarMonthName, lang);
    final paksha = AppLocalizations.getPakshaName(p.paksha, lang);
    final endTime = _formatTime(p.tithiEndTime);
    final nextTithi = AppLocalizations.getTithiName((p.tithiNumber % 30) + 1, lang);

    String spoken;
    switch (lang) {
      case 'hi':
        spoken = 'आज $lunarMonth मास के $paksha की $tithiName तिथि है, जो $endTime तक रहेगी। इसके बाद $nextTithi तिथि शुरू होगी।';
        break;
      case 'gu':
        spoken = 'આજે $lunarMonth માસના $paksha ની $tithiName તિથિ છે, જે $endTime સુધી રહેશે. ત્યારબાદ $nextTithi તિથિ શરૂ થશે.';
        break;
      default:
        spoken = 'Today is $lunarMonth $paksha $tithiName, valid until $endTime. After this, $nextTithi begins.';
    }

    final display = '🌙 तिथि: $tithiName ($paksha)\nमास: $lunarMonth\nसमाप्ति समय: $endTime\nआगामी तिथि: $nextTithi';

    return VoiceResponse(
      spokenText: spoken,
      displayText: display,
      intent: QueryIntentType.tithiQuery,
      structuredData: p,
    );
  }

  static VoiceResponse _formatTithiSearchResponse(
      TithiTarget target, TithiSearchResult? res, String lang) {
    final tName = target.names[lang] ?? target.names['hi']!;

    if (res == null) {
      String spoken;
      switch (lang) {
        case 'hi':
          spoken = '$tName तिथि आगामी दिनों में नहीं मिली।';
          break;
        case 'gu':
          spoken = '$tName તિથિ આગામી દિવસોમાં મળી નથી.';
          break;
        case 'mr':
          spoken = '$tName तिथी पुढील दिवसांत सापडली नाही.';
          break;
        case 'bho':
          spoken = '$tName तिथि आगे के दिनन में ना मिलल।';
          break;
        default:
          spoken = 'Could not find the upcoming date for $tName.';
      }
      return VoiceResponse(
        spokenText: spoken,
        displayText: spoken,
        intent: QueryIntentType.tithiSearch,
      );
    }

    final d = res.date;
    final p = res.panchang;
    final mName = _localizedMonthName(d.month, lang);
    final vName = _localizedWeekdayName(d, lang);
    final tithiName = AppLocalizations.getTithiName(p.tithiNumber, lang);
    final lunarMonth = AppLocalizations.getLunarMonthName(p.lunarMonthName, lang);
    final paksha = AppLocalizations.getPakshaName(p.paksha, lang);
    final nakName = AppLocalizations.getNakshatraName(p.nakshatraName, lang);
    final endTime = _formatTime(p.tithiEndTime);

    final festList = res.festivals
        .map((f) => AppLocalizations.localizeFestivalName(f, lang))
        .toList();
    final festSpoken = festList.isNotEmpty ? ' (मुख्य पर्व: ${festList.join(", ")})' : '';
    final festDisplay = festList.isNotEmpty ? '\nपर्व / उत्सव: ${festList.join(", ")}' : '';

    String spoken;
    String dayLabel;

    if (res.isToday) {
      dayLabel = (lang == 'hi') ? 'आज ही' : (lang == 'gu' ? 'આજે જ' : 'Today itself');
      switch (lang) {
        case 'hi':
          spoken = 'आज ही $tName है! आज $lunarMonth मास के $paksha की $tithiName तिथि है, जो $endTime तक रहेगी$festSpoken।';
          break;
        case 'gu':
          spoken = 'આજે જ $tName છે! આજે $lunarMonth માસના $paksha ની $tithiName તિથિ છે, જે $endTime સુધી રહેશે$festSpoken.';
          break;
        case 'mr':
          spoken = 'आजच $tName आहे! आज $lunarMonth महिन्यातील $paksha ची $tithiName तिथी आहे, जी $endTime पर्यंत राहील$festSpoken.';
          break;
        case 'bho':
          spoken = 'आजुवे $tName बा! आजु $lunarMonth महीना के $paksha के $tithiName तिथि बा$festSpoken।';
          break;
        default:
          spoken = 'Today itself is $tName! It is $lunarMonth $paksha $tithiName until $endTime$festSpoken.';
      }
    } else if (res.isTomorrow) {
      dayLabel = (lang == 'hi') ? 'कल (Tomorrow)' : (lang == 'gu' ? 'કાલે' : 'Tomorrow');
      switch (lang) {
        case 'hi':
          spoken = 'अगली $tName कल, ${d.day} $mName ${d.year}, $vName को है। यह $lunarMonth मास के $paksha की $tithiName तिथि है$festSpoken।';
          break;
        case 'gu':
          spoken = 'આગામી $tName કાલે, ${d.day} $mName ${d.year}, $vNameના દિવસે છે. આ $lunarMonth માસના $paksha ની $tithiName તિથિ છે$festSpoken.';
          break;
        case 'mr':
          spoken = 'पुढील $tName उद्या, ${d.day} $mName ${d.year}, $vName रोजी आहे. ही $lunarMonth महिन्यातील $paksha ची $tithiName तिथी आहे$festSpoken.';
          break;
        case 'bho':
          spoken = 'अगिला $tName काल्हि, ${d.day} $mName ${d.year}, $vName के बा। ई $lunarMonth महीना के $paksha के $tithiName तिथि बा$festSpoken।';
          break;
        default:
          spoken = 'Next $tName is tomorrow, ${d.day} $mName ${d.year}, $vName. It falls on $lunarMonth $paksha $tithiName$festSpoken.';
      }
    } else {
      dayLabel = '${d.day} $mName ${d.year} ($vName)';
      switch (lang) {
        case 'hi':
          spoken = 'अगली $tName ${d.day} $mName ${d.year}, $vName को है। यह $lunarMonth मास के $paksha की $tithiName तिथि है$festSpoken।';
          break;
        case 'gu':
          spoken = 'આગામી $tName ${d.day} $mName ${d.year}, $vNameના દિવસે છે. આ $lunarMonth માસના $paksha ની $tithiName તિથિ છે$festSpoken.';
          break;
        case 'mr':
          spoken = 'पुढील $tName ${d.day} $mName ${d.year}, $vName रोजी आहे. ही $lunarMonth महिन्यातील $paksha ची $tithiName तिथी आहे$festSpoken.';
          break;
        case 'bho':
          spoken = 'अगिला $tName ${d.day} $mName ${d.year}, $vName के बा। ई $lunarMonth महीना के $paksha के $tithiName तिथि बा$festSpoken।';
          break;
        default:
          spoken = 'Next $tName is on ${d.day} $mName ${d.year}, $vName. It falls on $lunarMonth $paksha $tithiName$festSpoken.';
      }
    }

    final display = '🪔 $tName\nदिनांक: ${d.day} $mName ${d.year} ($vName) • $dayLabel\nमास: $lunarMonth ($paksha)\nतिथि: $tithiName (समाप्ति: $endTime तक)\nनक्षत्र: $nakName$festDisplay';

    return VoiceResponse(
      spokenText: spoken,
      displayText: display,
      intent: QueryIntentType.tithiSearch,
      structuredData: res,
    );
  }

  static VoiceResponse _formatNakshatraResponse(PanchangDay p, String lang) {
    final nakName = AppLocalizations.getNakshatraName(p.nakshatraName, lang);
    final endTime = _formatTime(p.nakshatraEndTime);

    String spoken;
    switch (lang) {
      case 'hi':
        spoken = 'आज $nakName नक्षत्र है, जो $endTime तक रहेगा।';
        break;
      case 'gu':
        spoken = 'આજે $nakName નક્ષત્ર છે, જે $endTime સુધી રહેશે.';
        break;
      default:
        spoken = 'Today\'s Nakshatra is $nakName, active until $endTime.';
    }

    final display = '✨ नक्षत्र: $nakName\nसमाप्ति समय: $endTime\nवार: ${AppLocalizations.getVaraName(p.localDate.weekday, lang)}';

    return VoiceResponse(
      spokenText: spoken,
      displayText: display,
      intent: QueryIntentType.nakshatraQuery,
      structuredData: p,
    );
  }

  static VoiceResponse _formatChoghadiyaResponse(PanchangDay p, String lang) {
    final now = DateTime.now();
    final periods = now.isBefore(p.astronomicalSunset) ? p.dayChoghadiya : p.nightChoghadiya;

    ChoghadiyaPeriod? currentPeriod;
    for (final period in periods) {
      if (now.isAfter(period.start) && now.isBefore(period.end)) {
        currentPeriod = period;
        break;
      }
    }
    currentPeriod ??= periods.first;

    final name = AppLocalizations.getChoghadiyaName(currentPeriod.name, lang);
    final isAuspicious = currentPeriod.isAuspicious;
    final status = isAuspicious ? AppLocalizations.tr('auspicious', lang) : AppLocalizations.tr('inauspicious', lang);
    final start = _formatTime(currentPeriod.start);
    final end = _formatTime(currentPeriod.end);

    String spoken;
    switch (lang) {
      case 'hi':
        spoken = 'इस समय "$name" ($status) चौघड़िया चल रहा है, जो $start से $end तक है।';
        break;
      case 'gu':
        spoken = 'હાલમાં "$name" ($status) ચોઘડિયું ચાલી રહ્યું છે, જે $start થી $end સુધી છે.';
        break;
      default:
        spoken = 'Currently, "$name" ($status) Choghadiya is active from $start to $end.';
    }

    final display = '⏳ वर्तमान चौघड़िया: $name ($status)\nसमय: $start – $end\nदिन/रात: ${now.isBefore(p.astronomicalSunset) ? "दिन" : "रात"}';

    return VoiceResponse(
      spokenText: spoken,
      displayText: display,
      intent: QueryIntentType.choghadiyaQuery,
      structuredData: p,
    );
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}
