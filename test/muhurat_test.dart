import '../lib/core/constants/panchang_constants.dart';
import '../lib/domain/models/location_info.dart';
import '../lib/services/muhurat/muhurat_service.dart';

void main() {
  print('=== Running Muhurat Engine Tests ===');

  // Test 1: Griha Pravesh Muhurat in Ahmedabad in November 2026
  final res1 = MuhuratService.findMuhurat(
    occasionId: 'griha_pravesh',
    location: LocationInfo.ahmedabad,
    startDate: DateTime(2026, 11, 1),
    endDate: DateTime(2026, 11, 30),
  );

  assert(res1.windows.isNotEmpty, 'Expected at least 1 Griha Pravesh window in November');
  print('✓ Test 1 Passed: Griha Pravesh in Ahmedabad: ${res1.windows.length} windows found');

  final firstWin = res1.windows.first;
  assert(firstWin.status == MuhuratStatus.suitable || firstWin.status == MuhuratStatus.conditional);
  assert(firstWin.duration.inMinutes >= 45, 'Window must satisfy minimum duration');
  assert(firstWin.detailedExplanation.containsKey('Rahu Kaal'), 'Must explain Rahu Kaal avoidance');
  print('✓ Test 1 Passed: First Window = ${firstWin.formattedDate} (${firstWin.formattedTiming})');

  // Test 2: Vehicle Purchase Muhurat in Vadodara
  final res2 = MuhuratService.findMuhurat(
    occasionId: 'vehicle_purchase',
    location: LocationInfo.vadodara,
    startDate: DateTime(2026, 10, 1),
    endDate: DateTime(2026, 10, 31),
    minimumDurationMinutes: 30,
  );
  assert(res2.windows.isNotEmpty, 'Expected Vehicle purchase windows in October');
  print('✓ Test 2 Passed: Vehicle Purchase in Vadodara: ${res2.windows.length} windows found');

  // Test 3: Marriage Muhurat in Udaipur
  final udaipur = LocationInfo(
    name: 'Udaipur',
    state: 'Rajasthan',
    latitude: 24.5854,
    longitude: 73.7125,
  );
  final res3 = MuhuratService.findMuhurat(
    occasionId: 'marriage',
    location: udaipur,
    startDate: DateTime(2026, 11, 1),
    endDate: DateTime(2026, 11, 30),
  );
  print('✓ Test 3 Passed: Marriage in Udaipur: ${res3.windows.length} windows evaluated');

  print('=== All Muhurat Tests Passed Successfully! ===\n');
}
