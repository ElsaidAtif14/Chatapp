import 'package:chatapp/features/chat/data/datasources/firebase_chat_data_source.dart';
import 'package:chatapp/features/chat/domain/entities/message_entity.dart';
import 'package:chatapp/features/chat/domain/entities/user_entity.dart';
import 'package:chatapp/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this.dataSource);

  final FirebaseChatDataSource dataSource;

  @override
  Stream<List<UserEntity>> watchUsers() {
    return dataSource.watchUsers().map(
      (users) => users.map((user) => user.toEntity()).toList(growable: false),
    );
  }

  @override
  Stream<List<MessageEntity>> watchMessages(String receiverUserId) {
    return dataSource
        .watchMessages(receiverUserId)
        .map(
          (messages) => messages
              .map((message) => message.toEntity())
              .toList(growable: false),
        );
  }

  @override
  Future<void> sendMessage({
    required String receiverUserId,
    required String message,
  }) {
    return dataSource.sendMessage(
      receiverUserId: receiverUserId,
      message: message,
    );
  }
}
