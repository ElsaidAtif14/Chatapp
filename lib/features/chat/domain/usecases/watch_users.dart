import 'package:chatapp/features/chat/domain/entities/user_entity.dart';
import 'package:chatapp/features/chat/domain/repositories/chat_repository.dart';

class WatchUsers {
  const WatchUsers(this.repository);

  final ChatRepository repository;

  Stream<List<UserEntity>> call() => repository.watchUsers();
}
