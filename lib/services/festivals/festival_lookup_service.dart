import '../../core/constants/panchang_constants.dart';
import '../../domain/models/location_info.dart';
import '../../domain/models/panchang_day.dart';
import '../panchang/panchang_service.dart';

class FestivalDefinition {
  final String key;
  final String canonicalPattern;
  final Map<String, String> names; // 'en', 'hi', 'gu', 'mr', 'bho'
  final List<String> aliases;

  const FestivalDefinition({
    required this.key,
    required this.canonicalPattern,
    required this.names,
    required this.aliases,
  });
}

class FestivalDateResult {
  final FestivalDefinition festival;
  final DateTime date;
  final PanchangDay panchang;

  const FestivalDateResult({
    required this.festival,
    required this.date,
    required this.panchang,
  });

  String getLocalizedName(String lang) {
    return festival.names[lang] ?? festival.names['hi'] ?? festival.names['en']!;
  }
}

class FestivalVerificationResult {
  final FestivalDefinition festival;
  final DateTime targetDate;
  final bool isFestivalOnTargetDate;
  final PanchangDay targetDatePanchang;
  final FestivalDateResult? actualFestivalDate;

  const FestivalVerificationResult({
    required this.festival,
    required this.targetDate,
    required this.isFestivalOnTargetDate,
    required this.targetDatePanchang,
    this.actualFestivalDate,
  });
}

