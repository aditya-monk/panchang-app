import '../lib/services/astronomy/astronomy_engine.dart';

void main() {
  print('=== Running Astronomical Engine Tests ===');

  // Test 1: Julian Day conversion roundtrip
  final testUtc = DateTime.utc(2026, 10, 3, 6, 30, 0);
  final jd = AstronomyEngine.toJulianDay(testUtc);
  final backUtc = AstronomyEngine.fromJulianDay(jd);
  assert((backUtc.difference(testUtc).inSeconds).abs() <= 1,
      'Julian day roundtrip error: $testUtc vs $backUtc');
  print('✓ Test 1 Passed: Julian Day roundtrip ($jd)');

  // Test 2: Sun and Moon Longitude
  final sunLon = AstronomyEngine.sunGeometricLongitude(jd);
  final moonLon = AstronomyEngine.moonGeometricLongitude(jd);
  assert(sunLon >= 0.0 && sunLon < 360.0, 'Invalid sun longitude: $sunLon');
  assert(moonLon >= 0.0 && moonLon < 360.0, 'Invalid moon longitude: $moonLon');
  print('✓ Test 2 Passed: Sun Lon = ${sunLon.toStringAsFixed(2)}°, Moon Lon = ${moonLon.toStringAsFixed(2)}°');

  // Test 3: Lahiri Ayanamsa
  final ayanamsa = AstronomyEngine.lahiriAyanamsa(jd);
  assert(ayanamsa > 23.5 && ayanamsa < 24.5,
      'Ayanamsa for 2026 should be approx 24.2°, got: $ayanamsa');
  print('✓ Test 3 Passed: Lahiri Ayanamsa = ${ayanamsa.toStringAsFixed(4)}°');

  // Test 4: Astronomical Sunrise & Sunset for Vadodara (22.3072° N, 73.1812° E)
  final sunTimes = AstronomyEngine.calculateSunRiseSet(
    localDate: DateTime(2026, 10, 3),
    latitude: 22.3072,
    longitude: 73.1812,
    timezoneHours: 5.5,
  );
  // October sunrise in Vadodara is typically around 6:25 - 6:35 AM
  assert(sunTimes.sunrise.hour == 6, 'Expected sunrise around 6 AM, got: ${sunTimes.sunrise}');
  assert(sunTimes.sunset.hour == 18, 'Expected sunset around 6 PM, got: ${sunTimes.sunset}');
  print('✓ Test 4 Passed: Sunrise Vadodara = ${sunTimes.sunrise.hour}:${sunTimes.sunrise.minute}, Sunset = ${sunTimes.sunset.hour}:${sunTimes.sunset.minute}');

  // Test 5: Tithi & Nakshatra Calculations
  final tithi = AstronomyEngine.calculateTithi(testUtc);
  assert(tithi.tithiNumber >= 1 && tithi.tithiNumber <= 30, 'Invalid tithi: ${tithi.tithiNumber}');
  final nakshatra = AstronomyEngine.calculateNakshatra(testUtc);
  assert(nakshatra.nakshatraNumber >= 1 && nakshatra.nakshatraNumber <= 27, 'Invalid nakshatra: ${nakshatra.nakshatraNumber}');
  print('✓ Test 5 Passed: Tithi = ${tithi.tithiNumber}, Nakshatra = ${nakshatra.nakshatraNumber}');

  print('=== All Astronomical Tests Passed Successfully! ===\n');
}
