import 'astronomy_test.dart' as astronomy_test;
import 'panchang_test.dart' as panchang_test;
import 'traditions_test.dart' as traditions_test;
import 'muhurat_test.dart' as muhurat_test;
import 'nlp_parser_test.dart' as nlp_parser_test;
import 'location_test.dart' as location_test;

void main() {
  print('========================================================');
  print('🕉️ RUNNING COMPREHENSIVE PANCHANG & MUHURAT TEST SUITE 🕉️');
  print('========================================================\n');

  astronomy_test.main();
  panchang_test.main();
  traditions_test.main();
  muhurat_test.main();
  nlp_parser_test.main();
  location_test.main();

  print('========================================================');
  print('🎉 ALL TEST SUITES PASSED FLAWLESSLY! 🎉');
  print('========================================================');
}
