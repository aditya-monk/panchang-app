# Open-Source Licenses & Attribution

## 1. Astronomical Calculation Engine
- **Implementation**: Pure Dart implementation in `lib/services/astronomy/astronomy_engine.dart`.
- **Mathematical Basis**: Jean Meeus, *Astronomical Algorithms* (2nd Edition, Willmann-Bell) and truncated VSOP87 / ELP2000 planetary and lunar theories.
- **License**: MIT Permissive License.
- **Notice on Swiss Ephemeris**: This application does **NOT** use or link to the Swiss Ephemeris (Sweph) library, completely avoiding AGPL viral licensing obligations or proprietary commercial licensing fees.

## 2. Hindu Panchang Mathematics & Tradition Rules
- **Implementation**: Pure Dart implementation in `lib/services/panchang/`, `lib/services/traditions/`, `lib/services/ekadashi/`, and `lib/services/muhurat/`.
- **Tradition References**: Classical Dharma-shastra texts including *Nirnaya Sindhu*, *Dharma Sindhu*, and Gaudiya Vaishnava *Hari-bhakti-vilasa*.
- **License**: MIT Permissive License.

## 3. Bundled City Database
- **Implementation**: `lib/data/cities.dart`.
- **Data Source**: Public domain geographic coordinates compiled from OpenStreetMap and Census of India administrative listings.
- **License**: Open Data Commons Public Domain Dedication and License (PDDL / CC0).

## 4. Multilingual Localizations
- **Implementation**: `lib/l10n/app_localizations.dart` and `lib/services/voice/voice_service.dart`.
- **Supported Languages**: English, Hindi, Gujarati, Marathi, Bhojpuri.
- **License**: MIT License.

## 5. Flutter & Dart Ecosystem
- **Flutter Framework**: BSD 3-Clause License (Google LLC).
- **Dart SDK**: BSD 3-Clause License (Google LLC).
- **Package intl**: BSD 3-Clause License (Dart Team).
