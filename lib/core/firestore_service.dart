import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slumber/features/auth/data/models/slumber_user.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  String get uid => FirebaseAuth.instance.currentUser!.uid;

  /// تحديث بيانات اليوزر
  Future<void> updateUserProfile(SlumberUser user) async {
    await _db.collection("users").doc(uid).update(user.toMap());
  }

  /// إضافة sleep record
  Future<void> addSleepRecord(DateTime start, DateTime end) async {
    final duration = end.difference(start).inMinutes;
    await _db.collection("users").doc(uid).collection("sleepHistory").add({
      "startTime": start.toIso8601String(),
      "endTime": end.toIso8601String(),
      "duration": duration,
    });
  }

  /// استرجاع sleep history
  Stream<List<Map<String, dynamic>>> getSleepHistory() {
    return _db
        .collection("users")
        .doc(uid)
        .collection("sleepHistory")
        .orderBy("startTime", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<SlumberUser?> getCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await _db.collection("users").doc(uid).get();
    if (!doc.exists) return null;
    return SlumberUser.fromMap(doc.data()!);
  }
}
