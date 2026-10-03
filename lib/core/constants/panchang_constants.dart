// Pure Dart constants and enumerations for Hindu Panchang mathematics and traditions.

enum CalendarTradition {
  standardHindu,
  vaishnavaIskcon,
  gitaPressReference,
}

enum RegionalProfile {
  northIndia,
  uttarPradesh,
  bihar,
  gujarat,
  maharashtra,
  rajasthan,
  bengal,
  tamilNadu,
  karnataka,
  andhraTelangana,
  kerala,
  odisha,
  other,
}

enum MonthSystem {
  purnimanta, // Month ends on Purnima (common in North India, UP, Bihar, Rajasthan)
  amanta,     // Month ends on Amavasya (common in Gujarat, Maharashtra, South India)
}

enum MuhuratStatus {
  suitable,
  conditional,
  notSuitable,
}

enum Paksha {
  shukla,
  krishna,
}

enum ChoghadiyaType {
  amrit,
  shubh,
  labh,
  char,
  rog,
  kaal,
  udveg;

  bool get isAuspicious =>
      this == ChoghadiyaType.amrit ||
      this == ChoghadiyaType.shubh ||
      this == ChoghadiyaType.labh ||
      this == ChoghadiyaType.char;
}

class PanchangConstants {
  static const List<String> tithiNames = [
    'Pratipada',
    'Dvitiya',
    'Tritiya',
    'Chaturthi',
    'Panchami',
    'Shashthi',
    'Saptami',
    'Ashtami',
    'Navami',
    'Dashami',
    'Ekadashi',
    'Dvadashi',
    'Trayodashi',
    'Chaturdashi',
    'Purnima', // 15
    'Pratipada',
    'Dvitiya',
    'Tritiya',
    'Chaturthi',
    'Panchami',
    'Shashthi',
    'Saptami',
    'Ashtami',
    'Navami',
    'Dashami',
    'Ekadashi',
    'Dvadashi',
    'Trayodashi',
    'Chaturdashi',
    'Amavasya', // 30
  ];

  static const List<String> nakshatraNames = [
    'Ashwini',
    'Bharani',
    'Krittika',
    'Rohini',
    'Mrigashira',
    'Ardra',
    'Punarvasu',
    'Pushya',
    'Ashlesha',
    'Magha',
    'Purva Phalguni',
    'Uttara Phalguni',
    'Hasta',
    'Chitra',
    'Swati',
    'Vishakha',
    'Anuradha',
    'Jyeshtha',
    'Mula',
    'Purva Ashadha',
    'Uttara Ashadha',
    'Shravana',
    'Dhanishta',
    'Shatabhisha',
    'Purva Bhadrapada',
    'Uttara Bhadrapada',
    'Revati',
  ];

  static const List<String> yogaNames = [
    'Vishkambha',
    'Priti',
    'Ayushman',
    'Saubhagya',
    'Shobhana',
    'Atiganda',
    'Sukarma',
    'Dhriti',
    'Shula',
    'Ganda',
    'Vriddhi',
    'Dhruva',
    'Vyaghata',
    'Harshana',
    'Vajra',
    'Siddhi',
    'Vyatipata',
    'Variyan',
    'Parigha',
    'Shiva',
    'Siddha',
    'Sadhya',
    'Shubha',
    'Shukla',
    'Brahma',
    'Indra',
    'Vaidhriti',
  ];

  static const List<String> karanaNames = [
    'Bava',
    'Balava',
    'Kaulava',
    'Taitila',
    'Gara',
    'Vanija',
    'Vishti', // Bhadra
    'Shakuni',
    'Chatushpada',
    'Naga',
    'Kintughna',
  ];

  static const List<String> varaNames = [
    'Ravivara',    // Sunday (0)
    'Somavara',    // Monday (1)
    'Mangalavara', // Tuesday (2)
    'Budhavara',   // Wednesday (3)
    'Guruvara',    // Thursday (4)
    'Shukravara',  // Friday (5)
    'Shanivara',   // Saturday (6)
  ];

  static const List<String> lunarMonthNames = [
    'Chaitra',
    'Vaishakha',
    'Jyeshtha',
    'Ashadha',
    'Shravana',
    'Bhadrapada',
    'Ashwin',
    'Kartika',
    'Margashirsha',
    'Pausha',
    'Magha',
    'Phalguna',
  ];

