import 'package:chatapp/features/chat/domain/repositories/chat_repository.dart';

class SendMessage {
  const SendMessage(this.repository);

  final ChatRepository repository;

  Future<void> call({required String receiverUserId, required String message}) {
    return repository.sendMessage(
      receiverUserId: receiverUserId,
      message: message,
    );
  }
}
