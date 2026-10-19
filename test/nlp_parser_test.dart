import 'package:flutter_test/flutter_test.dart';
import '../lib/domain/models/location_info.dart';
import '../lib/services/nlp/nlp_query_parser.dart';
import '../lib/services/voice/voice_service.dart';

void main() {
  test('NLP Query Parser & Festival Tests', () {
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

  // Test 6: Hinglish vehicle purchase & today date test (Exact User Query!)
  print('\n--- Testing Hinglish & Colloquial Transliterations ---');
  final userQuery = NlpQueryParser.parse(
    query: 'aaj gaadi karid nei ka muhurt kab hai',
    defaultLocation: LocationInfo.ahmedabad,
  );
  assert(userQuery.intent == QueryIntentType.muhuratSearch);
  assert(userQuery.occasionId == 'vehicle_purchase', 'Expected vehicle_purchase but got ${userQuery.occasionId}');
  final today = DateTime.now();
  assert(userQuery.startDate.day == today.day && userQuery.startDate.month == today.month);
  print('✓ Test 6 Passed: Hinglish "aaj gaadi karid nei ka muhurt kab hai" parsed as occasion=${userQuery.occasionId}, date=${userQuery.startDate.day}/${userQuery.startDate.month}');

  // Test 7: Hinglish marriage tomorrow
  final q7 = NlpQueryParser.parse(
    query: 'kal shaadi ka muhurat kab hai',
    defaultLocation: LocationInfo.ahmedabad,
  );
  assert(q7.occasionId == 'marriage');
  final tomorrow = today.add(const Duration(days: 1));
  assert(q7.startDate.day == tomorrow.day);
  print('✓ Test 7 Passed: Hinglish "kal shaadi ka muhurat kab hai" parsed as marriage on tomorrow');

  // Test 8: Gyaras query
  final q8 = NlpQueryParser.parse(
    query: 'agila gyaras kab ba',
    defaultLocation: LocationInfo.varanasi,
  );
  assert(q8.intent == QueryIntentType.nextEkadashi);
  print('✓ Test 8 Passed: Bhojpuri Gyaras intent=${q8.intent.name}');

  // Test 9: Colloquial sunrise
  final q9 = NlpQueryParser.parse(
    query: 'suraj kab niklega',
    defaultLocation: LocationInfo.ahmedabad,
  );
  assert(q9.intent == QueryIntentType.sunrise);
  print('✓ Test 9 Passed: Colloquial sunrise intent=${q9.intent.name}');

  // Test 10: Festival Verification query (e.g., "10 october ko vijyadashmi hai?")
  final q10 = NlpQueryParser.parse(
    query: '10 october ko vijyadashmi hai?',
    defaultLocation: LocationInfo.ahmedabad,
  );
  assert(q10.intent == QueryIntentType.festivalVerification, 'Expected festivalVerification but got ${q10.intent}');
  assert(q10.festival?.key == 'dussehra', 'Expected festival dussehra but got ${q10.festival?.key}');
  assert(q10.targetDate?.month == 10 && q10.targetDate?.day == 10, 'Expected target date 10 Oct but got ${q10.targetDate}');
  print('✓ Test 10 Passed: "10 october ko vijyadashmi hai?" parsed as festivalVerification for dussehra on 10/10');

  // Test 11: Festival Date Inquiry (e.g., "dushera kab hai?")
  final q11 = NlpQueryParser.parse(
    query: 'dushera kab hai?',
    defaultLocation: LocationInfo.ahmedabad,
  );
  assert(q11.intent == QueryIntentType.festivalDate, 'Expected festivalDate but got ${q11.intent}');
  assert(q11.festival?.key == 'dussehra', 'Expected festival dussehra but got ${q11.festival?.key}');
  print('✓ Test 11 Passed: "dushera kab hai?" parsed as festivalDate for dussehra');

  // Test 12: Date Panchang query (e.g., "10 october ko kya hai?")
  final q12 = NlpQueryParser.parse(
    query: '10 october ko kya hai?',
    defaultLocation: LocationInfo.ahmedabad,
  );
  assert(q12.intent == QueryIntentType.datePanchang, 'Expected datePanchang but got ${q12.intent}');
  assert(q12.targetDate?.month == 10 && q12.targetDate?.day == 10);
  print('✓ Test 12 Passed: "10 october ko kya hai?" parsed as datePanchang for 10/10');

  // Test 13: Diwali date inquiry in Hindi
  final q13 = NlpQueryParser.parse(
    query: 'दीपावली कब है',
    defaultLocation: LocationInfo.ahmedabad,
  );
  assert(q13.intent == QueryIntentType.festivalDate);
  assert(q13.festival?.key == 'diwali');
  print('✓ Test 13 Passed: "दीपावली कब है" parsed as festivalDate for diwali');

  // Test 14: VoiceService end-to-end for festival verification "10 october ko vijyadashmi hai?"
  final resp14 = VoiceService.processVoiceQuery(
    query: '10 october ko vijyadashmi hai?',
    defaultLocation: LocationInfo.ahmedabad,
    voiceLanguageCode: 'hi',
  );
  assert(resp14.spokenText.contains('नहीं') || resp14.spokenText.contains('10 अक्टूबर'));
  assert(resp14.displayText.contains('21 अक्टूबर 2026'));
  print('✓ Test 14 Passed: VoiceService response for "10 october ko vijyadashmi hai?" ->\n${resp14.spokenText}');

  // Test 16: Navami query "नवमी कब है" (Exact User Query from Screenshot!)
  final q16 = NlpQueryParser.parse(
    query: 'नवमी कब है',
    defaultLocation: LocationInfo.vadodara,
  );
  assert(q16.intent == QueryIntentType.tithiSearch || q16.intent == QueryIntentType.festivalDate);
  print('✓ Test 16 Passed: "नवमी कब है" parsed as ${q16.intent.name}');

  // Test 17: VoiceService response for "नवमी कब है"
  final resp17 = VoiceService.processVoiceQuery(
    query: 'नवमी कब है',
    defaultLocation: LocationInfo.vadodara,
    voiceLanguageCode: 'hi',
  );
  print('✓ Test 17 Voice Response for "नवमी कब है":\n${resp17.spokenText}\n${resp17.displayText}');
  assert(resp17.spokenText.contains('नवमी'));
  assert(resp17.displayText.contains('नवमी'));

  // Test 18: Ashtami query "अष्टमी कब है"
  final resp18 = VoiceService.processVoiceQuery(
    query: 'अष्टमी कब है',
    defaultLocation: LocationInfo.vadodara,
    voiceLanguageCode: 'hi',
  );
  print('✓ Test 18 Voice Response for "अष्टमी कब है":\n${resp18.spokenText}');
  assert(resp18.spokenText.contains('अष्टमी'));

  // Test 19: Purnima query "पूर्णिमा कब है"
  final resp19 = VoiceService.processVoiceQuery(
    query: 'पूर्णिमा कब है',
    defaultLocation: LocationInfo.vadodara,
    voiceLanguageCode: 'hi',
  );
  print('✓ Test 19 Voice Response for "पूर्णिमा कब है":\n${resp19.spokenText}');
  assert(resp19.spokenText.contains('पूर्णिमा') || resp19.spokenText.contains('शरद पूर्णिमा'));

  // Test 20: Amavasya query "अमावस्या कब है"
  final resp20 = VoiceService.processVoiceQuery(
    query: 'अमावस्या कब है',
    defaultLocation: LocationInfo.vadodara,
    voiceLanguageCode: 'hi',
  );
  print('✓ Test 20 Voice Response for "अमावस्या कब है":\n${resp20.spokenText}');
  assert(resp20.spokenText.contains('अमावस्या') || resp20.spokenText.contains('दीपावली'));

  print('=== All NLP Query Parser & Context Tests Passed Successfully! ===\n');
  });
}
