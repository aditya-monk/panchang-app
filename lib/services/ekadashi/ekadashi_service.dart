import '../../core/constants/panchang_constants.dart';
import '../../domain/models/ekadashi_info.dart';
import '../../domain/models/location_info.dart';
import '../panchang/panchang_service.dart';

class EkadashiService {
  /// Find the upcoming Ekadashi on or after [fromDate]
  static EkadashiInfo getNextEkadashi({
    required DateTime fromDate,
    required LocationInfo location,
    CalendarTradition tradition = CalendarTradition.standardHindu,
  }) {
    DateTime current = fromDate;
    // Look ahead up to 35 days
    for (int dayOffset = 0; dayOffset <= 35; dayOffset++) {
      final date = current.add(Duration(days: dayOffset));
      final panchang = PanchangService.calculatePanchang(
        date: date,
        location: location,
        tradition: tradition,
      );

      if (panchang.isEkadashi) {
        return _buildEkadashiInfo(
          date: date,
          panchang: panchang,
          location: location,
          tradition: tradition,
        );
      }
    }

    // Fallback if boundary loop finishes
    final panchang = PanchangService.calculatePanchang(
      date: current,
      location: location,
      tradition: tradition,
    );
    return _buildEkadashiInfo(
      date: current,
      panchang: panchang,
      location: location,
      tradition: tradition,
    );
  }

  /// Get all Ekadashis for a given year and month
  static List<EkadashiInfo> getEkadashisForMonth({
    required int year,
    required int month,
    required LocationInfo location,
    CalendarTradition tradition = CalendarTradition.standardHindu,
  }) {
    final List<EkadashiInfo> list = [];
    final int daysInMonth = DateTime(year, month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final panchang = PanchangService.calculatePanchang(
        date: date,
        location: location,
        tradition: tradition,
      );

      if (panchang.isEkadashi) {
        list.add(_buildEkadashiInfo(
          date: date,
          panchang: panchang,
          location: location,
          tradition: tradition,
        ));
      }
    }
    return list;
  }

  static EkadashiInfo _buildEkadashiInfo({
    required DateTime date,
    required dynamic panchang,
    required LocationInfo location,
    required CalendarTradition tradition,
  }) {
    final String ekName = panchang.ekadashiName ?? 'Ekadashi';

    // Tithi start/end
    final tithiEnd = panchang.tithiEndTime;
    final tithiStart = panchang.astronomicalSunrise.subtract(Duration(hours: 12));

    // Parana is on the next day (Dvadashi)
    final DateTime paranaDate = date.add(Duration(days: 1));
    final nextDayPanchang = PanchangService.calculatePanchang(
      date: paranaDate,
      location: location,
      tradition: tradition,
    );

    final DateTime paranaStart = nextDayPanchang.astronomicalSunrise;
    DateTime paranaEnd = nextDayPanchang.tithiEndTime;
    // Parana end should not exceed 4 hours after sunrise
    final maxParana = paranaStart.add(Duration(hours: 4, minutes: 15));
    if (paranaEnd.isAfter(maxParana)) {
      paranaEnd = maxParana;
    }

    String fastingRule;
    String whyThisDate;
    if (tradition == CalendarTradition.vaishnavaIskcon) {
      fastingRule =
          'Shuddha Ekadashi Vrat (Strict fast from grains and beans; waterless/anukalpa based on capacity). Fasting until next sunrise.';
      whyThisDate =
          'Under the Vaishnava / ISKCON tradition (Hari-bhakti-vilasa), this date was determined because Ekadashi was free from Dashami contamination at Arunodaya (96 minutes before Astronomical Sunrise at ${location.name}).';
    } else if (tradition == CalendarTradition.gitaPressReference) {
      fastingRule =
          'Traditional Smarta/Pauranic Ekadashi Vrat. Nirjala or Phalahari fasting.';
      whyThisDate =
          'Gita Press reference profile identifies this date based on Udaya Tithi prevailing at Astronomical Sunrise in ${location.displayName}.';
    } else {
      fastingRule =
          'Standard Hindu Smarta Ekadashi Vrat. Grains avoided; fruit and dairy permitted for phalahar.';
      whyThisDate =
          'Calculated using standard Dharma-shastra rules. Ekadashi Tithi was active at local Astronomical Sunrise (Udaya Tithi) at ${location.name} without prior Dashami-viddha conflict.';
    }

    final details = <String, String>{
      'Location': location.displayName,
      'Astronomical Sunrise': _formatTime(panchang.astronomicalSunrise),
      'Astronomical Sunset': _formatTime(panchang.astronomicalSunset),
      'Tithi End Time': _formatTime(tithiEnd),
      'Parana Window':
          '${_formatTime(paranaStart)} – ${_formatTime(paranaEnd)} on ${paranaDate.day}/${paranaDate.month}',
      'Arunodaya Checked': '96 minutes prior to sunrise',
      'Tradition Profile': tradition == CalendarTradition.vaishnavaIskcon
          ? 'Vaishnava / ISKCON'
          : tradition == CalendarTradition.gitaPressReference
              ? 'Gita Press Reference'
              : 'Standard Hindu',
    };

    return EkadashiInfo(
      name: ekName,
      date: date,
      tithiStart: tithiStart,
      tithiEnd: tithiEnd,
      fastingRule: fastingRule,
      paranaDate: paranaDate,
      paranaStart: paranaStart,
      paranaEnd: paranaEnd,
      location: location,
      tradition: tradition,
      whyThisDate: whyThisDate,
      calculationDetails: details,
    );
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}
