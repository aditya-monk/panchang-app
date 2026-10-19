import '../../core/constants/panchang_constants.dart';
import '../../data/festivals_data.dart';
import '../../domain/models/location_info.dart';
import '../../domain/models/panchang_day.dart';
import '../panchang/panchang_service.dart';

class TithiTarget {
  final int tithiBase; // 1 to 15, or 30 for Amavasya
  final String canonicalName;
  final Map<String, String> names; // 'en', 'hi', 'gu', 'mr', 'bho'
  final List<String> aliases;

  const TithiTarget({
    required this.tithiBase,
    required this.canonicalName,
    required this.names,
    required this.aliases,
  });
}

class TithiSearchResult {
  final TithiTarget target;
  final DateTime date;
  final PanchangDay panchang;
  final bool isToday;
  final bool isTomorrow;
  final List<String> festivals;

  const TithiSearchResult({
    required this.target,
    required this.date,
    required this.panchang,
    required this.isToday,
    required this.isTomorrow,
    required this.festivals,
  });
}

class TithiSearchService {
  static const List<TithiTarget> allTithis = [
    TithiTarget(
      tithiBase: 1,
      canonicalName: 'Pratipada',
      names: {
        'en': 'Pratipada',
        'hi': 'प्रतिपदा (पड़वा)',
        'gu': 'પડવો (પ્રતિપદા)',
        'mr': 'प्रतिपदा (पाडवा)',
        'bho': 'पड़वा (प्रतिपदा)',
      },
      aliases: ['pratipada', 'prathama', 'padwa', 'padvo', 'padva', 'प्रतिपदा', 'पड़वा', 'पडવો', 'पाडवा'],
    ),
    TithiTarget(
      tithiBase: 2,
      canonicalName: 'Dvitiya',
      names: {
        'en': 'Dvitiya',
        'hi': 'द्वितीया (दूज)',
        'gu': 'બીજ (દ્વિતીયા)',
        'mr': 'द्वितीया (बीज)',
        'bho': 'दूज (द्वितीया)',
      },
      aliases: ['dvitiya', 'dutiya', 'dooj', 'duj', 'beej', 'द्वितीया', 'दूज', 'બીજ'],
    ),
    TithiTarget(
      tithiBase: 3,
      canonicalName: 'Tritiya',
      names: {
        'en': 'Tritiya',
        'hi': 'तृतीया (तीज)',
        'gu': 'ત્રીજ (તૃતીયા)',
        'mr': 'तृतीया',
        'bho': 'तीज (तृतीया)',
      },
      aliases: ['tritiya', 'teej', 'trij', 'तृतीया', 'तीज', 'ત્રીજ'],
    ),
    TithiTarget(
      tithiBase: 4,
      canonicalName: 'Chaturthi',
      names: {
        'en': 'Chaturthi',
        'hi': 'चतुर्थी (चौथ)',
        'gu': 'ચોથ (ચતુર્થી)',
        'mr': 'चतुर्थी (चौथ)',
        'bho': 'चौथ (चतुर्थी)',
      },
      aliases: ['chaturthi', 'chauth', 'chouth', 'choth', 'chovth', 'चतुर्थी', 'चौथ', 'ચોથ'],
    ),
    TithiTarget(
      tithiBase: 5,
      canonicalName: 'Panchami',
      names: {
        'en': 'Panchami',
        'hi': 'पंचमी',
        'gu': 'પાંચમ (પંચમી)',
        'mr': 'पंचमी',
        'bho': 'पंचमी',
      },
      aliases: ['panchami', 'pancham', 'पंचमी', 'પાંચમ'],
    ),
    TithiTarget(
      tithiBase: 6,
      canonicalName: 'Shashthi',
      names: {
        'en': 'Shashthi',
        'hi': 'षष्ठी (छठ)',
        'gu': 'છઠ (ષષ્ઠી)',
        'mr': 'षष्ठी',
        'bho': 'छठ (षष्ठी)',
      },
      aliases: ['shashthi', 'shashti', 'chhath', 'chhat', 'षष्ठी', 'छठ', 'છઠ'],
    ),
    TithiTarget(
      tithiBase: 7,
      canonicalName: 'Saptami',
      names: {
        'en': 'Saptami',
        'hi': 'सप्तमी (सातम)',
        'gu': 'સાતમ (સપ્તમી)',
        'mr': 'सप्तमी',
        'bho': 'सप्तमी',
      },
      aliases: ['saptami', 'satam', 'सप्तमी', 'सातम'],
    ),
    TithiTarget(
      tithiBase: 8,
      canonicalName: 'Ashtami',
      names: {
        'en': 'Ashtami',
        'hi': 'अष्टमी (आठम / महाअष्टमी)',
        'gu': 'આઠમ (અષ્ટમી)',
        'mr': 'अष्टमी',
        'bho': 'अष्टमी (आठम)',
      },
      aliases: ['ashtami', 'aatham', 'aathve', 'अष्टमी', 'आठम', 'અષ્ટમી', 'આઠમ', 'दुर्गा अष्टमी', 'महाअष्टमी'],
    ),
    TithiTarget(
      tithiBase: 9,
      canonicalName: 'Navami',
      names: {
        'en': 'Navami',
        'hi': 'नवमी (महानवमी)',
        'gu': 'નોમ (નવમી / મહાનવમી)',
        'mr': 'नवमी (महानवमी)',
        'bho': 'नवमी (महानवमी)',
      },
      aliases: ['navami', 'navmi', 'nom', 'naumi', 'नवमी', 'नोम', 'નવમી', 'महानवमी', 'महा नवमी'],
    ),
    TithiTarget(
      tithiBase: 10,
      canonicalName: 'Dashami',
      names: {
        'en': 'Dashami',
        'hi': 'दशमी (विजयादशमी)',
        'gu': 'દસમ (દશમી / વિજયાદશમી)',
        'mr': 'दशमी (विजयादशमी)',
        'bho': 'दशमी',
      },
      aliases: ['dashami', 'dasam', 'dussehra', 'दशमी', 'दसम', 'દશમી', 'દસમ'],
    ),
    TithiTarget(
      tithiBase: 11,
      canonicalName: 'Ekadashi',
      names: {
        'en': 'Ekadashi',
        'hi': 'एकादशी (ग्यारस)',
        'gu': 'એકાદશી (અગિયારસ)',
        'mr': 'एकादशी',
        'bho': 'एकादशी (ग्यारस)',
      },
      aliases: ['ekadashi', 'gyaras', 'agyaras', 'agiyaras', 'एकादशी', 'ग्यारस', 'એકાદશી', 'અગિયારસ'],
    ),
    TithiTarget(
      tithiBase: 12,
      canonicalName: 'Dvadashi',
      names: {
        'en': 'Dvadashi',
        'hi': 'द्वादशी (बारस)',
        'gu': 'બારસ (દ્વાદશી)',
        'mr': 'द्वादशी (बारस)',
        'bho': 'द्वादशी (बारस)',
      },
      aliases: ['dvadashi', 'dwadashi', 'baras', 'द्वादशी', 'बारस', 'બારસ'],
    ),
    TithiTarget(
      tithiBase: 13,
      canonicalName: 'Trayodashi',
      names: {
        'en': 'Trayodashi',
        'hi': 'त्रयोदशी (तेरस / धनतेरस)',
        'gu': 'તેરસ (ત્રયોદશી / ધનતેરસ)',
        'mr': 'त्रयोदशी (तेरस)',
        'bho': 'त्रयोदशी (तेरस)',
      },
      aliases: ['trayodashi', 'teras', 'तेरस', 'त्रयोदशी', 'તેરસ', 'धनतेरस'],
    ),
    TithiTarget(
      tithiBase: 14,
      canonicalName: 'Chaturdashi',
      names: {
        'en': 'Chaturdashi',
        'hi': 'चतुर्दशी (चौदस)',
        'gu': 'ચૌદશ (ચતુર્દશી)',
        'mr': 'चतुर्दशी (चौदस)',
        'bho': 'चतुर्दशी (चौदस)',
      },
      aliases: ['chaturdashi', 'chaudas', 'choudas', 'चतुर्दशी', 'चौदस', 'ચૌદશ'],
    ),
    TithiTarget(
      tithiBase: 15,
      canonicalName: 'Purnima',
      names: {
        'en': 'Purnima (Full Moon)',
        'hi': 'पूर्णिमा (पूनम)',
        'gu': 'પૂનમ (પૂર્ણિમા)',
        'mr': 'पौर्णिमा',
        'bho': 'पूरनमासी (पूर्णिमा)',
      },
      aliases: ['purnima', 'poornima', 'poonam', 'punam', 'full moon', 'पूर्णिमा', 'पूनम', 'पौर्णिमा', 'पूरनमासी', 'પૂનમ'],
    ),
    TithiTarget(
      tithiBase: 30,
      canonicalName: 'Amavasya',
      names: {
        'en': 'Amavasya (New Moon)',
        'hi': 'अमावस्या (अमावस)',
        'gu': 'અમાસ (અમાવાસ્યા)',
        'mr': 'अमावास्या',
        'bho': 'अमवस्या (अमावस)',
      },
      aliases: ['amavasya', 'amavas', 'amas', 'new moon', 'अमावस्या', 'अमावस', 'अमावास्या', 'અમાસ'],
    ),
  ];

