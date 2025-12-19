import 'package:equatable/equatable.dart';
import '../models/sleep_record.dart';

abstract class SleepState extends Equatable {
  const SleepState();

  @override
  List<Object?> get props => [];
}

class SleepInitial extends SleepState {}

class SleepLoading extends SleepState {}

class SleepLoaded extends SleepState {
  final List<SleepRecord> history;
  final double avgHours;
  final SleepRecord? bestSleep;
  final SleepRecord? lastSleep;

  const SleepLoaded({
    required this.history,
    required this.avgHours,
    required this.bestSleep,
    required this.lastSleep,
  });

  @override
  List<Object?> get props => [history, avgHours, bestSleep, lastSleep];
}

class SleepError extends SleepState {
  final String message;
  const SleepError(this.message);

  @override
  List<Object?> get props => [message];
}
