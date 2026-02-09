/// Workmanager task identifiers for background processing.
enum MyWorkmanager {
  /// Daily reminder notification task.
  /// Uses one-off scheduling with self-rescheduling pattern.
  dailyReminder('com.kulinere.daily_reminder', 'com.kulinere.daily_reminder');

  final String uniqueName;
  final String taskName;

  const MyWorkmanager(this.uniqueName, this.taskName);
}
