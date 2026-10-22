import 'dart:async';

import 'package:chatapp/features/chat/domain/entities/user_entity.dart';
import 'package:chatapp/features/chat/domain/usecases/watch_users.dart';
import 'package:chatapp/features/chat/presentation/cubit/users/users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit(this._watchUsers) : super(const UsersInitial());

  final WatchUsers _watchUsers;
  StreamSubscription<List<UserEntity>>? _subscription;

  void watchUsers() {
    unawaited(_subscription?.cancel());
    emit(const UsersLoading());
    _subscription = _watchUsers().listen(
      (users) => emit(UsersLoaded(users)),
      onError: (Object error) {
        emit(UsersFailure(error.toString()));
      },
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
