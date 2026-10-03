import '../../core/constants/panchang_constants.dart';
import '../../domain/models/location_info.dart';
import '../../domain/models/muhurat_window.dart';
import '../../domain/models/panchang_day.dart';
import '../ekadashi/ekadashi_service.dart';
import '../muhurat/muhurat_service.dart';
import '../nlp/nlp_query_parser.dart';
import '../panchang/panchang_service.dart';

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

  static String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}
