class SleepRecord {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;

  SleepRecord({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
  });

  factory SleepRecord.fromMap(Map<String, dynamic> data, String docId) {
    return SleepRecord(
      id: docId,
      startTime: DateTime.parse(data['startTime']),
      endTime: DateTime.parse(data['endTime']),
      durationMinutes: data['duration'],
    );
  }
}
