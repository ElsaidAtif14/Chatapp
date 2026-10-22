import 'package:chatapp/features/chat/domain/entities/message_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

final class ChatInitial extends ChatState {
  const ChatInitial();

  @override
  List<Object?> get props => [];
}

final class ChatLoading extends ChatState {
  const ChatLoading();

  @override
  List<Object?> get props => [];
}

final class ChatLoaded extends ChatState {
  const ChatLoaded({
    required this.messages,
    this.isSending = false,
    this.sendError,
  });

  final List<MessageEntity> messages;
  final bool isSending;
  final String? sendError;

  @override
  List<Object?> get props => [messages, isSending, sendError];
}

final class ChatFailure extends ChatState {
  const ChatFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
