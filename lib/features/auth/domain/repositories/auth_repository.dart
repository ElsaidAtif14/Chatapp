import 'package:chatapp/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser> signIn({required String email, required String password});

  Future<AppUser> signUp({required String email, required String password});

  Future<void> signOut();
}
