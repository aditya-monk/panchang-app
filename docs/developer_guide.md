# Panchang App — Developer Architecture & Guide

Welcome to the **Panchang App** codebase. This guide explains the core architectural principles, layered system design, testing methodology, and guidelines for extending the application.

---

## 1. Architectural Principles

The application strictly obeys the following core tenets:
1. **Know. Plan. Ask.**
   - *Know*: Explore Panchang for any year, month, and date.
   - *Plan*: Find verified Muhurat windows based on event location and tradition rules.
   - *Ask*: Natural language and voice queries parsed locally with conversational context.
2. **Location Matters (Principle A & Section 53A.3)**:
   - All astronomical and Panchang values depend on latitude, longitude, and local timezone.
   - For all Muhurat searches, the **Event Location strictly overrides the Current Location**.
3. **Offline-First & Zero Paid APIs (Principle B)**:
   - All calculations occur locally in pure Dart.
   - Zero dependence on paid astrology APIs, Google Maps, weather APIs, or cloud LLMs.
4. **Three Distinct Layers (Section 53A.1)**:
   ```text
   ASTRONOMICAL CALCULATION (Meeus/VSOP87 Pure Dart)
           ↓
   PANCHANG MATHEMATICS (Tithi, Nakshatra, Yoga, Karana, Vara, Timings)
           ↓
   TRADITION / OBSERVANCE RULES (Standard Smarta, Vaishnava Shuddha Ekadashi, Gita Press)
   ```

---

## 2. Directory Structure

```text
lib/
├── core/
│   ├── constants/        # Tithi, Nakshatra, Yoga, Karana, Choghadiya constants & enums
│   └── theme/            # Cultural Indian palette (warm ivory, saffron, maroon) & Elder mode
├── data/
│   ├── cities.dart       # Bundled offline database with 500+ cities & multilingual aliases
│   ├── festivals_data.dart # Festival, Vrat, and Vaishnava observance rules
│   └── muhurat_rules.dart # Data-driven configurations for 18+ traditional occasions
├── domain/
│   └── models/           # Typed models: PanchangDay, LocationInfo, EkadashiInfo, MuhuratWindow
├── l10n/
│   └── app_localizations.dart # Multilingual strings (EN, HI, GU, MR, BHO)
├── presentation/
│   ├── screens/
│   │   ├── today/        # Today dashboard, NOW live card, day timeline, full panchang
│   │   ├── calendar/     # Year view (any year), month view, day view, comparison dialog
│   │   ├── muhurat/      # NLP search bar, occasion grid, windows list, detail modal
│   │   ├── ask/          # Conversational assistant with voice mic and quick chips
│   │   ├── onboarding/   # 6-step onboarding wizard
│   │   └── settings/     # Traditions, languages, notifications, elder mode toggle
│   └── widgets/          # Now indicator, timeline, time period cards
└── services/
    ├── astronomy/        # Pure Dart Meeus/VSOP astronomical engine & solvers
    ├── panchang/         # 5 limbs, Choghadiya, Hora, Rahu Kaal, Abhijit calculator
    ├── traditions/       # Standard Hindu, Vaishnava/ISKCON, and Gita Press rule engines
    ├── ekadashi/         # Ekadashi calculator, Parana windows, "Why this date?" generator
    ├── muhurat/          # Multi-constraint occasion scanner & ranking engine
    ├── nlp/              # Multi-turn conversational query parser with regex/entity extractor
    ├── voice/            # Voice assistant pipeline, TTS response templates, Bhojpuri adapter
    ├── location/         # GPS detection, city search, saved locations, event location override
    ├── notifications/    # Local reminder scheduler
    └── storage/          # Local key-value preferences and cached results
```

---

## 3. Running the Application & Test Suite

### Running Automated Unit Tests
To execute the comprehensive test suite across astronomy, Panchang, traditions, Muhurat, NLP parser, and location modules:
```bash
dart run test/run_all_tests.dart
```

### Running the Flutter Mobile Application
Ensure Flutter SDK is on your PATH:
```bash
flutter pub get
flutter run
```
