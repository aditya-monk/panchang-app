# How to Add a New Festival or Vrat

Festivals and Vrats in the application are strictly data-driven and decoupled from the UI.

To add a new festival or religious observance:

## Step 1: Locate `lib/data/festivals_data.dart`

Open [`lib/data/festivals_data.dart`](file:///c:/Users/ADITYA%20DWIVEDI/Desktop/Projects/Panchang%20App/lib/data/festivals_data.dart).

## Step 2: Identify the Occurrence Rule

Determine how the festival is fixed:
1. **Lunar Month and Tithi**:
   - `lunarMonthIndex`: 0 = Chaitra, 1 = Vaishakha, 2 = Jyeshtha, 3 = Ashadha, 4 = Shravana, 5 = Bhadrapada, 6 = Ashwin, 7 = Kartika, 8 = Margashirsha, 9 = Pausha, 10 = Magha, 11 = Phalguna.
   - `tithiNumber`: 1 to 15 (Shukla Paksha), 16 to 30 (Krishna Paksha).
2. **Solar Ingress (Sankranti)**:
   - Evaluated by Sun's transit or Gregorian calendar date (e.g. Makar Sankranti on Jan 14/15).
3. **Tradition Specificity**:
   - Check if the festival applies to all traditions, or specifically to `CalendarTradition.vaishnavaIskcon` or `CalendarTradition.gitaPressReference`.

## Step 3: Add to `detectFestivals` Function

Add your condition to the switch statement:

```dart
case 4: // Shravana
  if (tithiNumber == 5) f.add('Nag Panchami');
  // Example: Add a new festival
  if (tithiNumber == 12 && paksha == Paksha.shukla) {
    f.add('Dadhi Vamana Dvadashi');
    if (tradition == CalendarTradition.vaishnavaIskcon) {
      vaish.add('Sri Vamana Dvadashi (Appearance of Lord Vamanadeva)');
    }
  }
  break;
```

## Step 4: Run Tests

Verify your addition by running the test suite:
```bash
dart run test/run_all_tests.dart
```
