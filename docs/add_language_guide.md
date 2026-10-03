# How to Add a New Language

The application natively supports **English**, **Hindi**, **Gujarati**, **Marathi**, and **Bhojpuri**. Adding a new language requires zero modifications to calculation engines.

---

## Step 1: Add Language Code to `lib/l10n/app_localizations.dart`

1. Open [`lib/l10n/app_localizations.dart`](file:///c:/Users/ADITYA%20DWIVEDI/Desktop/Projects/Panchang%20App/lib/l10n/app_localizations.dart).
2. Add your language code (e.g. `'ta'` for Tamil, `'te'` for Telugu, `'bn'` for Bengali) to `supportedLanguages`:
   ```dart
   static const List<String> supportedLanguages = ['en', 'hi', 'gu', 'mr', 'bho', 'ta'];
   ```
3. Add the native display name to `languageNames`:
   ```dart
   'ta': 'தமிழ்',
   ```
4. Add the translation dictionary under `_localizedValues['ta']`:
   ```dart
   'ta': {
     'app_title': 'பஞ்சாங்கம்',
     'tab_today': 'இன்று',
     'tab_calendar': 'நாட்காட்டி',
     'tab_muhurat': 'முகூர்த்தம்',
     'tab_ask': 'கேளுங்கள்',
     // ... complete all keys
   },
   ```

---

## Step 2: Add Voice Response Templates in `lib/services/voice/voice_service.dart`

To allow voice queries and spoken responses in the new language:
1. Open [`lib/services/voice/voice_service.dart`](file:///c:/Users/ADITYA%20DWIVEDI/Desktop/Projects/Panchang%20App/lib/services/voice/voice_service.dart).
2. Add cases for `'ta'` in:
   - `_getGreetingForLang`
   - `_formatPanchangResponse`
   - `_formatSunriseResponse`
   - `_formatEkadashiResponse`
   - `_formatRahuKaalResponse`
   - `_formatMuhuratResponse`

---

## Step 3: Add NLP Keywords in `lib/services/nlp/nlp_query_parser.dart`

Add query recognition tokens in [`lib/services/nlp/nlp_query_parser.dart`](file:///c:/Users/ADITYA%20DWIVEDI/Desktop/Projects/Panchang%20App/lib/services/nlp/nlp_query_parser.dart) for common intents (e.g. "சூரியோதயம்", "ஏகாதசி").

---

## Step 4: Verify

Run the test suite to ensure no syntax errors and verify dictionary keys:
```bash
dart run test/run_all_tests.dart
```