class FestivalLookupService {
  static const List<FestivalDefinition> allFestivals = [
    FestivalDefinition(
      key: 'dussehra',
      canonicalPattern: 'Vijayadashami / Dussehra',
      names: {
        'en': 'Vijayadashami / Dussehra',
        'hi': 'विजयादशमी (दशहरा)',
        'gu': 'વિજયાદશમી (દશેરા)',
        'mr': 'विजयादशमी (दसरा)',
        'bho': 'विजयादशमी (दशहरा)',
      },
      aliases: [
        'vijayadashami', 'vijyadashmi', 'vijayadashmi', 'vijaya dashami',
        'dussehra', 'dushera', 'dasara', 'dussehra', 'dashahara',
        'दशहरा', 'दसरा', 'विजयादशमी', 'વિજયાદશમી', 'દશેરા',
      ],
    ),
    FestivalDefinition(
      key: 'diwali',
      canonicalPattern: 'Diwali / Lakshmi Puja',
      names: {
        'en': 'Diwali / Lakshmi Puja',
        'hi': 'दीपावली / लक्ष्मी पूजन',
        'gu': 'દિવાળી / લક્ષ્મી પૂજન',
        'mr': 'दिवाळी / लक्ष्मी पूजन',
        'bho': 'दीपावली (दिवाली)',
      },
      aliases: [
        'diwali', 'deepawali', 'deepavali', 'dinvalli',
        'दिवाली', 'दीपावली', 'દીવાળી', 'દિવાળી',
      ],
    ),
    FestivalDefinition(
      key: 'dhanteras',
      canonicalPattern: 'Dhanteras',
      names: {
        'en': 'Dhanteras / Dhanvantari Jayanti',
        'hi': 'धनतेरस (धनवंतरी जयंती)',
        'gu': 'ધનતેરસ',
        'mr': 'धनत्रयोदशी / धनतेरस',
        'bho': 'धनतेरस',
      },
      aliases: [
        'dhanteras', 'dhantrayodashi', 'dhan teras',
        'धनतेरस', 'धनत्रयोदशी', 'ધનતેરસ',
      ],
    ),
    FestivalDefinition(
      key: 'choti_diwali',
      canonicalPattern: 'Naraka Chaturdashi / Choti Diwali',
      names: {
        'en': 'Choti Diwali / Naraka Chaturdashi',
        'hi': 'छोटी दिवाली / नरक चतुर्दशी',
        'gu': 'કાળી ચૌદશ / નાની દિવાળી',
        'mr': 'नरक चतुर्दशी',
        'bho': 'छोटी दिवाली',
      },
      aliases: [
        'choti diwali', 'naraka chaturdashi', 'roop chaudas', 'kali chaudas',
        'छोटी दिवाली', 'नरक चतुर्दशी', 'કાળી ચૌદશ',
      ],
    ),
    FestivalDefinition(
      key: 'govardhan',
      canonicalPattern: 'Govardhan Puja',
      names: {
        'en': 'Govardhan Puja / Annakut',
        'hi': 'गोवर्धन पूजा / अन्नकूट',
        'gu': 'ગોવર્ધન પૂજા / અન્નકૂટ',
        'mr': 'गोवर्धन पूजा / अन्नकूट',
        'bho': 'गोवर्धन पूजा',
      },
      aliases: [
        'govardhan', 'govardhan puja', 'annakut', 'annakoot',
        'गोवर्धन पूजा', 'अन्नकूट', 'ગોવર્ધન પૂજા', 'અન્નકૂટ',
      ],
    ),
    FestivalDefinition(
      key: 'bhai_dooj',
      canonicalPattern: 'Bhai Dooj',
      names: {
        'en': 'Bhai Dooj / Yama Dvitiya',
        'hi': 'भाई दूज (यम द्वितीया)',
        'gu': 'ભાઈ બીજ',
        'mr': 'भाऊबीज',
        'bho': 'भाई दूज',
      },
      aliases: [
        'bhai dooj', 'bhau beej', 'bhai beej', 'bhaiya dooj',
        'भाई दूज', 'भाईदूज', 'ભાઈ બીજ', 'भाऊबीज',
      ],
    ),
    FestivalDefinition(
      key: 'chhath',
      canonicalPattern: 'Chhath Puja',
      names: {
        'en': 'Chhath Puja',
        'hi': 'छठ पूजा',
        'gu': 'છઠ પૂજા',
        'mr': 'छठ पूजा',
        'bho': 'छठ पूजा (डाला छठ)',
      },
      aliases: [
        'chhath', 'chath', 'chhath puja', 'chath puja', 'dala chhath', 'surya shashthi',
        'छठ', 'छठ पूजा', 'डाला छठ', 'છઠ પૂજા',
      ],
    ),
    FestivalDefinition(
      key: 'karwa_chauth',
      canonicalPattern: 'Karwa Chauth',
      names: {
        'en': 'Karwa Chauth',
        'hi': 'करवा चौथ',
        'gu': 'કરવા ચોથ',
        'mr': 'करवा चौथ',
        'bho': 'करवा चौथ',
      },
      aliases: [
        'karwa chauth', 'karva chauth', 'karvachauth', 'karwachauth',
        'करवा चौथ', 'करवाचौथ', 'કરવા ચોથ',
      ],
    ),
    FestivalDefinition(
      key: 'sharad_purnima',
      canonicalPattern: 'Sharad Purnima',
      names: {
        'en': 'Sharad Purnima / Kojagiri',
        'hi': 'शरद पूर्णिमा / कोजागिरी',
        'gu': 'શરદ પૂર્ણિમા',
        'mr': 'कोजागिरी पौर्णिमा',
        'bho': 'शरद पूर्णिमा',
      },
      aliases: [
        'sharad purnima', 'kojagiri', 'kojagari', 'ras purnima',
        'शरद पूर्णिमा', 'कोजागिरी', 'શરદ પૂર્ણિમા',
      ],
    ),
    FestivalDefinition(
      key: 'durga_ashtami',
      canonicalPattern: 'Durga Ashtami',
      names: {
        'en': 'Durga Ashtami / Maha Ashtami',
        'hi': 'दुर्गा अष्टमी / महाअष्टमी',
        'gu': 'દુર્ગા અષ્ટમી',
        'mr': 'दुर्गाष्टमी',
        'bho': 'दुर्गा अष्टमी',
      },
      aliases: [
        'durga ashtami', 'durgashtami', 'maha ashtami', 'mahaashtami',
        'दुर्गा अष्टमी', 'दुर्गाष्टमी', 'महाष्टमी', 'દુર્ગા અષ્ટમી',
        'ashtami', 'अष्टमी', 'અષ્ટમી',
      ],
    ),
    FestivalDefinition(
      key: 'maha_navami',
      canonicalPattern: 'Maha Navami',
      names: {
        'en': 'Maha Navami',
        'hi': 'महानवमी (नवमी)',
        'gu': 'મહા નવમી (નોમ)',
        'mr': 'महानवमी',
        'bho': 'महानवमी',
      },
      aliases: [
        'maha navami', 'mahanavami',
        'महानवमी', 'महा नवमी', 'મહા નવમી',
        'navami', 'navmi', 'nom', 'नवमी', 'नोम', 'નવમી',
      ],
    ),
    FestivalDefinition(
      key: 'navratri',
      canonicalPattern: 'Navratri',
      names: {
        'en': 'Sharad Navratri (Begins)',
        'hi': 'शारदीय नवरात्रि (प्रारम्भ)',
        'gu': 'નવરાત્રી (શરૂઆત)',
        'mr': 'नवरात्र प्रारंभ',
        'bho': 'नवरात्रि (शुरू)',
      },
      aliases: [
        'navratri', 'navratra', 'navaratri', 'sharad navratri',
        'नवरात्रि', 'नवरात्र', 'નવરાત્રી', 'नवरात्रोत्सव',
      ],
    ),
    FestivalDefinition(
      key: 'ganesh_chaturthi',
      canonicalPattern: 'Ganesh Chaturthi',
      names: {
        'en': 'Ganesh Chaturthi',
        'hi': 'गणेश चतुर्थी (विनायक चतुर्थी)',
        'gu': 'ગણેશ ચતુર્થી',
        'mr': 'गणेश चतुर्थी',
        'bho': 'गणेश चतुर्थी',
      },
      aliases: [
        'ganesh chaturthi', 'ganpati', 'vinayaka chaturthi', 'ganesh utsav',
        'गणेश चतुर्थी', 'गणपति', 'विनायक चतुर्थी', 'ગણેશ ચતુર્થી', 'ગણપતિ',
      ],
    ),
    FestivalDefinition(
      key: 'janmashtami',
      canonicalPattern: 'Krishna Janmashtami',
      names: {
        'en': 'Krishna Janmashtami',
        'hi': 'श्रीकृष्ण जन्माष्टमी',
        'gu': 'શ્રીકૃષ્ણ જન્માષ્ટમી',
        'mr': 'गोकुळाष्टमी / श्रीकृष्ण जन्माष्टमी',
        'bho': 'कृष्ण जन्माष्टमी',
      },
      aliases: [
        'janmashtami', 'krishna janmashtami', 'gokulashtami', 'janmastami',
        'जन्माष्टमी', 'गोकुलाष्टमी', 'જન્માષ્ટમી', 'काहा अष्टमी',
      ],
    ),
    FestivalDefinition(
      key: 'raksha_bandhan',
      canonicalPattern: 'Raksha Bandhan',
      names: {
        'en': 'Raksha Bandhan',
        'hi': 'रक्षाबंधन',
        'gu': 'રક્ષાબંધન (રાખી)',
        'mr': 'रक्षाबंधन / नारळी पौर्णिमा',
        'bho': 'रक्षाबंधन (राखी)',
      },
      aliases: [
        'raksha bandhan', 'rakshabandhan', 'rakhi',
        'रक्षाबंधन', 'रक्षा बंधन', 'राखी', 'રક્ષાબંધન',
      ],
    ),
    FestivalDefinition(
      key: 'holi',
      canonicalPattern: 'Holi / Dhulandi',
      names: {
        'en': 'Holi (Rangwali Holi)',
        'hi': 'होली (धुलेंडी / रंगवाली होली)',
        'gu': 'હોળી / ધુળેટી',
        'mr': 'धूलिवंदन / होळी',
        'bho': 'होली (फगुआ)',
      },
      aliases: [
        'holi', 'dhulandi', 'dhulendi', 'dhuleti', 'phagua',
        'होली', 'धुलेंडी', 'धुलण्डी', 'હોળી', 'ધુળેટી', 'फगुआ',
      ],
    ),
    FestivalDefinition(
      key: 'holika_dahan',
      canonicalPattern: 'Holika Dahan',
      names: {
        'en': 'Holika Dahan / Choti Holi',
        'hi': 'होलिका दहन (छोटी होली)',
        'gu': 'હોલિકા દહન',
        'mr': 'होलिका दहन',
        'bho': 'होलिका दहन',
      },
      aliases: [
        'holika dahan', 'holikadahan', 'choti holi',
        'होलिका दहन', 'होलिका', 'छोटी होली',
      ],
    ),
    FestivalDefinition(
      key: 'shivratri',
      canonicalPattern: 'Maha Shivaratri',
      names: {
        'en': 'Maha Shivaratri',
        'hi': 'महाशिवरात्रि',
        'gu': 'મહા શિવરાત્રી',
        'mr': 'महाशिवरात्री',
        'bho': 'महाशिवरात्रि',
      },
      aliases: [
        'shivaratri', 'shivratri', 'maha shivaratri', 'mahashivratri',
        'शिवरात्रि', 'महाशिवरात्रि', 'મહા શિવરાત્રી',
      ],
    ),
    FestivalDefinition(
      key: 'makar_sankranti',
      canonicalPattern: 'Makar Sankranti',
      names: {
        'en': 'Makar Sankranti / Pongal',
        'hi': 'मकर संक्रांति',
        'gu': 'મકર સંક્રાંતિ (ઉત્તરાયણ)',
        'mr': 'मकर संक्रांत',
        'bho': 'मकर संक्रांति (खिचड़ी)',
      },
      aliases: [
        'makar sankranti', 'sankranti', 'uttarayan', 'pongal', 'khichdi',
        'मकर संक्रांति', 'संक्रांति', 'ઉત્તરાયણ', 'ખિચડી', 'खिचड़ी',
      ],
    ),
    FestivalDefinition(
      key: 'ram_navami',
      canonicalPattern: 'Rama Navami',
      names: {
        'en': 'Rama Navami',
        'hi': 'श्री राम नवमी',
        'gu': 'રામ નવમી',
        'mr': 'श्रीराम नवमी',
        'bho': 'राम नवमी',
      },
      aliases: [
        'ram navami', 'rama navami', 'ramnavami',
        'राम नवमी', 'रामनवमी', 'શ્રી રામ નવમી',
      ],
    ),
    FestivalDefinition(
      key: 'hanuman_jayanti',
      canonicalPattern: 'Hanuman Jayanti',
      names: {
        'en': 'Hanuman Jayanti',
        'hi': 'हनुमान जयंती',
        'gu': 'હનુમાન જયંતિ',
        'mr': 'हनुमान जयंती',
        'bho': 'हनुमान जयंती',
      },
      aliases: [
        'hanuman jayanti', 'hanumanjayanti',
        'हनुमान जयंती', 'હનુમાન જયંતિ',
      ],
    ),
    FestivalDefinition(
      key: 'akshaya_tritiya',
      canonicalPattern: 'Akshaya Tritiya',
      names: {
        'en': 'Akshaya Tritiya (Akha Teej)',
        'hi': 'अक्षय तृतीया (आखा तीज)',
        'gu': 'અક્ષય તૃતીયા (અખા ત્રીજ)',
        'mr': 'अक्षय्य तृतीया',
        'bho': 'अक्षय तृतीया',
      },
      aliases: [
        'akshaya tritiya', 'akha teej', 'akshatritiya',
        'अक्षय तृतीया', 'आखा तीज', 'અક્ષય તૃતીયા', 'અખા ત્રીજ',
      ],
    ),
    FestivalDefinition(
      key: 'guru_purnima',
      canonicalPattern: 'Guru Purnima',
      names: {
        'en': 'Guru Purnima / Vyasa Purnima',
        'hi': 'गुरु पूर्णिमा (व्यास पूर्णिमा)',
        'gu': 'ગુરુ પૂર્ણિમા',
        'mr': 'गुरु पौर्णिमा',
        'bho': 'गुरु पूर्णिमा',
      },
      aliases: [
        'guru purnima', 'gurupurnima', 'vyas purnima',
        'गुरु पूर्णिमा', 'गुरुपूर्णिमा', 'ગુરુ પૂર્ણિમા',
      ],
    ),
    FestivalDefinition(
      key: 'vasant_panchami',
      canonicalPattern: 'Vasant Panchami',
      names: {
        'en': 'Vasant Panchami / Saraswati Puja',
        'hi': 'बसंत पंचमी (सरस्वती पूजा)',
        'gu': 'વસંત પંચમી',
        'mr': 'वसंत पंचमी',
        'bho': 'बसंत पंचमी',
      },
      aliases: [
        'vasant panchami', 'basant panchami', 'saraswati puja',
        'बसंत पंचमी', 'वसंत पंचमी', 'सरस्वती पूजा', 'વસંત પંચમી',
      ],
    ),
  ];

