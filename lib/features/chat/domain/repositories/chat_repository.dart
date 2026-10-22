import 'package:chatapp/features/chat/domain/entities/message_entity.dart';
import 'package:chatapp/features/chat/domain/entities/user_entity.dart';

abstract class ChatRepository {
  Stream<List<UserEntity>> watchUsers();

  Stream<List<MessageEntity>> watchMessages(String receiverUserId);

  Future<void> sendMessage({
    required String receiverUserId,
    required String message,
  });
}
