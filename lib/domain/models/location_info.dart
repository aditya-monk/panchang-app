/// Location information for location-aware astronomical and Panchang calculations.
class LocationInfo {
  final String name;
  final String state;
  final String country;
  final double latitude;
  final double longitude;
  final double timezoneHours;
  final String timezoneId;
  final List<String> aliases;
  final bool isEventLocation;

  const LocationInfo({
    required this.name,
    required this.state,
    this.country = 'India',
    required this.latitude,
    required this.longitude,
    this.timezoneHours = 5.5,
    this.timezoneId = 'Asia/Kolkata',
    this.aliases = const [],
    this.isEventLocation = false,
  });

  String get displayName => state.isNotEmpty ? '$name, $state' : name;

  String get coordinatesString {
    final latDir = latitude >= 0 ? 'N' : 'S';
    final lonDir = longitude >= 0 ? 'E' : 'W';
    return '${latitude.abs().toStringAsFixed(4)}° $latDir, ${longitude.abs().toStringAsFixed(4)}° $lonDir';
  }

  LocationInfo copyWith({
    String? name,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
    double? timezoneHours,
    String? timezoneId,
    List<String>? aliases,
    bool? isEventLocation,
  }) {
    return LocationInfo(
      name: name ?? this.name,
      state: state ?? this.state,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezoneHours: timezoneHours ?? this.timezoneHours,
      timezoneId: timezoneId ?? this.timezoneId,
      aliases: aliases ?? this.aliases,
      isEventLocation: isEventLocation ?? this.isEventLocation,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'state': state,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
        'timezoneHours': timezoneHours,
        'timezoneId': timezoneId,
        'aliases': aliases,
        'isEventLocation': isEventLocation,
      };

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
        name: json['name'] as String,
        state: json['state'] as String? ?? '',
        country: json['country'] as String? ?? 'India',
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        timezoneHours: (json['timezoneHours'] as num?)?.toDouble() ?? 5.5,
        timezoneId: json['timezoneId'] as String? ?? 'Asia/Kolkata',
        aliases: (json['aliases'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        isEventLocation: json['isEventLocation'] as bool? ?? false,
      );

  // Default pre-configured reference location (Vadodara, Gujarat per spec)
  static const LocationInfo vadodara = LocationInfo(
    name: 'Vadodara',
    state: 'Gujarat',
    country: 'India',
    latitude: 22.3072,
    longitude: 73.1812,
    timezoneHours: 5.5,
    timezoneId: 'Asia/Kolkata',
    aliases: ['Baroda', 'વડોદરા', 'वडोदरा'],
  );

  static const LocationInfo ahmedabad = LocationInfo(
    name: 'Ahmedabad',
    state: 'Gujarat',
    country: 'India',
    latitude: 23.0225,
    longitude: 72.5714,
    timezoneHours: 5.5,
    timezoneId: 'Asia/Kolkata',
    aliases: ['Amdavad', 'અમદાવાદ', 'अहमदाबाद'],
  );

  static const LocationInfo varanasi = LocationInfo(
    name: 'Varanasi',
    state: 'Uttar Pradesh',
    country: 'India',
    latitude: 25.3176,
    longitude: 82.9739,
    timezoneHours: 5.5,
    timezoneId: 'Asia/Kolkata',
    aliases: ['Banaras', 'Kashi', 'वाराणसी', 'बनारस', 'काशी'],
  );
}