  /// Detects if a festival is mentioned in the query text
  static FestivalDefinition? detectFestival(String query) {
    final q = query.trim().toLowerCase();
    for (final def in allFestivals) {
      for (final alias in def.aliases) {
        if (q.contains(alias.toLowerCase())) {
          return def;
        }
      }
    }
    return null;
  }

  /// Searches up to 365 days forward from [fromDate] (or beginning of current year) to find festival date
  static FestivalDateResult? findFestivalDate({
    required FestivalDefinition festival,
    required LocationInfo location,
    DateTime? fromDate,
    CalendarTradition tradition = CalendarTradition.standardHindu,
  }) {
    final start = fromDate ?? DateTime.now();
    // Search up to 370 days forward
    for (int i = 0; i < 370; i++) {
      final d = start.add(Duration(days: i));
      final p = PanchangService.calculatePanchang(
        date: d,
        location: location,
        tradition: tradition,
      );

      final allEvents = [...p.festivals, ...p.vrats];
      for (final ev in allEvents) {
        if (ev.toLowerCase().contains(festival.canonicalPattern.toLowerCase()) ||
            festival.aliases.any((a) => ev.toLowerCase().contains(a.toLowerCase()))) {
          return FestivalDateResult(
            festival: festival,
            date: d,
            panchang: p,
          );
        }
      }
    }

    // Also search backward to start of year if query occurred late in year
    final startOfYear = DateTime(start.year, 1, 1);
    final daysSinceStart = start.difference(startOfYear).inDays;
    for (int i = 0; i < daysSinceStart; i++) {
      final d = startOfYear.add(Duration(days: i));
      final p = PanchangService.calculatePanchang(
        date: d,
        location: location,
        tradition: tradition,
      );

      final allEvents = [...p.festivals, ...p.vrats];
      for (final ev in allEvents) {
        if (ev.toLowerCase().contains(festival.canonicalPattern.toLowerCase()) ||
            festival.aliases.any((a) => ev.toLowerCase().contains(a.toLowerCase()))) {
          return FestivalDateResult(
            festival: festival,
            date: d,
            panchang: p,
          );
        }
      }
    }

    return null;
  }

