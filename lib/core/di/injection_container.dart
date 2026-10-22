import 'package:chatapp/features/auth/data/datasources/firebase_auth_data_source.dart';
import 'package:chatapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:chatapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:chatapp/features/auth/domain/usecases/sign_in.dart';
import 'package:chatapp/features/auth/domain/usecases/sign_out.dart';
import 'package:chatapp/features/auth/domain/usecases/sign_up.dart';
import 'package:chatapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chatapp/features/chat/data/datasources/firebase_chat_data_source.dart';
import 'package:chatapp/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chatapp/features/chat/domain/repositories/chat_repository.dart';
import 'package:chatapp/features/chat/domain/usecases/send_message.dart';
import 'package:chatapp/features/chat/domain/usecases/watch_messages.dart';
import 'package:chatapp/features/chat/domain/usecases/watch_users.dart';
import 'package:chatapp/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chatapp/features/chat/presentation/cubit/users/users_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  if (getIt.isRegistered<FirebaseAuth>()) {
    return;
  }

  getIt
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton(
      () => FirebaseAuthDataSource(
        auth: getIt<FirebaseAuth>(),
        firestore: getIt<FirebaseFirestore>(),
      ),
    )
    ..registerLazySingleton(
      () => FirebaseChatDataSource(
        auth: getIt<FirebaseAuth>(),
        firestore: getIt<FirebaseFirestore>(),
      ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<FirebaseAuthDataSource>()),
    )
    ..registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(getIt<FirebaseChatDataSource>()),
    )
    ..registerLazySingleton(() => SignIn(getIt<AuthRepository>()))
    ..registerLazySingleton(() => SignUp(getIt<AuthRepository>()))
    ..registerLazySingleton(() => SignOut(getIt<AuthRepository>()))
    ..registerLazySingleton(() => SendMessage(getIt<ChatRepository>()))
    ..registerLazySingleton(() => WatchMessages(getIt<ChatRepository>()))
    ..registerLazySingleton(() => WatchUsers(getIt<ChatRepository>()))
    ..registerFactory(
      () => AuthCubit(
        signIn: getIt<SignIn>(),
        signUp: getIt<SignUp>(),
        signOut: getIt<SignOut>(),
      ),
    )
    ..registerFactoryParam<ChatCubit, String, void>(
      (receiverUserId, _) => ChatCubit(
        receiverUserId: receiverUserId,
        watchMessages: getIt<WatchMessages>(),
        sendMessage: getIt<SendMessage>(),
      ),
    )
    ..registerFactory(() => UsersCubit(getIt<WatchUsers>()));
}

Future<void> init() async {
  setupServiceLocator();
}
