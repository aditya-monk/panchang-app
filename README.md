# 🪔 Panchang — Free, Offline-First, Multilingual Hindu Panchang & Muhurat App

A modern, production-quality, privacy-first mobile application built with Flutter & Dart focused exclusively on:
1. **Hindu Panchang** (Tithi, Nakshatra, Yoga, Karana, Vara, Sunrise, Sunset, Moonrise, Moonset, Rahu Kaal, Abhijit, Choghadiya, Hora)
2. **Year / Month / Day Calendar** (Browsing ANY year, historical & future)
3. **Festivals & Vrat Tracking** (Purnimanta & Amanta regional alignment)
4. **Ekadashi & Parana Fasting Engine** (Exact start/end and fast-breaking windows)
5. **Location-Specific Muhurat Finder** (18+ data-driven occasions, transparent "Why this window?" explanations)
6. **Natural-Language Muhurat Search** (Multi-turn conversational context memory)
7. **Multilingual UI & Voice Assistant** (English, Hindi, Gujarati, Marathi, Bhojpuri)
8. **Tradition Profiles** (Standard Hindu Smarta, Vaishnava / ISKCON Shuddha Ekadashi, Gita Press Reference)

---

## 🌟 Core Product Principles

### 1. Know. Plan. Ask.
- **KNOW**: Explore daily and monthly Panchang for any supported date and location.
- **PLAN**: Find suitable Muhurat windows with transparent condition checks and Rahu Kaal avoidance.
- **ASK**: Speak or type naturally in Hindi, English, Gujarati, Marathi, or Bhojpuri with multi-turn context retention.

### 2. Location Matters (Section 53A.3)
- Every calculation strictly incorporates exact **latitude**, **longitude**, and **local timezone**.
- For all Muhurat searches, the **Event Location strictly overrides the Current Location**. Always visibly shows: `📍 Event location: Ahmedabad, Gujarat`.

### 3. Zero Paid APIs & Offline-First (Section 53A.6 & 53A.7)
- **Zero Paid APIs**: Operates completely offline without Google Maps, paid weather, paid speech, or cloud LLM APIs.
- **Permissive MIT Licensing**: Astronomical mathematics implemented in pure Dart using Jean Meeus (*Astronomical Algorithms*) and VSOP87/ELP2000 series.
- **Zero Swiss Ephemeris**: No Swiss Ephemeris AGPL dependencies are used, eliminating licensing liabilities.

---

## 📱 Navigation & Key Features

| Tab | Key Features |
|---|---|
| **🏠 Today** | Current location pill, Astronomical Sunrise/Sunset, Udaya Tithi, live **NOW Indicator** (Rahu Kaal / Abhijit active), Important Times, Next Ekadashi highlight, Day Timeline. |
| **📅 Calendar** | Any-year selector (2020–2039+), 12-month Year View with event dots, traditional Month View with **Show Muhurat** overlay toggle, Day View, Tradition Switcher, and **Compare Traditions** modal. |
| **🪔 Muhurat** | Natural-language query search bar, 18+ popular occasion chips (Marriage, Griha Pravesh, Vehicle, Property, Business, Mundan, etc.), Suitable / Conditional / Not Suitable status badges, and dual-level "Why this window?" explanations. |
| **🎙️ Ask** | Interactive voice & text assistant with animated listening pulse, quick chips, decoupled UI & Voice language selection, and rich response cards. |

---

## 🧪 Comprehensive Verification Suite

The repository contains a full automated unit test suite verifying astronomy, Panchang, tradition profiles, Muhurat rules, conversational NLP queries, and city databases.

To run all tests:
```bash
dart run test/run_all_tests.dart
```