  // Choghadiya Day sequences (Sunday=0 to Saturday=6)
  static const Map<int, List<ChoghadiyaType>> dayChoghadiya = {
    0: [ChoghadiyaType.udveg, ChoghadiyaType.char, ChoghadiyaType.labh, ChoghadiyaType.amrit, ChoghadiyaType.kaal, ChoghadiyaType.shubh, ChoghadiyaType.rog, ChoghadiyaType.udveg], // Sun
    1: [ChoghadiyaType.amrit, ChoghadiyaType.kaal, ChoghadiyaType.shubh, ChoghadiyaType.rog, ChoghadiyaType.udveg, ChoghadiyaType.char, ChoghadiyaType.labh, ChoghadiyaType.amrit], // Mon
    2: [ChoghadiyaType.rog, ChoghadiyaType.udveg, ChoghadiyaType.char, ChoghadiyaType.labh, ChoghadiyaType.amrit, ChoghadiyaType.kaal, ChoghadiyaType.shubh, ChoghadiyaType.rog],     // Tue
    3: [ChoghadiyaType.labh, ChoghadiyaType.amrit, ChoghadiyaType.kaal, ChoghadiyaType.shubh, ChoghadiyaType.rog, ChoghadiyaType.udveg, ChoghadiyaType.char, ChoghadiyaType.labh], // Wed
    4: [ChoghadiyaType.shubh, ChoghadiyaType.rog, ChoghadiyaType.udveg, ChoghadiyaType.char, ChoghadiyaType.labh, ChoghadiyaType.amrit, ChoghadiyaType.kaal, ChoghadiyaType.shubh], // Thu
    5: [ChoghadiyaType.char, ChoghadiyaType.labh, ChoghadiyaType.amrit, ChoghadiyaType.kaal, ChoghadiyaType.shubh, ChoghadiyaType.rog, ChoghadiyaType.udveg, ChoghadiyaType.char],  // Fri
    6: [ChoghadiyaType.kaal, ChoghadiyaType.shubh, ChoghadiyaType.rog, ChoghadiyaType.udveg, ChoghadiyaType.char, ChoghadiyaType.labh, ChoghadiyaType.amrit, ChoghadiyaType.kaal],  // Sat
  };

  // Choghadiya Night sequences
  static const Map<int, List<ChoghadiyaType>> nightChoghadiya = {
    0: [ChoghadiyaType.shubh, ChoghadiyaType.amrit, ChoghadiyaType.char, ChoghadiyaType.rog, ChoghadiyaType.kaal, ChoghadiyaType.labh, ChoghadiyaType.udveg, ChoghadiyaType.shubh], // Sun
    1: [ChoghadiyaType.char, ChoghadiyaType.rog, ChoghadiyaType.kaal, ChoghadiyaType.labh, ChoghadiyaType.udveg, ChoghadiyaType.shubh, ChoghadiyaType.amrit, ChoghadiyaType.char],  // Mon
    2: [ChoghadiyaType.kaal, ChoghadiyaType.labh, ChoghadiyaType.udveg, ChoghadiyaType.shubh, ChoghadiyaType.amrit, ChoghadiyaType.char, ChoghadiyaType.rog, ChoghadiyaType.kaal],  // Tue
    3: [ChoghadiyaType.udveg, ChoghadiyaType.shubh, ChoghadiyaType.amrit, ChoghadiyaType.char, ChoghadiyaType.rog, ChoghadiyaType.kaal, ChoghadiyaType.labh, ChoghadiyaType.udveg], // Wed
    4: [ChoghadiyaType.amrit, ChoghadiyaType.char, ChoghadiyaType.rog, ChoghadiyaType.kaal, ChoghadiyaType.labh, ChoghadiyaType.udveg, ChoghadiyaType.shubh, ChoghadiyaType.amrit], // Thu
    5: [ChoghadiyaType.rog, ChoghadiyaType.kaal, ChoghadiyaType.labh, ChoghadiyaType.udveg, ChoghadiyaType.shubh, ChoghadiyaType.amrit, ChoghadiyaType.char, ChoghadiyaType.rog],     // Fri
    6: [ChoghadiyaType.labh, ChoghadiyaType.udveg, ChoghadiyaType.shubh, ChoghadiyaType.amrit, ChoghadiyaType.char, ChoghadiyaType.rog, ChoghadiyaType.kaal, ChoghadiyaType.labh], // Sat
  };

  // Rahu Kaal Octant by weekday (0=Sun, 1=Mon, ..., 6=Sat) 1-based octant of day
  // Mon: 2nd, Tue: 7th, Wed: 5th, Thu: 6th, Fri: 4th, Sat: 3rd, Sun: 8th
  static const Map<int, int> rahuKaalOctant = {
    0: 8,
    1: 2,
    2: 7,
    3: 5,
    4: 6,
    5: 4,
    6: 3,
  };

  // Yamaganda Octant (Mon: 4th, Tue: 3rd, Wed: 2nd, Thu: 1st, Fri: 7th, Sat: 6th, Sun: 5th)
  static const Map<int, int> yamagandaOctant = {
    0: 5,
    1: 4,
    2: 3,
    3: 2,
    4: 1,
    5: 7,
    6: 6,
  };

  // Gulika Octant (Mon: 6th, Tue: 5th, Wed: 4th, Thu: 3rd, Fri: 2nd, Sat: 1st, Sun: 7th)
  static const Map<int, int> gulikaOctant = {
    0: 7,
    1: 6,
    2: 5,
    3: 4,
    4: 3,
    5: 2,
    6: 1,
  };

  // Hora order of planetary rulers
  static const List<String> horaRulers = [
    'Sun',
    'Venus',
    'Mercury',
    'Moon',
    'Saturn',
    'Jupiter',
    'Mars',
  ];
}
