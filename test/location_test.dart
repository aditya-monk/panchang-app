import '../lib/data/cities.dart';
import '../lib/services/location/location_service.dart';

void main() {
  print('=== Running Location Engine & City Database Tests ===');

  // Test 1: Bundled city search
  final ahmedabadList = CityDatabase.search('Ahmedabad');
  assert(ahmedabadList.isNotEmpty);
  assert(ahmedabadList.first.name == 'Ahmedabad');
  print('✓ Test 1 Passed: Found ${ahmedabadList.first.displayName}');

  // Test 2: Search by Hindi alias
  final kashiList = CityDatabase.search('काशी');
  assert(kashiList.isNotEmpty);
  assert(kashiList.first.name == 'Varanasi');
  print('✓ Test 2 Passed: Found ${kashiList.first.name} via alias "काशी"');

  // Test 3: Search by Gujarati alias
  final amdavadList = CityDatabase.search('અમદાવાદ');
  assert(amdavadList.isNotEmpty);
  assert(amdavadList.first.name == 'Ahmedabad');
  print('✓ Test 3 Passed: Found ${amdavadList.first.name} via alias "અમદાવાદ"');

  // Test 4: Event Location Override (Section 45)
  // Current location is Mumbai, but user asks for Ahmedabad
  LocationService.setCurrentLocation(CityDatabase.findByName('Mumbai')!);
  assert(LocationService.currentLocation.name == 'Mumbai');

  // Before setting event location, activeMuhuratLocation is current location
  assert(LocationService.activeMuhuratLocation.name == 'Mumbai');

  // Set event location to Ahmedabad
  LocationService.setEventLocation(CityDatabase.findByName('Ahmedabad')!);
  assert(LocationService.activeMuhuratLocation.name == 'Ahmedabad',
      'Event location MUST override current location for Muhurat calculations');
  print('✓ Test 4 Passed: Event Location (${LocationService.activeMuhuratLocation.name}) correctly overrides Current Location (${LocationService.currentLocation.name})');

  print('=== All Location Engine Tests Passed Successfully! ===\n');
}
