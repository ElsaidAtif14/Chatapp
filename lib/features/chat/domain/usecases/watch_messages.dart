import 'package:chatapp/features/chat/domain/entities/message_entity.dart';
import 'package:chatapp/features/chat/domain/repositories/chat_repository.dart';

class WatchMessages {
  const WatchMessages(this.repository);

  final ChatRepository repository;

  Stream<List<MessageEntity>> call(String receiverUserId) {
    return repository.watchMessages(receiverUserId);
  }
}
