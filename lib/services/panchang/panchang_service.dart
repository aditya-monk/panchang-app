import '../../core/constants/panchang_constants.dart';
import '../../data/festivals_data.dart';
import '../../domain/models/location_info.dart';
import '../../domain/models/panchang_day.dart';
import '../astronomy/astronomy_engine.dart';

class PanchangService {
  /// Cache of calculated PanchangDay instances keyed by "yyyy-MM-dd:location:tradition"
  static final Map<String, PanchangDay> _cache = {};

  /// Calculate complete daily Panchang for given date, location, tradition, and regional profile
  static PanchangDay calculatePanchang({
    required DateTime date,
    required LocationInfo location,
    CalendarTradition tradition = CalendarTradition.standardHindu,
    RegionalProfile regionalProfile = RegionalProfile.gujarat,
    MonthSystem? monthSystemOverride,
  }) {
    final String cacheKey =
        '${date.year}-${date.month}-${date.day}:${location.name}:${tradition.name}';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    // 1. Astronomical Sunrise, Sunset, and Solar Noon
    final sunTimes = AstronomyEngine.calculateSunRiseSet(
      localDate: date,
      latitude: location.latitude,
      longitude: location.longitude,
      timezoneHours: location.timezoneHours,
    );
    final DateTime sunrise = sunTimes.sunrise;
    final DateTime sunset = sunTimes.sunset;
    final DateTime solarNoon = sunTimes.solarNoon;

    // 2. Moonrise and Moonset
    final moonTimes = AstronomyEngine.calculateMoonRiseSet(
      localDate: date,
      latitude: location.latitude,
      longitude: location.longitude,
      timezoneHours: location.timezoneHours,
    );

    // 3. Astronomical values at Sunrise (Udaya Tithi & Nakshatra)
    final DateTime sunriseUtc = sunrise.subtract(
        Duration(minutes: (location.timezoneHours * 60).round()));

    final tithiData = AstronomyEngine.calculateTithi(sunriseUtc);
    final int tithiNum = tithiData.tithiNumber;
    final String tithiName = PanchangConstants.tithiNames[tithiNum - 1];
    final DateTime tithiEnd = AstronomyEngine.findTithiEndTime(
        sunriseUtc, location.timezoneHours);
    final String nextTithiName =
        PanchangConstants.tithiNames[tithiNum % 30];

    final nakshatraData = AstronomyEngine.calculateNakshatra(sunriseUtc);
    final int nakshatraNum = nakshatraData.nakshatraNumber;
    final String nakshatraName =
        PanchangConstants.nakshatraNames[nakshatraNum - 1];
    final DateTime nakshatraEnd = AstronomyEngine.findNakshatraEndTime(
        sunriseUtc, location.timezoneHours);

    final yogaData = AstronomyEngine.calculateYoga(sunriseUtc);
    final int yogaNum = yogaData.yogaNumber;
    final String yogaName = PanchangConstants.yogaNames[yogaNum - 1];
    final DateTime yogaEnd = sunrise.add(Duration(hours: 18)); // Approx end

    final karanaData = AstronomyEngine.calculateKarana(sunriseUtc);
    final String karanaName = karanaData.name;
    final String nextKaranaName =
        PanchangConstants.karanaNames[(karanaData.karanaIndex + 1) % 11];

    // 4. Vara (Weekday) from sunrise
    final int weekday = date.weekday % 7; // DateTime weekday is 1=Mon..7=Sun -> 0=Sun..6=Sat
    final String vara = PanchangConstants.varaNames[weekday];

    // 5. Day & Night durations
    final Duration dinamana = sunset.difference(sunrise);
    final double dayMilliseconds = dinamana.inMilliseconds.toDouble();
    final double eighthDay = dayMilliseconds / 8.0;

    // Rahu Kaal
    final int rahuOctant = PanchangConstants.rahuKaalOctant[weekday]!;
    final DateTime rahuKaalStart = sunrise.add(
        Duration(milliseconds: ((rahuOctant - 1) * eighthDay).round()));
    final DateTime rahuKaalEnd = sunrise.add(
        Duration(milliseconds: (rahuOctant * eighthDay).round()));

    // Yamaganda
    final int yamagandaOctant = PanchangConstants.yamagandaOctant[weekday]!;
    final DateTime yamagandaStart = sunrise.add(
        Duration(milliseconds: ((yamagandaOctant - 1) * eighthDay).round()));
    final DateTime yamagandaEnd = sunrise.add(
        Duration(milliseconds: (yamagandaOctant * eighthDay).round()));

    // Gulika Kaal
    final int gulikaOctant = PanchangConstants.gulikaOctant[weekday]!;
    final DateTime gulikaStart = sunrise.add(
        Duration(milliseconds: ((gulikaOctant - 1) * eighthDay).round()));
    final DateTime gulikaEnd = sunrise.add(
        Duration(milliseconds: (gulikaOctant * eighthDay).round()));

    // Muhurtas of the day (15 parts)
    final double dayMuhurtaMs = dayMilliseconds / 15.0;
    // Abhijit is the 8th Muhurta of the day
    final DateTime abhijitStart =
        sunrise.add(Duration(milliseconds: (7 * dayMuhurtaMs).round()));
    final DateTime abhijitEnd =
        sunrise.add(Duration(milliseconds: (8 * dayMuhurtaMs).round()));

    // Brahma Muhurat: 2 muhurtas before sunrise, lasting 1 muhurta (approx 96 min to 48 min before sunrise)
    final DateTime brahmaMuhuratStart =
        sunrise.subtract(Duration(minutes: 96));
    final DateTime brahmaMuhuratEnd =
        sunrise.subtract(Duration(minutes: 48));

    // 6. Day Choghadiya (8 parts)
    final List<ChoghadiyaPeriod> dayChoghadiya = [];
    final List<ChoghadiyaType> dayTypes =
        PanchangConstants.dayChoghadiya[weekday]!;
    for (int i = 0; i < 8; i++) {
      final DateTime cStart =
          sunrise.add(Duration(milliseconds: (i * eighthDay).round()));
      final DateTime cEnd =
          sunrise.add(Duration(milliseconds: ((i + 1) * eighthDay).round()));
      final type = dayTypes[i];
      dayChoghadiya.add(ChoghadiyaPeriod(
        type: type,
        name: _choghadiyaName(type),
        start: cStart,
        end: cEnd,
        isAuspicious: type.isAuspicious,
      ));
    }

    // 7. Night Choghadiya (8 parts until next sunrise)
    final List<ChoghadiyaPeriod> nightChoghadiya = [];
    final List<ChoghadiyaType> nightTypes =
        PanchangConstants.nightChoghadiya[weekday]!;
    // Next day sunrise approx 24h later
    final double eighthNight = (24 * 3600 * 1000 - dayMilliseconds) / 8.0;
    for (int i = 0; i < 8; i++) {
      final DateTime cStart =
          sunset.add(Duration(milliseconds: (i * eighthNight).round()));
      final DateTime cEnd =
          sunset.add(Duration(milliseconds: ((i + 1) * eighthNight).round()));
      final type = nightTypes[i];
      nightChoghadiya.add(ChoghadiyaPeriod(
        type: type,
        name: _choghadiyaName(type),
        start: cStart,
        end: cEnd,
        isAuspicious: type.isAuspicious,
      ));
    }

    // 8. Lunar Month & Paksha
    final double jd = AstronomyEngine.toJulianDay(sunriseUtc);
    final double sunSidereal = AstronomyEngine.sunSiderealLongitude(jd);
    // Solar Rashi (0: Mesha -> Chaitra, ..., 11: Meena -> Phalguna)
    final int solarRashi = (sunSidereal / 30.0).floor() % 12;
    final int lunarMonthIndex = solarRashi;
    final String lunarMonthName =
        PanchangConstants.lunarMonthNames[lunarMonthIndex];

    final Paksha paksha = (tithiNum <= 15) ? Paksha.shukla : Paksha.krishna;
    final MonthSystem monthSystem = monthSystemOverride ??
        ((regionalProfile == RegionalProfile.gujarat ||
                regionalProfile == RegionalProfile.maharashtra ||
                regionalProfile == RegionalProfile.tamilNadu ||
                regionalProfile == RegionalProfile.karnataka ||
                regionalProfile == RegionalProfile.andhraTelangana ||
                regionalProfile == RegionalProfile.kerala)
            ? MonthSystem.amanta
            : MonthSystem.purnimanta);

    // 9. Festivals & Ekadashi
    final detected = FestivalsData.detectFestivals(
      lunarMonthIndex: lunarMonthIndex,
      tithiNumber: tithiNum,
      paksha: paksha,
      tradition: tradition,
      date: date,
    );

    final bool isEkadashi = (tithiNum == 11 || tithiNum == 26);
    final String? ekadashiName = isEkadashi
        ? FestivalsData.getEkadashiName(
            lunarMonthIndex: lunarMonthIndex, paksha: paksha)
        : null;

    final panchangDay = PanchangDay(
      localDate: date,
      location: location,
      tradition: tradition,
      regionalProfile: regionalProfile,
      monthSystem: monthSystem,
      lunarMonthName: lunarMonthName,
      paksha: paksha,
      tithiNumber: tithiNum,
      tithiName: tithiName,
      tithiEndTime: tithiEnd,
      nextTithiName: nextTithiName,
      nakshatraNumber: nakshatraNum,
      nakshatraName: nakshatraName,
      nakshatraEndTime: nakshatraEnd,
      yogaNumber: yogaNum,
      yogaName: yogaName,
      yogaEndTime: yogaEnd,
      karanaName: karanaName,
      nextKaranaName: nextKaranaName,
      vara: vara,
      astronomicalSunrise: sunrise,
      astronomicalSunset: sunset,
      moonrise: moonTimes.moonrise,
      moonset: moonTimes.moonset,
      solarNoon: solarNoon,
      brahmaMuhuratStart: brahmaMuhuratStart,
      brahmaMuhuratEnd: brahmaMuhuratEnd,
      abhijitMuhuratStart: abhijitStart,
      abhijitMuhuratEnd: abhijitEnd,
      rahuKaalStart: rahuKaalStart,
      rahuKaalEnd: rahuKaalEnd,
      yamagandaStart: yamagandaStart,
      yamagandaEnd: yamagandaEnd,
      gulikaStart: gulikaStart,
      gulikaEnd: gulikaEnd,
      dayChoghadiya: dayChoghadiya,
      nightChoghadiya: nightChoghadiya,
      isEkadashi: isEkadashi,
      ekadashiName: ekadashiName,
      festivals: detected.festivals,
      vrats: detected.vrats,
      vaishnavaEvents: detected.vaishnava,
    );

    _cache[cacheKey] = panchangDay;
    return panchangDay;
  }

  static String _choghadiyaName(ChoghadiyaType type) {
    switch (type) {
      case ChoghadiyaType.amrit:
        return 'Amrit';
      case ChoghadiyaType.shubh:
        return 'Shubh';
      case ChoghadiyaType.labh:
        return 'Labh';
      case ChoghadiyaType.char:
        return 'Char';
      case ChoghadiyaType.rog:
        return 'Rog';
      case ChoghadiyaType.kaal:
        return 'Kaal';
      case ChoghadiyaType.udveg:
        return 'Udveg';
    }
  }
}
