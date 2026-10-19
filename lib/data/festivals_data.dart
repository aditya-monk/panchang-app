import '../core/constants/panchang_constants.dart';
import '../domain/models/festival_info.dart';

class FestivalsData {
  /// Resolves Ekadashi name for a given lunar month index (0=Chaitra, 11=Phalguna) and Paksha
  static String getEkadashiName({
    required int lunarMonthIndex,
    required Paksha paksha,
  }) {
    // 0: Chaitra, 1: Vaishakha, 2: Jyeshtha, 3: Ashadha, 4: Shravana, 5: Bhadrapada,
    // 6: Ashwin, 7: Kartika, 8: Margashirsha, 9: Pausha, 10: Magha, 11: Phalguna
    if (paksha == Paksha.shukla) {
      const shuklaEkadashis = [
        'Kamada Ekadashi',        // Chaitra
        'Mohini Ekadashi',        // Vaishakha
        'Nirjala Ekadashi',       // Jyeshtha
        'Devshayani Ekadashi',    // Ashadha
        'Shravana Putrada Ekadashi', // Shravana
        'Parsva / Parivartini Ekadashi', // Bhadrapada
        'Papankusha Ekadashi',    // Ashwin
        'Devutthana / Prabodhini Ekadashi', // Kartika
        'Mokshada Ekadashi',      // Margashirsha
        'Pausha Putrada Ekadashi', // Pausha
        'Jaya Ekadashi',          // Magha
        'Amalaki Ekadashi',       // Phalguna
      ];
      return shuklaEkadashis[lunarMonthIndex % 12];
    } else {
      const krishnaEkadashis = [
        'Varuthini Ekadashi',     // Chaitra
        'Apara Ekadashi',         // Vaishakha
        'Yogini Ekadashi',        // Jyeshtha
        'Kamika Ekadashi',        // Ashadha
        'Aja / Annada Ekadashi',  // Shravana
        'Indira Ekadashi',        // Bhadrapada/Ashwin
        'Rama Ekadashi',          // Kartika
        'Utpanna Ekadashi',       // Margashirsha
        'Saphala Ekadashi',       // Pausha
        'Shat-tila Ekadashi',     // Magha
        'Vijaya Ekadashi',        // Phalguna
        'Papmochani Ekadashi',    // Chaitra
      ];
      return krishnaEkadashis[lunarMonthIndex % 12];
    }
  }

