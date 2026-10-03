import '../lib/core/constants/panchang_constants.dart';
import '../lib/domain/models/location_info.dart';
import '../lib/services/ekadashi/ekadashi_service.dart';
import '../lib/services/traditions/tradition_engine.dart';

void main() {
  print('=== Running Traditions & Ekadashi Tests ===');

  // Test 1: Next Ekadashi search from 2026-10-03 in Vadodara
  final ekadashi = EkadashiService.getNextEkadashi(
    fromDate: DateTime(2026, 10, 3),
    location: LocationInfo.vadodara,
    tradition: CalendarTradition.standardHindu,
  );

  assert(ekadashi.name.contains('Ekadashi'), 'Expected Ekadashi name');
  assert(ekadashi.paranaEnd.isAfter(ekadashi.paranaStart), 'Parana end must be after start');
  print('✓ Test 1 Passed: Next Ekadashi = ${ekadashi.name} on ${ekadashi.formattedDate}');
  print('✓ Test 1 Passed: Parana Window = ${ekadashi.formattedParana}');

  // Test 2: Calendar comparison for all 3 profiles
  final comparisons = TraditionEngine.compareCalendars(
    date: DateTime(2026, 10, 3),
    location: LocationInfo.vadodara,
  );

  assert(comparisons.length == 3, 'Must have 3 comparison profiles');
  assert(comparisons[0].tradition == CalendarTradition.standardHindu);
  assert(comparisons[1].tradition == CalendarTradition.vaishnavaIskcon);
  assert(comparisons[2].tradition == CalendarTradition.gitaPressReference);
  print('✓ Test 2 Passed: Successfully generated side-by-side comparison for 3 traditions');

  // Test 3: Vaishnava fasting rule clarity
  final vaishnavaEkadashi = EkadashiService.getNextEkadashi(
    fromDate: DateTime(2026, 10, 3),
    location: LocationInfo.vadodara,
    tradition: CalendarTradition.vaishnavaIskcon,
  );
  assert(vaishnavaEkadashi.fastingRule.contains('Shuddha Ekadashi'), 'Expected Shuddha Ekadashi rule');
  assert(vaishnavaEkadashi.whyThisDate.contains('Arunodaya'), 'Expected Arunodaya reasoning in whyThisDate');
  print('✓ Test 3 Passed: Vaishnava Shuddha Ekadashi rule verified with Arunodaya explanation');

  print('=== All Tradition Tests Passed Successfully! ===\n');
}
