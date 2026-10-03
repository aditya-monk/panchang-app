class ScheduledNotification {
  final String id;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final String category;

  const ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.category,
  });
}

class NotificationService {
  static final List<ScheduledNotification> _scheduled = [];

  static List<ScheduledNotification> get scheduledNotifications =>
      List.unmodifiable(_scheduled);

  /// Schedule a local notification
  static void scheduleNotification({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String category,
  }) {
    _scheduled.removeWhere((n) => n.id == id);
    _scheduled.add(ScheduledNotification(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      category: category,
    ));
  }

  static void cancelNotification(String id) {
    _scheduled.removeWhere((n) => n.id == id);
  }

  static void scheduleEkadashiReminder({
    required String ekadashiName,
    required DateTime date,
  }) {
    final reminderTime = date.subtract(Duration(days: 1, hours: -18)); // 6:00 PM evening before
    scheduleNotification(
      id: 'ekadashi_${date.year}_${date.month}_${date.day}',
      title: '🌙 $ekadashiName Tomorrow',
      body: 'Tomorrow is $ekadashiName. Fasting and observances begin at sunrise.',
      scheduledTime: reminderTime,
      category: 'ekadashi',
    );
  }

  static void scheduleParanaReminder({
    required DateTime paranaDate,
    required DateTime paranaStartTime,
  }) {
    scheduleNotification(
      id: 'parana_${paranaDate.year}_${paranaDate.month}_${paranaDate.day}',
      title: '🪔 Ekadashi Parana Window',
      body: 'Ekadashi fast breaking (Parana) starts at ${_formatTime(paranaStartTime)}.',
      scheduledTime: paranaStartTime.subtract(Duration(minutes: 15)),
      category: 'parana',
    );
  }

  static void scheduleMuhuratReminder({
    required String occasionTitle,
    required DateTime windowStart,
  }) {
    scheduleNotification(
      id: 'muhurat_${windowStart.millisecondsSinceEpoch}',
      title: '🪔 $occasionTitle Muhurat in 30 minutes',
      body: 'Your saved auspicious window starts at ${_formatTime(windowStart)}.',
      scheduledTime: windowStart.subtract(Duration(minutes: 30)),
      category: 'muhurat',
    );
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}