  /// Calculates festivals and vrats active on a given day based on lunar month, tithi, and tradition
  static ({List<String> festivals, List<String> vrats, List<String> vaishnava})
      detectFestivals({
    required int lunarMonthIndex,
    required int tithiNumber,
    required Paksha paksha,
    required CalendarTradition tradition,
    required DateTime date,
  }) {
    final List<String> f = [];
    final List<String> v = [];
    final List<String> vaish = [];

    // Recurring monthly Vrats
    if (tithiNumber == 11 || tithiNumber == 26) {
      final name = getEkadashiName(lunarMonthIndex: lunarMonthIndex, paksha: paksha);
      v.add('$name Vrat');
      if (tradition == CalendarTradition.vaishnavaIskcon) {
        vaish.add('Vaishnava $name (Fast until noon / complete fast)');
      }
    } else if (tithiNumber == 13 || tithiNumber == 28) {
      v.add('Pradosh Vrat');
    } else if (tithiNumber == 15) {
      v.add('Satyanarayan Puja (Purnima Vrat)');
    } else if (tithiNumber == 19) {
      v.add('Sankashti Chaturthi Vrat');
    } else if (tithiNumber == 30) {
      v.add('Darsha Amavasya Vrat');
    }

    // Solar events
    if (date.month == 1 && (date.day == 14 || date.day == 15)) {
      f.add('Makar Sankranti / Pongal');
    }

    // Month-specific major festivals
    switch (lunarMonthIndex % 12) {
      case 0: // Chaitra
        if (tithiNumber == 1) f.add('Chaitra Navratri begins / Gudi Padwa / Ugadi');
        if (tithiNumber == 8) f.add('Durga Ashtami');
        if (tithiNumber == 9) f.add('Rama Navami');
        if (tithiNumber == 15) f.add('Hanuman Jayanti');
        break;
      case 1: // Vaishakha
        if (tithiNumber == 3) f.add('Akshaya Tritiya');
        if (tithiNumber == 14) {
          f.add('Narasimha Jayanti');
          vaish.add('Sri Nrisimha Caturdashi (Fasting until dusk)');
        }
        if (tithiNumber == 15) f.add('Buddha Purnima');
        break;
      case 2: // Jyeshtha
        if (tithiNumber == 10) f.add('Ganga Dussehra');
        if (tithiNumber == 15 || tithiNumber == 30) f.add('Vat Savitri Vrat');
        break;
      case 3: // Ashadha
        if (tithiNumber == 2) {
          f.add('Jagannath Ratha Yatra');
          vaish.add('Sri Jagannatha Ratha Yatra (Puri & Worldwide)');
        }
        if (tithiNumber == 11) f.add('Devshayani Ekadashi (Chaturmasya begins)');
        if (tithiNumber == 15) f.add('Guru Purnima');
        break;
      case 4: // Shravana
        if (tithiNumber == 3) f.add('Hariyali Teej');
        if (tithiNumber == 5) f.add('Nag Panchami');
        if (tithiNumber == 15) f.add('Raksha Bandhan / Shravana Purnima');
        if (tithiNumber == 23) {
          f.add('Krishna Janmashtami');
          vaish.add('Sri Krishna Janmashtami (Fast until midnight)');
        }
        break;
      case 5: // Bhadrapada
        if (tithiNumber == 3) f.add('Hartalika Teej');
        if (tithiNumber == 4) f.add('Ganesh Chaturthi');
        if (tithiNumber == 5) f.add('Rishi Panchami');
        if (tithiNumber == 8) {
          f.add('Radhashtami');
          vaish.add('Sri Radhashtami (Fast until noon)');
        }
        if (tithiNumber == 14) f.add('Anant Chaturdashi');
        if (tithiNumber == 30) f.add('Mahalaya / Sarva Pitru Amavasya');
        break;
      case 6: // Ashwin
        if (tithiNumber == 1) f.add('Sharad Navratri begins (Ghatasthapana)');
        if (tithiNumber == 8) f.add('Durga Ashtami');
        if (tithiNumber == 9) f.add('Maha Navami');
        if (tithiNumber == 10) f.add('Vijayadashami / Dussehra');
        if (tithiNumber == 15) f.add('Sharad Purnima / Kojagiri');
        if (tithiNumber == 19) f.add('Karwa Chauth');
        if (tithiNumber == 28) f.add('Dhanteras / Dhanvantari Jayanti');
        if (tithiNumber == 29) f.add('Naraka Chaturdashi / Choti Diwali');
        if (tithiNumber == 30) f.add('Diwali / Lakshmi Puja');
        break;
      case 7: // Kartika
        if (tithiNumber == 1) {
          f.add('Govardhan Puja / Annakut');
          vaish.add('Sri Govardhana Puja & Go-puja');
        }
        if (tithiNumber == 2) f.add('Bhai Dooj / Yama Dvitiya');
        if (tithiNumber == 6) f.add('Chhath Puja');
        if (tithiNumber == 11) f.add('Devutthana Ekadashi / Tulsi Vivah');
        if (tithiNumber == 15) f.add('Kartika Purnima / Dev Diwali');
        break;
      case 8: // Margashirsha
        if (tithiNumber == 11) f.add('Gita Jayanti / Mokshada Ekadashi');
        break;
      case 9: // Pausha
        if (tithiNumber == 15) f.add('Pausha Purnima');
        break;
      case 10: // Magha
        if (tithiNumber == 5) f.add('Vasant Panchami / Saraswati Puja');
        if (tithiNumber == 7) f.add('Ratha Saptami');
        if (tithiNumber == 29) f.add('Maha Shivaratri');
        break;
      case 11: // Phalguna
        if (tithiNumber == 15) {
          f.add('Holika Dahan');
          vaish.add('Sri Gaura Purnima (Appearance of Sri Chaitanya Mahaprabhu - Fast until moonrise)');
        }
        if (tithiNumber == 16) f.add('Holi / Dhulandi');
        break;
    }

    return (festivals: f, vrats: v, vaishnava: vaish);
  }
}
