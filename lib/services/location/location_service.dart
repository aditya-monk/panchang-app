import '../../data/cities.dart';
import '../../domain/models/location_info.dart';

class LocationService {
  static LocationInfo _currentLocation = LocationInfo.vadodara;
  static LocationInfo? _eventLocation;
  static final List<LocationInfo> _savedLocations = [
    const LocationInfo(
      name: 'Home (Ahmedabad)',
      state: 'Gujarat',
      latitude: 23.0225,
      longitude: 72.5714,
    ),
    const LocationInfo(
      name: 'Temple / Kashi Vishwanath',
      state: 'Uttar Pradesh',
      latitude: 25.3109,
      longitude: 83.0107,
    ),
  ];

  static LocationInfo get currentLocation => _currentLocation;
  static set currentLocation(LocationInfo loc) => setCurrentLocation(loc);
  static LocationInfo? get eventLocation => _eventLocation;
  static List<LocationInfo> get savedLocations => List.unmodifiable(_savedLocations);

  /// For Muhurat calculations, Event Location strictly overrides Current Location per Section 45
  static LocationInfo get activeMuhuratLocation =>
      _eventLocation ?? _currentLocation;

  static void setCurrentLocation(LocationInfo loc) {
    _currentLocation = loc;
  }

  static void setEventLocation(LocationInfo? loc) {
    _eventLocation = loc != null ? loc.copyWith(isEventLocation: true) : null;
  }

  static void saveLocation(LocationInfo loc) {
    _savedLocations.add(loc);
  }

  static void removeSavedLocation(String name) {
    _savedLocations.removeWhere((l) => l.name == name);
  }

  /// Search city from local bundled database
  static List<LocationInfo> search(String query) {
    return CityDatabase.search(query);
  }

  /// Resolve location from query text or fallback
  static LocationInfo resolveLocation(String name) {
    return CityDatabase.findByName(name) ?? _currentLocation;
  }
}
