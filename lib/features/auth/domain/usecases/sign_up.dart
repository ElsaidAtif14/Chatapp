import 'package:chatapp/features/auth/domain/entities/app_user.dart';
import 'package:chatapp/features/auth/domain/repositories/auth_repository.dart';

class SignUp {
  const SignUp(this.repository);

  final AuthRepository repository;

  Future<AppUser> call({required String email, required String password}) {
    return repository.signUp(email: email, password: password);
  }
}
