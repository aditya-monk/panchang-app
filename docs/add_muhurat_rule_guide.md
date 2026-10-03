# How to Add a New Muhurat Occasion Rule

All Muhurat calculations in the application are strictly data-driven using the `MuhuratRuleConfig` schema (Section 50). Do not write custom UI logic for new occasions.

---

## Step 1: Open `lib/data/muhurat_rules.dart`

Open [`lib/data/muhurat_rules.dart`](file:///c:/Users/ADITYA%20DWIVEDI/Desktop/Projects/Panchang%20App/lib/data/muhurat_rules.dart).

## Step 2: Define the `MuhuratRuleConfig`

Add a new `MuhuratRuleConfig` to `MuhuratRuleDatabase.allRules`:

```dart
// Example: Adding "Gold Purchase / Pushya Nakshatra" Muhurat
MuhuratRuleConfig(
  id: 'gold_purchase',
  title: 'Gold Purchase',
  icon: '🪙',
  description: 'Purchasing gold, jewelry, or precious assets. Highly auspicious under Pushya and Shubha Choghadiya.',
  allowedWeekdays: [1, 3, 4, 5], // Mon, Wed, Thu, Fri
  excludedWeekdays: [2, 6],       // Tue, Sat avoided
  allowedTithis: [2, 3, 5, 7, 10, 11, 13, 15],
  excludedTithis: [4, 9, 14, 19, 24, 29, 30], // Avoid Rikta & Amavasya
  allowedNakshatras: [1, 4, 8, 13, 14, 15, 27], // Pushya (8), Rohini (4), Hasta (13), etc.
  preferredChoghadiya: [
    ChoghadiyaType.amrit,
    ChoghadiyaType.shubh,
    ChoghadiyaType.labh,
  ],
  minimumDurationMinutes: 30,
),
```

## Step 3: Register NLP Query Mapping in `lib/services/nlp/nlp_query_parser.dart`

Add keywords for your occasion in `_extractOccasion`:

```dart
if (q.contains('gold') ||
    q.contains('jewelry') ||
    q.contains('सोना') ||
    q.contains('સોનું')) {
  return 'gold_purchase';
}
```

## Step 4: Verify with Unit Tests

Run the test suite to ensure the new rule evaluates and generates suitable windows:
```bash
dart run test/run_all_tests.dart
```
