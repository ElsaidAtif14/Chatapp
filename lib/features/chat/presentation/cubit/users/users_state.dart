import 'package:chatapp/features/chat/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

sealed class UsersState extends Equatable {
  const UsersState();
}

final class UsersInitial extends UsersState {
  const UsersInitial();

  @override
  List<Object?> get props => [];
}

final class UsersLoading extends UsersState {
  const UsersLoading();

  @override
  List<Object?> get props => [];
}

final class UsersLoaded extends UsersState {
  const UsersLoaded(this.users);

  final List<UserEntity> users;

  @override
  List<Object?> get props => [users];
}

final class UsersFailure extends UsersState {
  const UsersFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
