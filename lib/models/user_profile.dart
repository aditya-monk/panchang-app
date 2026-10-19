class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String city;
  final String state;
  final String country;
  final double latitude;
  final double longitude;
  final String provider; // 'google' | 'apple'
  final String? photoUrl;
  final String tradition; // 'smartha' | 'vaishnava'
  final String language; // 'hi', 'en', 'gu', 'mr', 'bho'
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime lastActiveAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.provider,
    this.photoUrl,
    required this.tradition,
    required this.language,
    this.isAdmin = false,
    required this.createdAt,
    required this.lastActiveAt,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
    String? provider,
    String? photoUrl,
    String? tradition,
    String? language,
    bool? isAdmin,
    DateTime? lastActiveAt,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      provider: provider ?? this.provider,
      photoUrl: photoUrl ?? this.photoUrl,
      tradition: tradition ?? this.tradition,
      language: language ?? this.language,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'provider': provider,
      'photoUrl': photoUrl,
      'tradition': tradition,
      'language': language,
      'isAdmin': isAdmin,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: json['name'] as String? ?? 'User',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      city: json['city'] as String? ?? 'New Delhi',
      state: json['state'] as String? ?? 'Delhi',
      country: json['country'] as String? ?? 'India',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 28.6139,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 77.2090,
      provider: json['provider'] as String? ?? 'google',
      photoUrl: json['photoUrl'] as String?,
      tradition: json['tradition'] as String? ?? 'smartha',
      language: json['language'] as String? ?? 'hi',
      isAdmin: json['isAdmin'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.tryParse(json['lastActiveAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
