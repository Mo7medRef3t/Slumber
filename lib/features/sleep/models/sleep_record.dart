class SleepRecord {
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;

  SleepRecord({
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
  });

  factory SleepRecord.fromMap(Map<String, dynamic> data) {
    return SleepRecord(
      startTime: DateTime.parse(data['startTime']),
      endTime: DateTime.parse(data['endTime']),
      durationMinutes: data['duration'],
    );
  }
}
