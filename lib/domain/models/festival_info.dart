import '../../core/constants/panchang_constants.dart';

class FestivalInfo {
  final String name;
  final DateTime date;
  final String description;
  final String category; // 'festival', 'vrat', 'vaishnava', 'sankranti', 'jayanti'
  final CalendarTradition? tradition;
  final RegionalProfile? regionalProfile;

  const FestivalInfo({
    required this.name,
    required this.date,
    required this.description,
    required this.category,
    this.tradition,
    this.regionalProfile,
  });

  bool get isMajorFestival => category == 'festival';
  bool get isVrat => category == 'vrat';
  bool get isVaishnava => category == 'vaishnava';
  bool get isSankranti => category == 'sankranti';
}
