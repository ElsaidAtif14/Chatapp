import 'package:chatapp/features/auth/domain/entities/app_user.dart';
import 'package:chatapp/features/auth/domain/usecases/sign_in.dart';
import 'package:chatapp/features/auth/domain/usecases/sign_out.dart';
import 'package:chatapp/features/auth/domain/usecases/sign_up.dart';
import 'package:chatapp/features/auth/presentation/cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required SignIn signIn,
    required SignUp signUp,
    required SignOut signOut,
  }) : _signIn = signIn,
       _signUp = signUp,
       _signOut = signOut,
       super(const AuthInitial());

  final SignIn _signIn;
  final SignUp _signUp;
  final SignOut _signOut;

  Future<void> signIn({required String email, required String password}) async {
    await _authenticate(() => _signIn(email: email.trim(), password: password));
  }

  Future<void> signUp({required String email, required String password}) async {
    await _authenticate(() => _signUp(email: email.trim(), password: password));
  }

  Future<void> _authenticate(Future<AppUser> Function() operation) async {
    emit(const AuthLoading());
    try {
      final user = await operation();
      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (error) {
      emit(AuthFailure(error.message ?? error.code));
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }

  Future<bool> signOut() async {
    final currentUser = switch (state) {
      AuthSuccess(:final user) => user,
      AuthLoading(:final user) || AuthFailure(:final user) => user,
      AuthInitial() || Unauthenticated() => null,
    };
    emit(AuthLoading(user: currentUser));
    try {
      await _signOut();
      emit(const Unauthenticated());
      return true;
    } catch (error) {
      emit(AuthFailure(error.toString(), user: currentUser));
      return false;
    }
  }
}