  /// Detects if a query is asking when a specific tithi falls (e.g. "नवमी कब है", "अष्टमी कब है", "when is navami")
  static TithiTarget? detectTithiInquiry(String query) {
    final q = query.trim().toLowerCase();

    // Must contain inquiry indicators (kab, when, date, tarikh, kare, kadhi, etc.)
    final isInquiry = q.contains('kab') ||
        q.contains('when') ||
        q.contains('कब') ||
        q.contains('ક્યારે') ||
        q.contains('कधी') ||
        q.contains('कहिले') ||
        q.contains('कवने') ||
        q.contains('तारीख') ||
        q.contains('tarikh') ||
        q.contains('tareekh') ||
        q.contains('kis din') ||
        q.contains('which day');

    // Also match if query ends with tithi word or starts with "when is"
    final hasWhenStructure = isInquiry ||
        q.startsWith('when is') ||
        q.startsWith('when\'s') ||
        q.contains('hai?') ||
        q.contains('है?') ||
        q.endsWith('hai') ||
        q.endsWith('है') ||
        q.endsWith('बा') ||
        q.endsWith('છે') ||
        q.endsWith('आहे');

    if (!hasWhenStructure) return null;

    // Check longer aliases first to avoid substring conflicts (e.g. "चतुर्दशी" before "चतुर्थी")
    final sortedTithis = List<TithiTarget>.from(allTithis);
    for (final t in sortedTithis) {
      for (final a in t.aliases) {
        // Use word boundary or direct presence
        if (q.contains(a.toLowerCase())) {
          return t;
        }
      }
    }
    return null;
  }

