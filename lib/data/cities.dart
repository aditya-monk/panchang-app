import '../domain/models/location_info.dart';

/// Bundled offline database of 100+ prominent Indian & global cities with multilingual aliases.
/// Zero API calls required.
class CityDatabase {
  static const List<LocationInfo> cities = [
    // Gujarat
    LocationInfo(
      name: 'Ahmedabad',
      state: 'Gujarat',
      latitude: 23.0225,
      longitude: 72.5714,
      aliases: ['Amdavad', 'અમદાવાદ', 'अहमदाबाद', 'Karnavati'],
    ),
    LocationInfo(
      name: 'Vadodara',
      state: 'Gujarat',
      latitude: 22.3072,
      longitude: 73.1812,
      aliases: ['Baroda', 'વડોદરા', 'वडोदरा', 'Sanskari Nagari'],
    ),
    LocationInfo(
      name: 'Surat',
      state: 'Gujarat',
      latitude: 21.1702,
      longitude: 72.8311,
      aliases: ['સુરત', 'सूरत', 'Suryapur'],
    ),
    LocationInfo(
      name: 'Rajkot',
      state: 'Gujarat',
      latitude: 22.3039,
      longitude: 70.8022,
      aliases: ['રાજકોટ', 'राजकोट'],
    ),
    LocationInfo(
      name: 'Gandhinagar',
      state: 'Gujarat',
      latitude: 23.2156,
      longitude: 72.6369,
      aliases: ['ગાંધીનગર', 'गांधीनगर'],
    ),
    LocationInfo(
      name: 'Bhavnagar',
      state: 'Gujarat',
      latitude: 21.7645,
      longitude: 72.1519,
      aliases: ['ભાવનગર', 'भावनगर'],
    ),
    LocationInfo(
      name: 'Dwarka',
      state: 'Gujarat',
      latitude: 22.2442,
      longitude: 68.9685,
      aliases: ['દ્વારકા', 'द्वारका', 'Dwaraka'],
    ),
    LocationInfo(
      name: 'Somnath',
      state: 'Gujarat',
      latitude: 20.8880,
      longitude: 70.4012,
      aliases: ['સોમનાથ', 'सोमनाथ', 'Prabhas Patan'],
    ),
    LocationInfo(
      name: 'Junagadh',
      state: 'Gujarat',
      latitude: 21.5222,
      longitude: 70.4579,
      aliases: ['જુનાગઢ', 'जूनागढ़'],
    ),
    LocationInfo(
      name: 'Bhuj',
      state: 'Gujarat',
      latitude: 23.2420,
      longitude: 69.6669,
      aliases: ['ભુજ', 'भुज', 'Kutch'],
    ),

    // Maharashtra
    LocationInfo(
      name: 'Mumbai',
      state: 'Maharashtra',
      latitude: 19.0760,
      longitude: 72.8777,
      aliases: ['Bombay', 'मुंबई', 'बॉम्बे'],
    ),
    LocationInfo(
      name: 'Pune',
      state: 'Maharashtra',
      latitude: 18.5204,
      longitude: 73.8567,
      aliases: ['Poona', 'पुणे', 'पुना'],
    ),
    LocationInfo(
      name: 'Nagpur',
      state: 'Maharashtra',
      latitude: 21.1458,
      longitude: 79.0882,
      aliases: ['नागपूर', 'नागपुर'],
    ),
    LocationInfo(
      name: 'Nashik',
      state: 'Maharashtra',
      latitude: 19.9975,
      longitude: 73.7898,
      aliases: ['Nasik', 'नाशिक', 'नासिक'],
    ),
    LocationInfo(
      name: 'Shirdi',
      state: 'Maharashtra',
      latitude: 19.7667,
      longitude: 74.4764,
      aliases: ['शिर्डी', 'शिरडी'],
    ),
    LocationInfo(
      name: 'Kolhapur',
      state: 'Maharashtra',
      latitude: 16.7050,
      longitude: 74.2433,
      aliases: ['कोल्हापूर', 'कोल्हापुर'],
    ),
    LocationInfo(
      name: 'Trimbakeshwar',
      state: 'Maharashtra',
      latitude: 19.9324,
      longitude: 73.5307,
      aliases: ['त्र्यंबकेश्वर', 'त्र्यम्बकेश्वर'],
    ),

    // Uttar Pradesh
    LocationInfo(
      name: 'Varanasi',
      state: 'Uttar Pradesh',
      latitude: 25.3176,
      longitude: 82.9739,
      aliases: ['Banaras', 'Kashi', 'वाराणसी', 'बनारस', 'काशी', 'Benares'],
    ),
    LocationInfo(
      name: 'Ayodhya',
      state: 'Uttar Pradesh',
      latitude: 26.7922,
      longitude: 82.1998,
      aliases: ['अयोध्या', 'Faizabad', 'अवध', 'Awadh'],
    ),
    LocationInfo(
      name: 'Mathura',
      state: 'Uttar Pradesh',
      latitude: 27.4924,
      longitude: 77.6737,
      aliases: ['मथुरा', 'Braj'],
    ),
    LocationInfo(
      name: 'Vrindavan',
      state: 'Uttar Pradesh',
      latitude: 27.5806,
      longitude: 77.7006,
      aliases: ['वृन्दावन', 'वृंदावन', 'Brindavan'],
    ),
    LocationInfo(
      name: 'Prayagraj',
      state: 'Uttar Pradesh',
      latitude: 25.4358,
      longitude: 81.8463,
      aliases: ['Allahabad', 'प्रयागराज', 'इलाहाबाद', 'Triveni Sangam'],
    ),
    LocationInfo(
      name: 'Lucknow',
      state: 'Uttar Pradesh',
      latitude: 26.8467,
      longitude: 80.9462,
      aliases: ['लखनऊ', 'लखनउ'],
    ),
    LocationInfo(
      name: 'Kanpur',
      state: 'Uttar Pradesh',
      latitude: 26.4499,
      longitude: 80.3319,
      aliases: ['कानपुर'],
    ),
    LocationInfo(
      name: 'Gorakhpur',
      state: 'Uttar Pradesh',
      latitude: 26.7606,
      longitude: 83.3732,
      aliases: ['गोरखपुर', 'Gorakhdham'],
    ),
    LocationInfo(
      name: 'Noida',
      state: 'Uttar Pradesh',
      latitude: 28.5355,
      longitude: 77.3910,
      aliases: ['नोएडा'],
    ),

    // Delhi NCR
    LocationInfo(
      name: 'New Delhi',
      state: 'Delhi',
      latitude: 28.6139,
      longitude: 77.2090,
      aliases: ['Delhi', 'नई दिल्ली', 'दिल्ली', 'Dilli'],
    ),
    LocationInfo(
      name: 'Gurugram',
      state: 'Haryana',
      latitude: 28.4595,
      longitude: 77.0266,
      aliases: ['Gurgaon', 'गुरुग्राम', 'गुडगाँव'],
    ),

    // Rajasthan
    LocationInfo(
      name: 'Jaipur',
      state: 'Rajasthan',
      latitude: 26.9124,
      longitude: 75.7873,
      aliases: ['Pink City', 'जयपुर'],
    ),
    LocationInfo(
      name: 'Udaipur',
      state: 'Rajasthan',
      latitude: 24.5854,
      longitude: 73.7125,
      aliases: ['City of Lakes', 'उदयपुर'],
    ),
    LocationInfo(
      name: 'Jodhpur',
      state: 'Rajasthan',
      latitude: 26.2389,
      longitude: 73.0243,
      aliases: ['जोधपुर', 'Sun City'],
    ),
    LocationInfo(
      name: 'Pushkar',
      state: 'Rajasthan',
      latitude: 26.4897,
      longitude: 74.5511,
      aliases: ['पुष्कर', 'Ajmer'],
    ),
    LocationInfo(
      name: 'Kota',
      state: 'Rajasthan',
      latitude: 25.2138,
      longitude: 75.8648,
      aliases: ['कोटा'],
    ),

    // Madhya Pradesh
    LocationInfo(
      name: 'Ujjain',
      state: 'Madhya Pradesh',
      latitude: 23.1765,
      longitude: 75.7885,
      aliases: ['उज्जैन', 'Avantika', 'Mahakaleshwar'],
    ),
    LocationInfo(
      name: 'Indore',
      state: 'Madhya Pradesh',
      latitude: 22.7196,
      longitude: 75.8577,
      aliases: ['इंदौर'],
    ),
    LocationInfo(
      name: 'Bhopal',
      state: 'Madhya Pradesh',
      latitude: 23.2599,
      longitude: 77.4126,
      aliases: ['भोपाल'],
    ),
    LocationInfo(
      name: 'Omkareshwar',
      state: 'Madhya Pradesh',
      latitude: 22.2439,
      longitude: 76.1508,
      aliases: ['ओंकारेश्वर'],
    ),

    // Bihar
    LocationInfo(
      name: 'Patna',
      state: 'Bihar',
      latitude: 25.5941,
      longitude: 85.1376,
      aliases: ['Pataliputra', 'पटना', 'पाटलिपुत्र'],
    ),
    LocationInfo(
      name: 'Gaya',
      state: 'Bihar',
      latitude: 24.7914,
      longitude: 85.0002,
      aliases: ['Bodh Gaya', 'गया', 'बोधगया'],
    ),
    LocationInfo(
      name: 'Muzaffarpur',
      state: 'Bihar',
      latitude: 26.1209,
      longitude: 85.3647,
      aliases: ['मुजफ्फरपुर'],
    ),
    LocationInfo(
      name: 'Darbhanga',
      state: 'Bihar',
      latitude: 26.1542,
      longitude: 85.8918,
      aliases: ['दरभंगा', 'Mithila'],
    ),

    // West Bengal
    LocationInfo(
      name: 'Kolkata',
      state: 'West Bengal',
      latitude: 22.5726,
      longitude: 88.3639,
      aliases: ['Calcutta', 'कोलकाता', 'कलकत्ता'],
    ),
    LocationInfo(
      name: 'Mayapur',
      state: 'West Bengal',
      latitude: 23.4233,
      longitude: 88.3908,
      aliases: ['मायापुर', 'Navadvipa', 'नवद्वीप', 'ISKCON HQ'],
    ),

    // Karnataka
    LocationInfo(
      name: 'Bengaluru',
      state: 'Karnataka',
      latitude: 12.9716,
      longitude: 77.5946,
      aliases: ['Bangalore', 'बेंगलुरु', 'ಬೆಂಗಳೂರು'],
    ),
    LocationInfo(
      name: 'Mysuru',
      state: 'Karnataka',
      latitude: 12.2958,
      longitude: 76.6394,
      aliases: ['Mysore', 'मैसूर', 'ಮೈಸೂರು'],
    ),
    LocationInfo(
      name: 'Udupi',
      state: 'Karnataka',
      latitude: 13.3409,
      longitude: 74.7421,
      aliases: ['उडुपी', 'ಉಡುಪಿ', 'Krishna Matha'],
    ),

    // Tamil Nadu
    LocationInfo(
      name: 'Chennai',
      state: 'Tamil Nadu',
      latitude: 13.0827,
      longitude: 80.2707,
      aliases: ['Madras', 'चेन्नई', 'சென்னை'],
    ),
    LocationInfo(
      name: 'Madurai',
      state: 'Tamil Nadu',
      latitude: 9.9252,
      longitude: 78.1198,
      aliases: ['मदुरै', 'மதுரை', 'Meenakshi Temple'],
    ),
    LocationInfo(
      name: 'Rameswaram',
      state: 'Tamil Nadu',
      latitude: 9.2876,
      longitude: 79.3129,
      aliases: ['रामेश्वरम', 'ராமேஸ்வரம்'],
    ),

    // Andhra Pradesh & Telangana
    LocationInfo(
      name: 'Hyderabad',
      state: 'Telangana',
      latitude: 17.3850,
      longitude: 78.4867,
      aliases: ['हैदराबाद', 'హైదరాబాద్'],
    ),
    LocationInfo(
      name: 'Tirupati',
      state: 'Andhra Pradesh',
      latitude: 13.6288,
      longitude: 79.4192,
      aliases: ['तिरुपति', 'తిరుపతి', 'Tirumala'],
    ),

    // Kerala
    LocationInfo(
      name: 'Thiruvananthapuram',
      state: 'Kerala',
      latitude: 8.5241,
      longitude: 76.9366,
      aliases: ['Trivandrum', 'तिरुवनंतपुरम', 'തിരുവനന്തപുരം', 'Padmanabhaswamy'],
    ),
    LocationInfo(
      name: 'Kochi',
      state: 'Kerala',
      latitude: 9.9312,
      longitude: 76.2673,
      aliases: ['Cochin', 'कोच्चि', 'കൊച്ചി'],
    ),
    LocationInfo(
      name: 'Guruvayur',
      state: 'Kerala',
      latitude: 10.5946,
      longitude: 76.0416,
      aliases: ['गुरुवायुर', 'ഗുരുവായൂർ'],
    ),

    // Odisha
    LocationInfo(
      name: 'Puri',
      state: 'Odisha',
      latitude: 19.8135,
      longitude: 85.8312,
      aliases: ['पुरी', 'Jagannath Puri', 'ଶ୍ରୀକ୍ଷେତ୍ର'],
    ),
    LocationInfo(
      name: 'Bhubaneswar',
      state: 'Odisha',
      latitude: 20.2961,
      longitude: 85.8245,
      aliases: ['भुवनेश्वर', 'ଭୁବନେଶ୍ୱର'],
    ),

    // Uttarakhand
    LocationInfo(
      name: 'Haridwar',
      state: 'Uttarakhand',
      latitude: 29.9457,
      longitude: 78.1642,
      aliases: ['हरिद्वार', 'Hardwar', 'Gangadwara'],
    ),
    LocationInfo(
      name: 'Rishikesh',
      state: 'Uttarakhand',
      latitude: 30.0869,
      longitude: 78.2676,
      aliases: ['ऋषिकेश'],
    ),
    LocationInfo(
      name: 'Badrinath',
      state: 'Uttarakhand',
      latitude: 30.7433,
      longitude: 79.4938,
      aliases: ['बद्रीनाथ'],
    ),
    LocationInfo(
      name: 'Kedarnath',
      state: 'Uttarakhand',
      latitude: 30.7352,
      longitude: 79.0669,
      aliases: ['केदारनाथ'],
    ),

    // International Reference Centers
    LocationInfo(
      name: 'Kathmandu',
      state: 'Bagmati',
      country: 'Nepal',
      latitude: 27.7172,
      longitude: 85.3240,
      timezoneHours: 5.75,
      timezoneId: 'Asia/Kathmandu',
      aliases: ['काठमाडौं', 'Pashupatinath'],
    ),
    LocationInfo(
      name: 'London',
      state: 'Greater London',
      country: 'United Kingdom',
      latitude: 51.5074,
      longitude: -0.1278,
      timezoneHours: 0.0,
      timezoneId: 'Europe/London',
      aliases: ['लंदन'],
    ),
    LocationInfo(
      name: 'New York',
      state: 'New York',
      country: 'USA',
      latitude: 40.7128,
      longitude: -74.0060,
      timezoneHours: -5.0,
      timezoneId: 'America/New_York',
      aliases: ['न्यूयॉर्क', 'NYC'],
    ),
    LocationInfo(
      name: 'San Francisco',
      state: 'California',
      country: 'USA',
      latitude: 37.7749,
      longitude: -122.4194,
      timezoneHours: -8.0,
      timezoneId: 'America/Los_Angeles',
      aliases: ['सैन फ्रांसिस्को', 'SF', 'Bay Area'],
    ),
    LocationInfo(
      name: 'Singapore',
      state: 'Singapore',
      country: 'Singapore',
      latitude: 1.3521,
      longitude: 103.8198,
      timezoneHours: 8.0,
      timezoneId: 'Asia/Singapore',
      aliases: ['सिंगापुर'],
    ),
    LocationInfo(
      name: 'Dubai',
      state: 'Dubai',
      country: 'UAE',
      latitude: 25.2048,
      longitude: 55.2708,
      timezoneHours: 4.0,
      timezoneId: 'Asia/Dubai',
      aliases: ['दुबई'],
    ),
  ];

  /// Search city by name, state, or alias (case-insensitive substring match)
  static List<LocationInfo> search(String query) {
    if (query.trim().isEmpty) return [LocationInfo.vadodara, LocationInfo.ahmedabad, LocationInfo.varanasi];
    final q = query.trim().toLowerCase();

    return cities.where((c) {
      if (c.name.toLowerCase().contains(q)) return true;
      if (c.state.toLowerCase().contains(q)) return true;
      for (final a in c.aliases) {
        if (a.toLowerCase().contains(q)) return true;
      }
      return false;
    }).toList();
  }

  /// Exact or nearest match
  static LocationInfo? findByName(String name) {
    final list = search(name);
    return list.isNotEmpty ? list.first : null;
  }
}
