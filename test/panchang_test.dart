import '../lib/core/constants/panchang_constants.dart';
import '../lib/domain/models/location_info.dart';
import '../lib/services/panchang/panchang_service.dart';

void main() {
  print('=== Running Panchang Engine Tests ===');

  // Test 1: Complete Panchang for Vadodara on 3 October 2026
  final p = PanchangService.calculatePanchang(
    date: DateTime(2026, 10, 3),
    location: LocationInfo.vadodara,
  );

  assert(p.tithiNumber >= 1 && p.tithiNumber <= 30);
  assert(p.nakshatraNumber >= 1 && p.nakshatraNumber <= 27);
  assert(p.yogaNumber >= 1 && p.yogaNumber <= 27);
  assert(p.vara == 'Shanivara', 'Expected Shanivara (Saturday), got ${p.vara}');
  print('✓ Test 1 Passed: Vara = ${p.vara}, Tithi = ${p.tithiName}, Nakshatra = ${p.nakshatraName}');

  // Test 2: Inauspicious & Auspicious Periods
  assert(p.rahuKaalEnd.isAfter(p.rahuKaalStart));
  assert(p.abhijitMuhuratEnd.isAfter(p.abhijitMuhuratStart));
  assert(p.brahmaMuhuratEnd.isAfter(p.brahmaMuhuratStart));
  print('✓ Test 2 Passed: Rahu Kaal = ${p.rahuKaalStart.hour}:${p.rahuKaalStart.minute} - ${p.rahuKaalEnd.hour}:${p.rahuKaalEnd.minute}');
  print('✓ Test 2 Passed: Abhijit = ${p.abhijitMuhuratStart.hour}:${p.abhijitMuhuratStart.minute} - ${p.abhijitMuhuratEnd.hour}:${p.abhijitMuhuratEnd.minute}');

  // Test 3: Choghadiya lengths
  assert(p.dayChoghadiya.length == 8, 'Day Choghadiya must have 8 periods');
  assert(p.nightChoghadiya.length == 8, 'Night Choghadiya must have 8 periods');
  print('✓ Test 3 Passed: 8 Day and 8 Night Choghadiya periods correctly generated');

  // Test 4: Live NOW indicator
  final liveNow = p.getNowIndicator(p.abhijitMuhuratStart.add(const Duration(minutes: 5)));
  assert(liveNow != null && liveNow.isAuspicious, 'Expected Abhijit active indicator');
  print('✓ Test 4 Passed: Live Now Indicator = ${liveNow?.title}');

  print('=== All Panchang Tests Passed Successfully! ===\n');
}