  /// Finds the next occurrence of the specified tithi starting from [fromDate]
  static TithiSearchResult? findNextTithi({
    required TithiTarget target,
    required LocationInfo location,
    DateTime? fromDate,
    CalendarTradition tradition = CalendarTradition.standardHindu,
  }) {
    final now = DateTime.now();
    final start = fromDate ?? DateTime(now.year, now.month, now.day);

    for (int i = 0; i < 35; i++) {
      final current = start.add(Duration(days: i));
      final p = PanchangService.calculatePanchang(
        date: current,
        location: location,
        tradition: tradition,
      );

      bool matches = false;
      if (target.tithiBase == 15) {
        matches = (p.tithiNumber == 15);
      } else if (target.tithiBase == 30) {
        matches = (p.tithiNumber == 30);
      } else {
        // Matches Shukla or Krishna equivalent (e.g. Navami = 9 or 24)
        final shuklaEquiv = target.tithiBase;
        final krishnaEquiv = target.tithiBase + 15;
        matches = (p.tithiNumber == shuklaEquiv || p.tithiNumber == krishnaEquiv);
      }

      if (matches) {
        final isToday = (current.year == now.year && current.month == now.month && current.day == now.day);
        final isTomorrow = (current.year == now.year &&
            current.month == now.month &&
            current.day == now.day + 1);

        final festivals = [...p.festivals, ...p.vrats];

        return TithiSearchResult(
          target: target,
          date: current,
          panchang: p,
          isToday: isToday,
          isTomorrow: isTomorrow,
          festivals: festivals,
        );
      }
    }

    return null;
  }
}
