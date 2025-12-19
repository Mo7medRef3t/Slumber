import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slumber/core/firestore_service.dart';
import 'package:slumber/features/auth/data/models/slumber_user.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final FirestoreService firestoreService;

  UserCubit(this.firestoreService) : super(UserInitial());

  SlumberUser? _cachedUser;

  SlumberUser? get user => _cachedUser;

  /// تحميل بيانات المستخدم (مرة واحدة)
  Future<void> loadUser() async {
    try {
      emit(UserLoading());
      final user = await firestoreService.getCurrentUser();
      if (user == null) {
        emit(const UserError("User data not found"));
        return;
      }
      _cachedUser = user;
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  /// تحديث بيانات المستخدم بعد Edit Profile
  void updateUser(SlumberUser updatedUser) {
    _cachedUser = updatedUser;
    emit(UserLoaded(updatedUser));
  }

  /// تفريغ البيانات عند Logout
  void clear() {
    _cachedUser = null;
    emit(UserInitial());
  }
}
