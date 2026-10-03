# How to Add a New Calendar Tradition Profile

The application cleanly decouples astronomical mathematics from tradition and religious interpretation (Section 53A.1).

---

## Step 1: Add Tradition to `CalendarTradition` Enum

Open [`lib/core/constants/panchang_constants.dart`](file:///c:/Users/ADITYA%20DWIVEDI/Desktop/Projects/Panchang%20App/lib/core/constants/panchang_constants.dart):

```dart
enum CalendarTradition {
  standardHindu,
  vaishnavaIskcon,
  gitaPressReference,
  madhvaTradition, // Example new tradition
}
```

---

## Step 2: Implement Specific Observance Rules

Open [`lib/services/traditions/tradition_engine.dart`](file:///c:/Users/ADITYA%20DWIVEDI/Desktop/Projects/Panchang%20App/lib/services/traditions/tradition_engine.dart):

1. Define how your tradition determines:
   - Arunodaya threshold (e.g. 96 min vs 72 min)
   - Udaya Tithi adherence
   - Fasting and Parana window calculations
2. Add your tradition to `TraditionEngine.compareCalendars`:
   ```dart
   _buildComparisonItem(
     tradition: CalendarTradition.madhvaTradition,
     title: 'Madhva Tradition',
     day: madhvaPanchang,
     explanation: 'Follows Dvaita Vedantic Smriti principles and unique Haridasa observances.',
   );
   ```

---

## Step 3: Register in UI Dropdowns & Settings

Add the new option to the dropdown in [`lib/presentation/screens/calendar/calendar_screen.dart`](file:///c:/Users/ADITYA%20DWIVEDI/Desktop/Projects/Panchang%20App/lib/presentation/screens/calendar/calendar_screen.dart) and [`lib/presentation/screens/settings/settings_screen.dart`](file:///c:/Users/ADITYA%20DWIVEDI/Desktop/Projects/Panchang%20App/lib/presentation/screens/settings/settings_screen.dart).

---

## Step 4: Run Tests

Run the test suite:
```bash
dart run test/run_all_tests.dart
```
