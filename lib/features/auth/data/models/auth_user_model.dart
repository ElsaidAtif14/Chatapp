import 'package:chatapp/features/auth/domain/entities/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.email,
    required this.name,
  });

  final String id;
  final String email;
  final String name;

  factory AuthUserModel.fromFirebaseUser(User user, {String? name}) {
    final email = user.email ?? '';
    return AuthUserModel(
      id: user.uid,
      email: email,
      name: name ?? email.split('@').first,
    );
  }

  AppUser toEntity() => AppUser(id: id, email: email, name: name);
}