  /// Verifies if a festival falls on a specific date, and if not, finds when it actually is
  static FestivalVerificationResult verifyFestivalOnDate({
    required FestivalDefinition festival,
    required DateTime targetDate,
    required LocationInfo location,
    CalendarTradition tradition = CalendarTradition.standardHindu,
  }) {
    final p = PanchangService.calculatePanchang(
      date: targetDate,
      location: location,
      tradition: tradition,
    );

    final allEvents = [...p.festivals, ...p.vrats];
    bool isOnDate = false;
    for (final ev in allEvents) {
      if (ev.toLowerCase().contains(festival.canonicalPattern.toLowerCase()) ||
          festival.aliases.any((a) => ev.toLowerCase().contains(a.toLowerCase()))) {
        isOnDate = true;
        break;
      }
    }

    FestivalDateResult? actualDate;
    if (!isOnDate) {
      // Find where it actually is around targetDate (start searching 30 days before targetDate)
      final searchFrom = targetDate.subtract(const Duration(days: 30));
      actualDate = findFestivalDate(
        festival: festival,
        location: location,
        fromDate: searchFrom,
        tradition: tradition,
      );
    }

    return FestivalVerificationResult(
      festival: festival,
      targetDate: targetDate,
      isFestivalOnTargetDate: isOnDate,
      targetDatePanchang: p,
      actualFestivalDate: actualDate,
    );
  }
}
