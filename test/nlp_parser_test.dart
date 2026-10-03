import '../lib/core/constants/panchang_constants.dart';
import '../lib/domain/models/location_info.dart';
import '../lib/services/nlp/nlp_query_parser.dart';

void main() {
  print('=== Running NLP Query Parser & Conversational Context Tests ===');

  // Test 1: English Griha Pravesh query
  final q1 = NlpQueryParser.parse(
    query: 'When is the Griha Pravesh Muhurat in Ahmedabad next month?',
    defaultLocation: LocationInfo.vadodara,
  );
  assert(q1.intent == QueryIntentType.muhuratSearch);
  assert(q1.occasionId == 'griha_pravesh');
  assert(q1.location.name == 'Ahmedabad');
  print('✓ Test 1 Passed: English parse occasion=${q1.occasionId}, location=${q1.location.name}');

  // Test 2: Hindi Ekadashi query
  final q2 = NlpQueryParser.parse(
    query: 'अगली एकादशी कब है?',
    defaultLocation: LocationInfo.vadodara,
  );
  assert(q2.intent == QueryIntentType.nextEkadashi);
  print('✓ Test 2 Passed: Hindi parse intent=${q2.intent.name}');

  // Test 3: Gujarati query
  final q3 = NlpQueryParser.parse(
    query: 'આવતા મહિને અમદાવાદમાં ગૃહ પ્રવેશનું મુહૂર્ત ક્યારે છે?',
    defaultLocation: LocationInfo.vadodara,
  );
  assert(q3.occasionId == 'griha_pravesh');
  assert(q3.location.name == 'Ahmedabad');
  print('✓ Test 3 Passed: Gujarati parse occasion=${q3.occasionId}, location=${q3.location.name}');

  // Test 4: Bhojpuri query
  final q4 = NlpQueryParser.parse(
    query: 'अगिला एकादशी कब बा?',
    defaultLocation: LocationInfo.varanasi,
  );
  assert(q4.intent == QueryIntentType.nextEkadashi);
  print('✓ Test 4 Passed: Bhojpuri parse intent=${q4.intent.name}');

  // Test 5: Conversational Multi-turn Context Retention (Section 26 & 68)
  print('\n--- Testing Multi-turn Conversational Context ---');
  // Turn 1
  final turn1 = NlpQueryParser.parse(
    query: 'Griha Pravesh Muhurat in Ahmedabad in November',
    defaultLocation: LocationInfo.vadodara,
  );
  assert(turn1.occasionId == 'griha_pravesh');
  assert(turn1.location.name == 'Ahmedabad');
  assert(turn1.startDate.month == 11);
  print('Turn 1: occasion=${turn1.occasionId}, location=${turn1.location.name}, month=${turn1.startDate.month}');

  // Turn 2: "What about December?" -> inherits occasion and location, updates month to December
  final turn2 = NlpQueryParser.parse(
    query: 'What about December?',
    defaultLocation: LocationInfo.vadodara,
    currentContext: turn1.updatedContext,
  );
  assert(turn2.occasionId == 'griha_pravesh', 'Should inherit griha_pravesh');
  assert(turn2.location.name == 'Ahmedabad', 'Should inherit Ahmedabad');
  assert(turn2.startDate.month == 12, 'Month should update to December');
  print('Turn 2 ("What about December?"): occasion=${turn2.occasionId}, location=${turn2.location.name}, month=${turn2.startDate.month}');

  // Turn 3: "Only weekends" -> inherits occasion, location, month; updates weekdays
  final turn3 = NlpQueryParser.parse(
    query: 'Only weekends',
    defaultLocation: LocationInfo.vadodara,
    currentContext: turn2.updatedContext,
  );
  assert(turn3.occasionId == 'griha_pravesh');
  assert(turn3.location.name == 'Ahmedabad');
  assert(turn3.preferredWeekdays != null && turn3.preferredWeekdays!.contains(6));
  print('Turn 3 ("Only weekends"): weekdays=${turn3.preferredWeekdays}, location=${turn3.location.name}');

  // Turn 4: "What about Vadodara?" -> inherits occasion, month, weekdays; changes location only
  final turn4 = NlpQueryParser.parse(
    query: 'What about Vadodara?',
    defaultLocation: LocationInfo.ahmedabad,
    currentContext: turn3.updatedContext,
  );
  assert(turn4.occasionId == 'griha_pravesh');
  assert(turn4.location.name == 'Vadodara');
  assert(turn4.preferredWeekdays != null && turn4.preferredWeekdays!.contains(6));
  print('Turn 4 ("What about Vadodara?"): location changed to ${turn4.location.name}, occasion=${turn4.occasionId}');

  print('=== All NLP Query Parser & Context Tests Passed Successfully! ===\n');
}