### Test Suite Output:
```text
========================================================
🕉️ RUNNING COMPREHENSIVE PANCHANG & MUHURAT TEST SUITE 🕉️
========================================================

=== Running Astronomical Engine Tests ===
✓ Test 1 Passed: Julian Day roundtrip (2461316.77)
✓ Test 2 Passed: Sun Lon = 190.07°, Moon Lon = 96.22°
✓ Test 3 Passed: Lahiri Ayanamsa = 24.2308°
✓ Test 4 Passed: Sunrise Vadodara = 6:29, Sunset = 18:23
✓ Test 5 Passed: Tithi = 23, Nakshatra = 6
=== All Astronomical Tests Passed Successfully! ===

=== Running Panchang Engine Tests ===
✓ Test 1 Passed: Vara = Shanivara, Tithi = Saptami, Nakshatra = Ardra
✓ Test 2 Passed: Rahu Kaal = 9:27 - 10:57
✓ Test 2 Passed: Abhijit = 12:2 - 12:50
✓ Test 3 Passed: 8 Day and 8 Night Choghadiya periods correctly generated
✓ Test 4 Passed: Live Now Indicator = Abhijit Muhurat is currently active
=== All Panchang Tests Passed Successfully! ===

=== Running Traditions & Ekadashi Tests ===
✓ Test 1 Passed: Next Ekadashi = Indira Ekadashi on 6 October 2026
✓ Test 1 Passed: Parana Window = 7 October: 6:30 AM – 10:45 AM
✓ Test 2 Passed: Successfully generated side-by-side comparison for 3 traditions
✓ Test 3 Passed: Vaishnava Shuddha Ekadashi rule verified with Arunodaya explanation
=== All Tradition Tests Passed Successfully! ===

=== Running Muhurat Engine Tests ===
✓ Test 1 Passed: Griha Pravesh in Ahmedabad: 59 windows found
✓ Test 1 Passed: First Window = 4 November 2026 (6:46 AM – 8:10 AM)
✓ Test 2 Passed: Vehicle Purchase in Vadodara: 65 windows found
✓ Test 3 Passed: Marriage in Udaipur: 55 windows evaluated
=== All Muhurat Tests Passed Successfully! ===

=== Running NLP Query Parser & Conversational Context Tests ===
✓ Test 1 Passed: English parse occasion=griha_pravesh, location=Ahmedabad
✓ Test 2 Passed: Hindi parse intent=nextEkadashi
✓ Test 3 Passed: Gujarati parse occasion=griha_pravesh, location=Ahmedabad
✓ Test 4 Passed: Bhojpuri parse intent=nextEkadashi

--- Testing Multi-turn Conversational Context ---
Turn 1: occasion=griha_pravesh, location=Ahmedabad, month=11
Turn 2 ("What about December?"): occasion=griha_pravesh, location=Ahmedabad, month=12
Turn 3 ("Only weekends"): weekdays=[6, 0], location=Ahmedabad
Turn 4 ("What about Vadodara?"): location changed to Vadodara, occasion=griha_pravesh
=== All NLP Query Parser & Context Tests Passed Successfully! ===

=== Running Location Engine & City Database Tests ===
✓ Test 1 Passed: Found Ahmedabad, Gujarat
✓ Test 2 Passed: Found Varanasi via alias "काशी"
✓ Test 3 Passed: Found Ahmedabad via alias "અમદાવાદ"
✓ Test 4 Passed: Event Location (Ahmedabad) correctly overrides Current Location (Mumbai)
=== All Location Engine Tests Passed Successfully! ===

========================================================
🎉 ALL TEST SUITES PASSED FLAWLESSLY! 🎉
========================================================
```

---

## 📚 Developer Guides & Documentation

- [Licenses & Swiss Ephemeris Exclusion](docs/licenses/LICENSES.md)
- [Developer Architecture & Guide](docs/developer_guide.md)
- [How to Add a New Festival or Vrat](docs/add_festival_guide.md)
- [How to Add a New Muhurat Occasion Rule](docs/add_muhurat_rule_guide.md)
- [How to Add a New Language](docs/add_language_guide.md)
- [How to Add a New Calendar Tradition](docs/add_tradition_guide.md)

---

## 🚀 Running the Flutter Mobile App

```bash
flutter pub get
flutter run
```
