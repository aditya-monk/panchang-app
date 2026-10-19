import 'package:flutter_test/flutter_test.dart';
import '../lib/domain/models/location_info.dart';
import '../lib/services/panchang/panchang_service.dart';

void main() {
  test('Accurate Hindu Calendar Festivals & Lunar Months Test', () {
    print('=== Running Hindu Calendar Accuracy Tests ===');

    // 1. Ganesh Chaturthi must be in September (Bhadrapada Shukla Chaturthi)
    final ganeshPanchang = PanchangService.calculatePanchang(
      date: DateTime(2026, 9, 15),
      location: LocationInfo.vadodara,
    );
    expect(ganeshPanchang.festivals.contains('Ganesh Chaturthi'), isTrue);
    expect(ganeshPanchang.lunarMonthName, equals('Bhadrapada'));
    print('✓ Ganesh Chaturthi verified on 15 Sept 2026 in Bhadrapada');

    // 2. October 10 must be Mahalaya / Sarva Pitru Amavasya (NOT Ganesh Chaturthi!)
    final pitruPanchang = PanchangService.calculatePanchang(
      date: DateTime(2026, 10, 10),
      location: LocationInfo.vadodara,
    );
    expect(pitruPanchang.festivals.any((f) => f.contains('Sarva Pitru Amavasya')), isTrue);
    expect(pitruPanchang.tithiNumber, equals(30));
    print('✓ Sarva Pitru Amavasya verified on 10 Oct 2026');

    // 3. Shardiya Navratri begins on 11 October (Ashwin Shukla Pratipada)
    final navratriPanchang = PanchangService.calculatePanchang(
      date: DateTime(2026, 10, 11),
      location: LocationInfo.vadodara,
    );
    expect(navratriPanchang.festivals.any((f) => f.contains('Sharad Navratri')), isTrue);
    expect(navratriPanchang.lunarMonthName, equals('Ashwin'));
    expect(navratriPanchang.tithiNumber, equals(1));
    print('✓ Shardiya Navratri begins verified on 11 Oct 2026 in Ashwin');

    // 4. Dussehra / Vijayadashami on 21 October 2026
    final dussehraPanchang = PanchangService.calculatePanchang(
      date: DateTime(2026, 10, 21),
      location: LocationInfo.vadodara,
    );
    expect(dussehraPanchang.festivals.any((f) => f.contains('Vijayadashami / Dussehra')), isTrue);
    expect(dussehraPanchang.lunarMonthName, equals('Ashwin'));
    print('✓ Vijayadashami / Dussehra verified on 21 Oct 2026 in Ashwin');

    // 5. Sharad Purnima on 26 October 2026
    final sharadPanchang = PanchangService.calculatePanchang(
      date: DateTime(2026, 10, 26),
      location: LocationInfo.vadodara,
    );
    expect(sharadPanchang.festivals.any((f) => f.contains('Sharad Purnima')), isTrue);
    print('✓ Sharad Purnima verified on 26 Oct 2026');

    // 6. Karwa Chauth on 29 October 2026
    final karwaPanchang = PanchangService.calculatePanchang(
      date: DateTime(2026, 10, 29),
      location: LocationInfo.vadodara,
    );
    expect(karwaPanchang.festivals.contains('Karwa Chauth'), isTrue);
    print('✓ Karwa Chauth verified on 29 Oct 2026');

    // 7. Dhanteras on 7 November 2026
    final dhanterasPanchang = PanchangService.calculatePanchang(
      date: DateTime(2026, 11, 7),
      location: LocationInfo.vadodara,
    );
    expect(dhanterasPanchang.festivals.any((f) => f.contains('Dhanteras')), isTrue);
    print('✓ Dhanteras verified on 7 Nov 2026');

    // 8. Diwali on 9 November 2026
    final diwaliPanchang = PanchangService.calculatePanchang(
      date: DateTime(2026, 11, 9),
      location: LocationInfo.vadodara,
    );
    expect(diwaliPanchang.festivals.any((f) => f.contains('Diwali')), isTrue);
    print('✓ Diwali / Lakshmi Puja verified on 9 Nov 2026');

    // 9. Govardhan Puja on 10 November 2026 in Kartika
    final govardhanPanchang = PanchangService.calculatePanchang(
      date: DateTime(2026, 11, 10),
      location: LocationInfo.vadodara,
    );
    expect(govardhanPanchang.festivals.any((f) => f.contains('Govardhan Puja')), isTrue);
    expect(govardhanPanchang.lunarMonthName, equals('Kartika'));
    print('✓ Govardhan Puja verified on 10 Nov 2026 in Kartika');

    // 10. Chhath Puja on 15 November 2026 in Kartika
    final chhathPanchang = PanchangService.calculatePanchang(
      date: DateTime(2026, 11, 15),
      location: LocationInfo.vadodara,
    );
    expect(chhathPanchang.festivals.contains('Chhath Puja'), isTrue);
    expect(chhathPanchang.lunarMonthName, equals('Kartika'));
    print('✓ Chhath Puja verified on 15 Nov 2026 in Kartika');

    print('=== All Calendar Accuracy Tests Passed Successfully! ===\n');
  });
}
