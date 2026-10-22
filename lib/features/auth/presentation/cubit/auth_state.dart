import 'package:chatapp/features/auth/domain/entities/app_user.dart';
import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => [];
}

final class AuthLoading extends AuthState {
  const AuthLoading({this.user});

  final AppUser? user;

  @override
  List<Object?> get props => [user];
}

final class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);

  final AppUser user;

  @override
  List<Object?> get props => [user];
}

final class AuthFailure extends AuthState {
  const AuthFailure(this.message, {this.user});

  final String message;
  final AppUser? user;

  @override
  List<Object?> get props => [message, user];
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();

  @override
  List<Object?> get props => [];
}
