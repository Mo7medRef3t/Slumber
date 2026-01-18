import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slumber/core/firestore_service.dart';
import '../models/sleep_record.dart';
import 'sleep_state.dart';

class SleepCubit extends Cubit<SleepState> {
  final FirestoreService firestoreService;

  SleepCubit(this.firestoreService) : super(SleepInitial());

  final List<SleepRecord> _history = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  /// ✅ Start listening to Firestore stream
  void startListening() {
    emit(SleepLoading());

    _subscription?.cancel();
    _subscription = firestoreService.getSleepHistory().listen(
      (snapshot) {
        _history
          ..clear()
          ..addAll(
            snapshot.docs.map((doc) {
              // 🔥 هنا الحل: بنبعت الداتا والـ ID
              return SleepRecord.fromMap(doc.data(), doc.id);
            }).toList(),
          );

        emit(
          SleepLoaded(
            history: List.unmodifiable(_history),
            avgHours: _calculateAverage(),
            bestSleep: _calculateBest(),
            lastSleep: _history.isNotEmpty ? _history.first : null,
          ),
        );
      },
      onError: (e) {
        emit(SleepError(e.toString()));
      },
    );
  }

  Future<void> deleteRecord(String recordId) async {
    try {
      // حذف من فايربيز
      await firestoreService.deleteSleepRecord(recordId);

      // تحديث القائمة محلياً فوراً عشان الـ UI يبقى سريع
      _history.removeWhere((item) => item.id == recordId);

      emit(
        SleepLoaded(
          history: List.unmodifiable(_history),
          avgHours: _calculateAverage(),
          bestSleep: _calculateBest(),
          lastSleep: _history.isNotEmpty ? _history.first : null,
        ),
      );
    } catch (e) {
      emit(SleepError("Failed to delete: $e"));
    }
  }

  /// ✅ Used when adding record locally (optimistic update)
  void addRecord(SleepRecord record) {
    _history.insert(0, record);

    emit(
      SleepLoaded(
        history: List.unmodifiable(_history),
        avgHours: _calculateAverage(),
        bestSleep: _calculateBest(),
        lastSleep: _history.first,
      ),
    );
  }

  double _calculateAverage() {
    if (_history.isEmpty) return 0;

    final last7 = _history.take(7).toList();
    // ignore: avoid_types_as_parameter_names
    final total = last7.fold<int>(0, (sum, e) => sum + e.durationMinutes);

    return total / last7.length / 60.0;
  }

  SleepRecord? _calculateBest() {
    if (_history.isEmpty) return null;

    final sorted = [..._history]
      ..sort((a, b) => b.durationMinutes.compareTo(a.durationMinutes));

    return sorted.first;
  }

  void clear() {
    _history.clear();
    _subscription?.cancel();
    emit(SleepInitial());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
