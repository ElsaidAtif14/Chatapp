import 'package:chatapp/features/auth/data/datasources/firebase_auth_data_source.dart';
import 'package:chatapp/features/auth/domain/entities/app_user.dart';
import 'package:chatapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this.dataSource);

  final FirebaseAuthDataSource dataSource;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final model = await dataSource.signIn(email: email, password: password);
    return model.toEntity();
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
  }) async {
    final model = await dataSource.signUp(email: email, password: password);
    return model.toEntity();
  }

  @override
  Future<void> signOut() => dataSource.signOut();
}
