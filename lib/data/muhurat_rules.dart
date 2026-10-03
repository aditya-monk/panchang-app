import '../core/constants/panchang_constants.dart';

class MuhuratRuleConfig {
  final String id;
  final String title;
  final String icon;
  final String description;
  final List<int> allowedWeekdays; // 0=Sunday, 6=Saturday. Empty means all allowed.
  final List<int> excludedWeekdays;
  final List<int> allowedTithis;    // 1..30. Empty means all non-excluded.
  final List<int> excludedTithis;
  final List<int> allowedNakshatras; // 1..27.
  final List<int> excludedNakshatras;
  final List<String> excludedPeriods; // 'rahu_kaal', 'yamaganda'
  final List<ChoghadiyaType> preferredChoghadiya;
  final bool preferAbhijit;
  final int minimumDurationMinutes;

  const MuhuratRuleConfig({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
    this.allowedWeekdays = const [],
    this.excludedWeekdays = const [],
    this.allowedTithis = const [],
    this.excludedTithis = const [4, 9, 14, 19, 24, 29, 30], // Default avoid Rikta & Amavasya
    this.allowedNakshatras = const [],
    this.excludedNakshatras = const [2, 3, 9, 18, 19], // Bharani, Krittika, Ashlesha, Jyeshtha, Mula by default
    this.excludedPeriods = const ['rahu_kaal', 'yamaganda'],
    this.preferredChoghadiya = const [
      ChoghadiyaType.amrit,
      ChoghadiyaType.shubh,
      ChoghadiyaType.labh,
      ChoghadiyaType.char
    ],
    this.preferAbhijit = true,
    this.minimumDurationMinutes = 45,
  });
}

