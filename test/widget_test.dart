import 'package:flutter_test/flutter_test.dart';
import 'package:panchang_app/main.dart';

void main() {
  testWidgets('PanchangApp smoke test displays sacred Hare Krishna splash', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PanchangApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Verify that the sacred Hare Krishna greeting is displayed
    expect(find.textContaining('हरे कृष्ण!'), findsWidgets);
  });
}
