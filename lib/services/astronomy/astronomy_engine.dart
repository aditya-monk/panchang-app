import 'dart:math' as math;

/// High-precision, offline-first Astronomical Engine implemented in pure Dart.
/// Uses Jean Meeus algorithms (Astronomical Algorithms) and truncated series
/// from VSOP87 / ELP2000. Permissive MIT-compatible license.
/// Zero Swiss Ephemeris AGPL dependencies.
class AstronomyEngine {
  static const double degToRad = math.pi / 180.0;
  static const double radToDeg = 180.0 / math.pi;

  /// Standard astronomical refraction (34') + solar semidiameter (16') = 50' = 0.8333 deg
  static const double standardSolarDepression = 0.8333333333333334;

  /// Convert DateTime to Julian Day Number (Universal Time)
  static double toJulianDay(DateTime timeUtc) {
    int year = timeUtc.year;
    int month = timeUtc.month;
    final double day = timeUtc.day +
        timeUtc.hour / 24.0 +
        timeUtc.minute / 1440.0 +
        timeUtc.second / 86400.0 +
        timeUtc.millisecond / 86400000.0;

    if (month <= 2) {
      year -= 1;
      month += 12;
    }

    final int a = (year / 100).floor();
    final int b = 2 - a + (a / 4).floor();

    return (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day +
        b -
        1524.5;
  }

  /// Convert Julian Day back to DateTime (UTC)
  static DateTime fromJulianDay(double jd) {
    final double z = (jd + 0.5).floorToDouble();
    final double f = (jd + 0.5) - z;

    double a = z;
    if (z >= 2299161) {
      final double alpha = ((z - 1867216.25) / 36524.25).floorToDouble();
      a = z + 1 + alpha - (alpha / 4).floorToDouble();
    }

    final double b = a + 1524;
    final double c = ((b - 122.1) / 365.25).floorToDouble();
    final double d = (365.25 * c).floorToDouble();
    final double e = ((b - d) / 30.6001).floorToDouble();

    final double dayWithFraction = b - d - (30.6001 * e).floorToDouble() + f;
    final int day = dayWithFraction.floor();
    final int month = (e < 14) ? (e - 1).toInt() : (e - 13).toInt();
    final int year = (month > 2) ? (c - 4716).toInt() : (c - 4715).toInt();

    final double dayFraction = dayWithFraction - day;
    final double totalSeconds = dayFraction * 86400.0;
    final int hour = (totalSeconds / 3600).floor();
    final int minute = ((totalSeconds % 3600) / 60).floor();
    final int second = (totalSeconds % 60).floor();
    final int millisecond = (((totalSeconds % 60) - second) * 1000).round();

    return DateTime.utc(year, month, day, hour, minute, second, millisecond);
  }

  /// Julian centuries from J2000.0
  static double julianCenturies(double jd) {
    return (jd - 2451545.0) / 36525.0;
  }

  /// Normalize angle to [0, 360)
  static double normalizeDegrees(double deg) {
    double result = deg % 360.0;
    if (result < 0) result += 360.0;
    return result;
  }

  /// Mean Obliquity of the Ecliptic (Meeus Ch. 22)
  static double obliquityOfEcliptic(double t) {
    return 23.4392911 -
        (46.8150 * t - 0.00059 * t * t + 0.001813 * t * t * t) / 3600.0;
  }

  /// High precision Lahiri (Chitra Paksha) Ayanamsa in degrees
  /// Standard Lahiri Ayanamsa on 2000-01-01 12:00 UTC = 23° 51' 25.53" = 23.857092°
  static double lahiriAyanamsa(double jd) {
    final double t = julianCenturies(jd);
    // Standard IAU precession rate ~ 50.29" per year
    return 23.8570917 + 1.39694 * t - 0.000308 * t * t;
  }

  /// Apparent Geocentric Solar Ecliptic Longitude (Meeus Ch. 25)
  static double sunGeometricLongitude(double jd) {
    final double t = julianCenturies(jd);
    final double m = normalizeDegrees(
        357.52911 + 35999.05029 * t - 0.0001537 * t * t);
    final double mRad = m * degToRad;

    final double c = (1.914602 - 0.004817 * t - 0.000014 * t * t) *
            math.sin(mRad) +
        (0.019993 - 0.000101 * t) * math.sin(2 * mRad) +
        0.000289 * math.sin(3 * mRad);

    final double l0 = normalizeDegrees(
        280.46646 + 36000.76983 * t + 0.0003032 * t * t);
    final double trueLongitude = normalizeDegrees(l0 + c);

    // Apparent longitude with nutation and aberration
    final double omega = 125.04 - 1934.136 * t;
    final double lambda = trueLongitude -
        0.00569 -
        0.00478 * math.sin(omega * degToRad);

    return normalizeDegrees(lambda);
  }

  /// Apparent Geocentric Lunar Ecliptic Longitude (Meeus Ch. 47)
  static double moonGeometricLongitude(double jd) {
    final double t = julianCenturies(jd);

    // Fundamental arguments of Moon's motion
    final double lp = normalizeDegrees(
        218.3164477 + 481267.88123421 * t - 0.0015786 * t * t + t * t * t / 538841.0);
    final double d = normalizeDegrees(
        297.8501921 + 445267.1114034 * t - 0.0018819 * t * t + t * t * t / 545868.0);
    final double m = normalizeDegrees(
        357.5291092 + 35999.0502909 * t - 0.0001536 * t * t + t * t * t / 24490000.0);
    final double mp = normalizeDegrees(
        134.9633964 + 477198.8675055 * t + 0.0087414 * t * t + t * t * t / 69699.0);
    final double f = normalizeDegrees(
        93.2720950 + 483202.0175233 * t - 0.0036539 * t * t - t * t * t / 3526000.0);

    // Periodic terms for Lunar Longitude
    double sigmaL = 0.0;
    sigmaL += 6.288774 * math.sin(mp * degToRad);
    sigmaL += 1.274027 * math.sin((2 * d - mp) * degToRad);
    sigmaL += 0.658314 * math.sin(2 * d * degToRad);
    sigmaL += 0.213618 * math.sin(2 * mp * degToRad);
    sigmaL -= 0.185116 * math.sin(m * degToRad);
    sigmaL -= 0.114332 * math.sin(2 * f * degToRad);
    sigmaL += 0.058793 * math.sin((2 * d - 2 * mp) * degToRad);
    sigmaL += 0.057066 * math.sin((2 * d - m - mp) * degToRad);
    sigmaL += 0.053322 * math.sin((2 * d + mp) * degToRad);
    sigmaL += 0.045758 * math.sin((2 * d - m) * degToRad);
    sigmaL -= 0.040923 * math.sin((m - mp) * degToRad);
    sigmaL -= 0.034720 * math.sin(d * degToRad);
    sigmaL -= 0.030383 * math.sin((m + mp) * degToRad);
    sigmaL += 0.015327 * math.sin((2 * d - 2 * f) * degToRad);
    sigmaL -= 0.012528 * math.sin((2 * d + m - mp) * degToRad);
    sigmaL += 0.010980 * math.sin((2 * f - mp) * degToRad);
    sigmaL += 0.010675 * math.sin((4 * d - mp) * degToRad);
    sigmaL += 0.010034 * math.sin(3 * mp * degToRad);
    sigmaL += 0.008548 * math.sin((4 * d - 2 * mp) * degToRad);
    sigmaL -= 0.007888 * math.sin((2 * d + m) * degToRad);
    sigmaL -= 0.006766 * math.sin((2 * d - 2 * m - mp) * degToRad);
    sigmaL -= 0.005163 * math.sin((d - mp) * degToRad);
    sigmaL += 0.004987 * math.sin((d + m) * degToRad);
    sigmaL += 0.004036 * math.sin((2 * d - m + mp) * degToRad);
    sigmaL -= 0.003994 * math.sin((2 * d + 2 * mp) * degToRad);
    sigmaL += 0.003861 * math.sin(4 * d * degToRad);
    sigmaL += 0.003665 * math.sin((2 * d - 3 * mp) * degToRad);
    sigmaL -= 0.002689 * math.sin((m - 2 * mp) * degToRad);
    sigmaL -= 0.002602 * math.sin((2 * d - m + 2 * mp) * degToRad);
    sigmaL += 0.002390 * math.sin((2 * d - m - 2 * mp) * degToRad);
    sigmaL -= 0.002348 * math.sin((d + mp) * degToRad);
    sigmaL += 0.002236 * math.sin((2 * d - 2 * m) * degToRad);
    sigmaL -= 0.002120 * math.sin((2 * mp + m) * degToRad);
    sigmaL -= 0.002069 * math.sin((2 * m + mp) * degToRad);
    sigmaL += 0.002048 * math.sin((2 * d - 2 * mp + m) * degToRad);
    sigmaL -= 0.001773 * math.sin((2 * d + mp - m) * degToRad);
    sigmaL -= 0.001595 * math.sin((2 * d + 2 * f) * degToRad);
    sigmaL += 0.001215 * math.sin((4 * d - m - mp) * degToRad);
    sigmaL -= 0.001110 * math.sin((2 * m + 2 * f) * degToRad);
    sigmaL += 0.000892 * math.sin((mp - 2 * f) * degToRad);
    sigmaL -= 0.000811 * math.sin((2 * d + m + mp) * degToRad);
    sigmaL += 0.000761 * math.sin((4 * d - 3 * mp) * degToRad);

    final double lambda = lp + sigmaL;
    return normalizeDegrees(lambda);
  }

  /// Sidereal Solar Longitude using Lahiri Ayanamsa
  static double sunSiderealLongitude(double jd) {
    return normalizeDegrees(sunGeometricLongitude(jd) - lahiriAyanamsa(jd));
  }

  /// Sidereal Lunar Longitude using Lahiri Ayanamsa
  static double moonSiderealLongitude(double jd) {
    return normalizeDegrees(moonGeometricLongitude(jd) - lahiriAyanamsa(jd));
  }

  /// Greenwich Mean Sidereal Time in degrees
  static double gmst(double jd) {
    final double t = julianCenturies(jd);
    double theta = 280.46061837 +
        360.98564736629 * (jd - 2451545.0) +
        0.000387933 * t * t -
        (t * t * t) / 38710000.0;
    return normalizeDegrees(theta);
  }

  /// Local Sidereal Time in degrees
  static double lst(double jd, double longitudeDeg) {
    return normalizeDegrees(gmst(jd) + longitudeDeg);
  }

  /// Solar Declination in radians
  static double solarDeclination(double jd) {
    final double lambdaRad = sunGeometricLongitude(jd) * degToRad;
    final double epsRad = obliquityOfEcliptic(julianCenturies(jd)) * degToRad;
    return math.asin(math.sin(epsRad) * math.sin(lambdaRad));
  }

  /// Solar Right Ascension in degrees
  static double solarRightAscension(double jd) {
    final double lambdaRad = sunGeometricLongitude(jd) * degToRad;
    final double epsRad = obliquityOfEcliptic(julianCenturies(jd)) * degToRad;
    final double y = math.cos(epsRad) * math.sin(lambdaRad);
    final double x = math.cos(lambdaRad);
    return normalizeDegrees(math.atan2(y, x) * radToDeg);
  }

  /// Calculate Astronomical Sunrise, Sunset, and Solar Noon for a given local date and location.
  /// Explicitly labelled "Astronomical Sunrise" and "Astronomical Sunset" per requirement 53A.5.
  static ({DateTime sunrise, DateTime sunset, DateTime solarNoon})
      calculateSunRiseSet({
    required DateTime localDate,
    required double latitude,
    required double longitude,
    required double timezoneHours,
  }) {
    final DateTime noonUtc = DateTime.utc(
      localDate.year,
      localDate.month,
      localDate.day,
      12 - timezoneHours.floor(),
      ((12 - timezoneHours - (12 - timezoneHours.floor())) * 60).round(),
    );

    double jdNoon = toJulianDay(noonUtc);

    // Iterative solver for Solar Noon
    double ra = solarRightAscension(jdNoon);
    double siderealTimeNoon = lst(jdNoon, longitude);
    double deltaHour = (ra - siderealTimeNoon) / 360.0;
    while (deltaHour > 0.5) deltaHour -= 1.0;
    while (deltaHour < -0.5) deltaHour += 1.0;

    double jdSolarNoon = jdNoon + deltaHour;
    DateTime solarNoonUtc = fromJulianDay(jdSolarNoon);
    DateTime solarNoonLocal = solarNoonUtc.add(
        Duration(minutes: (timezoneHours * 60).round()));

    // Hour angle for sunrise / sunset with standard depression (90° 50' = 90.8333°)
    final double dec = solarDeclination(jdSolarNoon);
    final double latRad = latitude * degToRad;
    final double z0Rad = (90.0 + standardSolarDepression) * degToRad;

    final double cosH =
        (math.cos(z0Rad) - math.sin(latRad) * math.sin(dec)) /
            (math.cos(latRad) * math.cos(dec));

    double hDeg;
    if (cosH >= 1.0) {
      // Polar night
      hDeg = 0.0;
    } else if (cosH <= -1.0) {
      // Midnight sun
      hDeg = 180.0;
    } else {
      hDeg = math.acos(cosH) * radToDeg;
    }

    final double jdSunrise = jdSolarNoon - (hDeg / 360.0);
    final double jdSunset = jdSolarNoon + (hDeg / 360.0);

    DateTime sunriseLocal = fromJulianDay(jdSunrise).add(
        Duration(minutes: (timezoneHours * 60).round()));
    DateTime sunsetLocal = fromJulianDay(jdSunset).add(
        Duration(minutes: (timezoneHours * 60).round()));

    return (
      sunrise: sunriseLocal,
      sunset: sunsetLocal,
      solarNoon: solarNoonLocal,
    );
  }

  /// Approximate Moonrise and Moonset for given local date and location
  static ({DateTime? moonrise, DateTime? moonset}) calculateMoonRiseSet({
    required DateTime localDate,
    required double latitude,
    required double longitude,
    required double timezoneHours,
  }) {
    // Check altitudes at 1-hour intervals across the 24-hour day to find horizon crossings
    final DateTime startUtc = DateTime.utc(
      localDate.year,
      localDate.month,
      localDate.day,
      0,
      0,
    ).subtract(Duration(minutes: (timezoneHours * 60).round()));

    DateTime? riseTime;
    DateTime? setTime;

    double prevAlt = _moonAltitude(startUtc, latitude, longitude);

    for (int hour = 1; hour <= 24; hour++) {
      final DateTime currUtc = startUtc.add(Duration(hours: hour));
      final double currAlt = _moonAltitude(currUtc, latitude, longitude);

      if (prevAlt < 0.125 && currAlt >= 0.125 && riseTime == null) {
        // Moonrise crossing
        final double fraction = (0.125 - prevAlt) / (currAlt - prevAlt);
        final DateTime approxUtc = startUtc
            .add(Duration(minutes: ((hour - 1 + fraction) * 60).round()));
        riseTime = approxUtc.add(Duration(minutes: (timezoneHours * 60).round()));
      } else if (prevAlt >= 0.125 && currAlt < 0.125 && setTime == null) {
        // Moonset crossing
        final double fraction = (0.125 - prevAlt) / (currAlt - prevAlt);
        final DateTime approxUtc = startUtc
            .add(Duration(minutes: ((hour - 1 + fraction) * 60).round()));
        setTime = approxUtc.add(Duration(minutes: (timezoneHours * 60).round()));
      }

      prevAlt = currAlt;
    }

    return (moonrise: riseTime, moonset: setTime);
  }

  static double _moonAltitude(DateTime utc, double lat, double lon) {
    final double jd = toJulianDay(utc);
    final double moonLam = moonGeometricLongitude(jd) * degToRad;
    final double eps = obliquityOfEcliptic(julianCenturies(jd)) * degToRad;

    final double sinDec = math.sin(eps) * math.sin(moonLam);
    final double dec = math.asin(sinDec);
    final double ra = normalizeDegrees(
        math.atan2(math.cos(eps) * math.sin(moonLam), math.cos(moonLam)) * radToDeg);

    final double ha = normalizeDegrees(lst(jd, lon) - ra) * degToRad;
    final double latRad = lat * degToRad;

    final double sinAlt = math.sin(latRad) * math.sin(dec) +
        math.cos(latRad) * math.cos(dec) * math.cos(ha);
    return math.asin(sinAlt) * radToDeg;
  }

  /// Calculates Tithi at any given UTC instant.
  /// Returns tithi index: 1..30 (1-15 Shukla Pratipada to Purnima, 16-30 Krishna Pratipada to Amavasya)
  /// and progress fraction [0.0, 1.0).
  static ({int tithiNumber, double progress}) calculateTithi(DateTime utcTime) {
    final double jd = toJulianDay(utcTime);
    final double sunLon = sunGeometricLongitude(jd);
    final double moonLon = moonGeometricLongitude(jd);

    double diff = normalizeDegrees(moonLon - sunLon);
    int tithiNum = (diff / 12.0).floor() + 1;
    if (tithiNum > 30) tithiNum = 30;
    double progress = (diff % 12.0) / 12.0;

    return (tithiNumber: tithiNum, progress: progress);
  }

  /// Calculates Nakshatra at any given UTC instant.
  /// Returns nakshatra index: 1..27 (Ashwini to Revati) and progress fraction [0.0, 1.0).
  static ({int nakshatraNumber, double progress}) calculateNakshatra(
      DateTime utcTime) {
    final double jd = toJulianDay(utcTime);
    final double moonSidereal = moonSiderealLongitude(jd);

    const double nakshatraSpan = 360.0 / 27.0; // 13° 20' = 13.333333°
    int nakshatraNum = (moonSidereal / nakshatraSpan).floor() + 1;
    if (nakshatraNum > 27) nakshatraNum = 27;
    double progress = (moonSidereal % nakshatraSpan) / nakshatraSpan;

    return (nakshatraNumber: nakshatraNum, progress: progress);
  }

  /// Calculates Yoga at any given UTC instant.
  /// Returns yoga index: 1..27 (Vishkambha to Vaidhriti) and progress fraction [0.0, 1.0).
  static ({int yogaNumber, double progress}) calculateYoga(DateTime utcTime) {
    final double jd = toJulianDay(utcTime);
    final double sunSid = sunSiderealLongitude(jd);
    final double moonSid = moonSiderealLongitude(jd);

    final double sum = normalizeDegrees(sunSid + moonSid);
    const double yogaSpan = 360.0 / 27.0;
    int yogaNum = (sum / yogaSpan).floor() + 1;
    if (yogaNum > 27) yogaNum = 27;
    double progress = (sum % yogaSpan) / yogaSpan;

    return (yogaNumber: yogaNum, progress: progress);
  }

  /// Calculates Karana at any given UTC instant.
  /// Half-Tithi segment: 1..60
  static ({int karanaIndex, String name}) calculateKarana(DateTime utcTime) {
    final double jd = toJulianDay(utcTime);
    final double diff = normalizeDegrees(
        moonGeometricLongitude(jd) - sunGeometricLongitude(jd));
    int halfTithi = (diff / 6.0).floor(); // 0..59

    String name;
    if (halfTithi == 0) {
      name = 'Kintughna';
    } else if (halfTithi >= 57) {
      if (halfTithi == 57) name = 'Shakuni';
      else if (halfTithi == 58) name = 'Chatushpada';
      else name = 'Naga';
    } else {
      // 7 repeating karanas
      final List<String> repeating = [
        'Bava',
        'Balava',
        'Kaulava',
        'Taitila',
        'Gara',
        'Vanija',
        'Vishti'
      ];
      name = repeating[(halfTithi - 1) % 7];
    }

    return (karanaIndex: halfTithi, name: name);
  }

  /// Finds the exact transition (end time) of the current Tithi using root finding.
  static DateTime findTithiEndTime(DateTime fromUtc, double timezoneHours) {
    double jdStart = toJulianDay(fromUtc);
    double initialDiff = normalizeDegrees(
        moonGeometricLongitude(jdStart) - sunGeometricLongitude(jdStart));
    int targetTithiIndex = (initialDiff / 12.0).floor() + 1;
    double targetAngle = targetTithiIndex * 12.0;

    // Binary search over next 30 hours
    double low = jdStart;
    double high = jdStart + (30.0 / 24.0);

    for (int iter = 0; iter < 24; iter++) {
      double mid = (low + high) / 2.0;
      double diff = normalizeDegrees(
          moonGeometricLongitude(mid) - sunGeometricLongitude(mid));
      if (targetTithiIndex == 30 && diff < 12.0) {
        diff += 360.0;
      }
      if (diff >= targetAngle) {
        high = mid;
      } else {
        low = mid;
      }
    }

    DateTime endUtc = fromJulianDay(high);
    return endUtc.add(Duration(minutes: (timezoneHours * 60).round()));
  }

  /// Finds the exact transition (end time) of the current Nakshatra using root finding.
  static DateTime findNakshatraEndTime(DateTime fromUtc, double timezoneHours) {
    double jdStart = toJulianDay(fromUtc);
    double initialMoon = moonSiderealLongitude(jdStart);
    const double span = 360.0 / 27.0;
    int targetIndex = (initialMoon / span).floor() + 1;
    double targetAngle = targetIndex * span;

    double low = jdStart;
    double high = jdStart + (30.0 / 24.0);

    for (int iter = 0; iter < 24; iter++) {
      double mid = (low + high) / 2.0;
      double moon = moonSiderealLongitude(mid);
      if (targetIndex == 27 && moon < span) {
        moon += 360.0;
      }
      if (moon >= targetAngle) {
        high = mid;
      } else {
        low = mid;
      }
    }

    DateTime endUtc = fromJulianDay(high);
    return endUtc.add(Duration(minutes: (timezoneHours * 60).round()));
  }

  /// Lunar phase percentage [0..100]
  static double lunarPhasePercentage(DateTime utcTime) {
    final double jd = toJulianDay(utcTime);
    final double diff = normalizeDegrees(
        moonGeometricLongitude(jd) - sunGeometricLongitude(jd));
    // Phase angle
    final double phi = (180.0 - diff).abs();
    final double k = (1.0 + math.cos(phi * degToRad)) / 2.0;
    return k * 100.0;
  }

  /// Calculates the canonical Amanta Lunar Month index (0: Chaitra .. 11: Phalguna).
  /// In Indian astronomy (Surya Siddhanta), a lunar month is defined from one New Moon (conjunction)
  /// to the next, and is named by the Solar Rashi where the Sun resides at the moment of that New Moon:
  /// (Solar Rashi at New Moon + 1) % 12 (0: Mesha -> Vaishakha, ..., 11: Meena -> Chaitra).
  static int calculateAmantaMonthIndex(DateTime utcTime) {
    final double jd = toJulianDay(utcTime);
    final double sunLon = sunGeometricLongitude(jd);
    final double moonLon = moonGeometricLongitude(jd);

    double diff = normalizeDegrees(moonLon - sunLon);
    double daysSinceNewMoon = (diff / 360.0) * 29.530588;
    double jdNewMoon = jd - daysSinceNewMoon;

    for (int i = 0; i < 3; i++) {
      double s = sunGeometricLongitude(jdNewMoon);
      double m = moonGeometricLongitude(jdNewMoon);
      double d = normalizeDegrees(m - s);
      if (d > 180.0) d -= 360.0;
      jdNewMoon -= d / (360.0 / 29.530588);
    }

    final double sunSidAtNewMoon = sunSiderealLongitude(jdNewMoon);
    final int solarRashiAtNewMoon = (sunSidAtNewMoon / 30.0).floor() % 12;
    return (solarRashiAtNewMoon + 1) % 12;
  }
}