class MuhuratRuleDatabase {
  static const List<MuhuratRuleConfig> allRules = [
    // 1. Marriage (Vivaha)
    MuhuratRuleConfig(
      id: 'marriage',
      title: 'Marriage',
      icon: '💍',
      description: 'Auspicious union of two souls. Requires Shubha Tithi and auspicious Sthira or Laghu Nakshatra.',
      allowedWeekdays: [1, 3, 4, 5], // Mon, Wed, Thu, Fri
      excludedWeekdays: [2, 6],       // Tue, Sat strictly avoided
      allowedTithis: [2, 3, 5, 7, 10, 11, 12, 13], // Dvitiya, Tritiya, Panchami, Saptami, Dashami, Ekadashi, Dvadashi, Trayodashi
      excludedTithis: [1, 4, 6, 8, 9, 14, 15, 19, 24, 29, 30],
      allowedNakshatras: [4, 5, 10, 12, 13, 14, 15, 17, 21, 22, 26, 27], // Rohini, Mrigashira, Magha, U.Phalguni, Hasta, Chitra, Swati, Anuradha, U.Ashadha, Shravana, U.Bhadrapada, Revati
      preferredChoghadiya: [ChoghadiyaType.amrit, ChoghadiyaType.shubh, ChoghadiyaType.labh],
      minimumDurationMinutes: 60,
    ),

    // 2. Griha Pravesh (House Warming)
    MuhuratRuleConfig(
      id: 'griha_pravesh',
      title: 'Griha Pravesh',
      icon: '🏠',
      description: 'Entering a new home. Avoids Tuesdays, Sundays, Amavasya, and Rikta Tithis.',
      allowedWeekdays: [1, 3, 4, 5], // Mon, Wed, Thu, Fri
      excludedWeekdays: [0, 2],       // Sun, Tue avoided
      allowedTithis: [2, 3, 5, 7, 8, 10, 11, 12, 13, 15],
      excludedTithis: [4, 9, 14, 19, 24, 29, 30],
      allowedNakshatras: [4, 5, 8, 12, 13, 14, 17, 21, 22, 23, 24, 26, 27], // Sthira and Friendly nakshatras
      preferredChoghadiya: [ChoghadiyaType.amrit, ChoghadiyaType.shubh, ChoghadiyaType.labh],
      minimumDurationMinutes: 60,
    ),

    // 3. Vehicle Purchase (Vahan Kharid)
    MuhuratRuleConfig(
      id: 'vehicle_purchase',
      title: 'Vehicle Purchase',
      icon: '🚗',
      description: 'Buying a car, two-wheeler, or commercial transport. Requires Chara (movable) Nakshatras and auspicious Choghadiya.',
      allowedWeekdays: [0, 1, 3, 4, 5], // Sun, Mon, Wed, Thu, Fri
      excludedWeekdays: [2, 6],          // Tue, Sat traditionally avoided for buying metals/vehicles
      allowedTithis: [2, 3, 5, 7, 10, 11, 12, 13, 15],
      allowedNakshatras: [1, 4, 5, 7, 8, 13, 14, 15, 22, 23, 24], // Ashwini, Rohini, Mrigashira, Punarvasu, Pushya, Hasta, Chitra, Swati, Shravana, Dhanishta, Shatabhisha
      preferredChoghadiya: [ChoghadiyaType.shubh, ChoghadiyaType.amrit, ChoghadiyaType.labh, ChoghadiyaType.char],
      minimumDurationMinutes: 30,
    ),

    // 4. Property Purchase (Bhumi / Makaan)
    MuhuratRuleConfig(
      id: 'property_purchase',
      title: 'Property Purchase',
      icon: '🏡',
      description: 'Registry and acquisition of land, flat, or commercial real estate.',
      allowedWeekdays: [1, 3, 4, 5],
      excludedWeekdays: [2],
      allowedTithis: [2, 3, 5, 7, 10, 11, 12, 13, 15],
      allowedNakshatras: [4, 8, 12, 13, 17, 21, 26], // Fixed & Earth Nakshatras
      preferredChoghadiya: [ChoghadiyaType.labh, ChoghadiyaType.amrit, ChoghadiyaType.shubh],
      minimumDurationMinutes: 45,
    ),

    // 5. Business Opening (Vyapar Arambha)
    MuhuratRuleConfig(
      id: 'business_opening',
      title: 'Business Opening',
      icon: '💼',
      description: 'Starting a new enterprise, startup, or partnership. Labh & Amrit Choghadiya are primary.',
      allowedWeekdays: [1, 3, 4, 5],
      allowedTithis: [2, 3, 5, 7, 10, 11, 12, 13, 15],
      allowedNakshatras: [1, 4, 5, 8, 13, 14, 15, 17, 22, 23, 27],
      preferredChoghadiya: [ChoghadiyaType.labh, ChoghadiyaType.amrit, ChoghadiyaType.shubh],
      minimumDurationMinutes: 45,
    ),

    // 6. Office Opening
    MuhuratRuleConfig(
      id: 'office_opening',
      title: 'Office Opening',
      icon: '🏢',
      description: 'Inaugurating a corporate office or workspace.',
      allowedWeekdays: [1, 3, 4, 5],
      allowedTithis: [2, 3, 5, 7, 10, 11, 12, 13, 15],
      allowedNakshatras: [1, 4, 8, 13, 17, 22, 27],
      preferredChoghadiya: [ChoghadiyaType.labh, ChoghadiyaType.amrit, ChoghadiyaType.shubh],
      minimumDurationMinutes: 45,
    ),

    // 7. Shop Opening
    MuhuratRuleConfig(
      id: 'shop_opening',
      title: 'Shop Opening',
      icon: '🛍️',
      description: 'Opening a retail store or commercial counter.',
      allowedWeekdays: [1, 3, 4, 5],
      allowedTithis: [2, 3, 5, 7, 10, 11, 12, 13, 15],
      allowedNakshatras: [1, 8, 13, 14, 15, 22, 27],
      preferredChoghadiya: [ChoghadiyaType.labh, ChoghadiyaType.shubh],
      minimumDurationMinutes: 30,
    ),

    // 8. Bhoomi Pujan
    MuhuratRuleConfig(
      id: 'bhoomi_pujan',
      title: 'Bhoomi Pujan',
      icon: '🌱',
      description: 'Ground breaking ceremony and sanctification of earth before construction.',
      allowedWeekdays: [1, 3, 4, 5],
      excludedWeekdays: [0, 2, 6],
      allowedTithis: [2, 3, 5, 7, 10, 11, 13, 15],
      allowedNakshatras: [4, 8, 12, 13, 17, 21, 26],
      preferredChoghadiya: [ChoghadiyaType.shubh, ChoghadiyaType.amrit],
      minimumDurationMinutes: 45,
    ),

    // 9. Namkaran (Naming Ceremony)
    MuhuratRuleConfig(
      id: 'namkaran',
      title: 'Namkaran',
      icon: '👶',
      description: 'Auspicious naming of newborn on 11th, 12th, or 16th day or auspicious Tithi.',
      allowedWeekdays: [0, 1, 3, 4, 5],
      excludedWeekdays: [2],
      allowedTithis: [1, 2, 3, 5, 7, 10, 11, 12, 13],
      allowedNakshatras: [1, 4, 5, 7, 8, 12, 13, 14, 15, 17, 21, 22, 23, 24, 26, 27],
      preferredChoghadiya: [ChoghadiyaType.amrit, ChoghadiyaType.shubh],
      minimumDurationMinutes: 30,
    ),

    // 10. Mundan (Chaul Sanskar)
    MuhuratRuleConfig(
      id: 'mundan',
      title: 'Mundan (Tonsure)',
      icon: '✂️',
      description: 'First haircut of the child. Performed during Uttarayana in odd years.',
      allowedWeekdays: [1, 3, 4, 5],
      excludedWeekdays: [2, 6, 0],
      allowedTithis: [2, 3, 5, 7, 10, 11, 13],
      allowedNakshatras: [1, 4, 5, 7, 8, 13, 14, 15, 21, 22, 23, 27],
      preferredChoghadiya: [ChoghadiyaType.shubh, ChoghadiyaType.amrit],
      minimumDurationMinutes: 45,
    ),

    // 11. Annaprashan (First Feeding)
    MuhuratRuleConfig(
      id: 'annaprashan',
      title: 'Annaprashan',
      icon: '🍚',
      description: 'First intake of solid food for the infant.',
      allowedWeekdays: [1, 3, 4, 5],
      allowedTithis: [1, 2, 3, 5, 7, 10, 12, 13],
      allowedNakshatras: [1, 4, 5, 7, 8, 13, 14, 15, 22, 23, 26, 27],
      preferredChoghadiya: [ChoghadiyaType.amrit, ChoghadiyaType.shubh],
      minimumDurationMinutes: 30,
    ),

    // 12. Vidyarambh (Education Commencement)
    MuhuratRuleConfig(
      id: 'vidyarambh',
      title: 'Vidyarambh',
      icon: '📚',
      description: 'Initiating learning, reading, or enrollment into educational courses.',
      allowedWeekdays: [1, 3, 4, 5],
      allowedTithis: [2, 3, 5, 7, 10, 11, 12],
      allowedNakshatras: [1, 4, 5, 7, 8, 13, 14, 15, 22, 27],
      preferredChoghadiya: [ChoghadiyaType.shubh, ChoghadiyaType.amrit, ChoghadiyaType.labh],
      minimumDurationMinutes: 30,
    ),

    // 13. Upanayan (Janeu Sanskar)
    MuhuratRuleConfig(
      id: 'upanayan',
      title: 'Upanayan',
      icon: '📿',
      description: 'Sacred thread investiture ceremony.',
      allowedWeekdays: [1, 3, 4, 5],
      excludedWeekdays: [2, 6],
      allowedTithis: [2, 3, 5, 7, 10, 11, 12, 13],
      allowedNakshatras: [4, 5, 7, 8, 12, 13, 14, 15, 17, 21, 22, 26, 27],
      preferredChoghadiya: [ChoghadiyaType.shubh, ChoghadiyaType.amrit],
      minimumDurationMinutes: 60,
    ),

    // 14. Karnavedha (Ear Piercing)
    MuhuratRuleConfig(
      id: 'karnavedha',
      title: 'Karnavedha',
      icon: '✨',
      description: 'Traditional ear-piercing ceremony for health and spiritual well-being.',
      allowedWeekdays: [1, 3, 4, 5],
      allowedTithis: [1, 2, 3, 5, 7, 10, 11, 12, 13],
      allowedNakshatras: [1, 4, 5, 7, 8, 13, 14, 22, 23, 27],
      preferredChoghadiya: [ChoghadiyaType.shubh, ChoghadiyaType.amrit],
      minimumDurationMinutes: 30,
    ),

    // 15. Travel (Yatra)
    MuhuratRuleConfig(
      id: 'travel',
      title: 'Travel (Yatra)',
      icon: '✈️',
      description: 'Commencing journey, pilgrimage, or foreign travel.',
      allowedWeekdays: [1, 3, 4, 5],
      allowedTithis: [2, 3, 5, 7, 10, 11, 13],
      allowedNakshatras: [1, 5, 7, 8, 13, 15, 22, 27],
      preferredChoghadiya: [ChoghadiyaType.char, ChoghadiyaType.labh, ChoghadiyaType.amrit],
      minimumDurationMinutes: 30,
    ),

    // 16. Puja & Havan
    MuhuratRuleConfig(
      id: 'puja_havan',
      title: 'Puja & Havan',
      icon: '🪔',
      description: 'Performing special Vedic pooja, homam, or yajna.',
      allowedWeekdays: [], // Any weekday allowed
      allowedTithis: [2, 3, 5, 7, 8, 10, 11, 12, 13, 15],
      allowedNakshatras: [],
      preferredChoghadiya: [ChoghadiyaType.amrit, ChoghadiyaType.shubh],
      minimumDurationMinutes: 45,
    ),

    // 17. Engagement (Sagai / Rokaa)
    MuhuratRuleConfig(
      id: 'engagement',
      title: 'Engagement',
      icon: '🤝',
      description: 'Formal betrothal, ring ceremony, and family alliance.',
      allowedWeekdays: [0, 1, 3, 4, 5],
      excludedWeekdays: [2],
      allowedTithis: [2, 3, 5, 7, 10, 11, 12, 13, 15],
      allowedNakshatras: [4, 5, 8, 10, 12, 13, 14, 15, 17, 21, 22, 26, 27],
      preferredChoghadiya: [ChoghadiyaType.shubh, ChoghadiyaType.amrit, ChoghadiyaType.labh],
      minimumDurationMinutes: 45,
    ),

    // 18. General Auspicious (Sarva Karya Siddhi)
    MuhuratRuleConfig(
      id: 'general_auspicious',
      title: 'General Auspicious',
      icon: '🌟',
      description: 'General auspicious window for important decisions, signing agreements, or good deeds.',
      allowedWeekdays: [],
      allowedTithis: [],
      allowedNakshatras: [],
      preferredChoghadiya: [ChoghadiyaType.amrit, ChoghadiyaType.shubh, ChoghadiyaType.labh],
      minimumDurationMinutes: 30,
    ),
  ];

  static MuhuratRuleConfig? getRule(String occasionId) {
    for (final rule in allRules) {
      if (rule.id == occasionId) return rule;
    }
    return null;
  }
}
