import 'dart:async';

import 'package:chatapp/features/chat/domain/entities/message_entity.dart';
import 'package:chatapp/features/chat/domain/usecases/send_message.dart';
import 'package:chatapp/features/chat/domain/usecases/watch_messages.dart';
import 'package:chatapp/features/chat/presentation/cubit/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  final String _receiverUserId;
  final WatchMessages _watchMessages;
  final SendMessage _sendMessage;
  StreamSubscription<List<MessageEntity>>? _subscription;

  ChatCubit({
    required String receiverUserId,
    required WatchMessages watchMessages,
    required SendMessage sendMessage,
  }) : _receiverUserId = receiverUserId,
       _watchMessages = watchMessages,
       _sendMessage = sendMessage,
       super(const ChatInitial());

  void watchMessages() {
    unawaited(_subscription?.cancel());
    emit(const ChatLoading());
    _subscription = _watchMessages(_receiverUserId).listen((messages) {
      final currentState = state;
      emit(
        ChatLoaded(
          messages: messages,
          isSending: currentState is ChatLoaded && currentState.isSending,
          sendError: currentState is ChatLoaded ? currentState.sendError : null,
        ),
      );
    }, onError: (Object error) => emit(ChatFailure(error.toString())));
  }

  Future<bool> send(String message) async {
    final currentState = state;
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty ||
        currentState is! ChatLoaded ||
        currentState.isSending) {
      return false;
    }

    emit(ChatLoaded(messages: currentState.messages, isSending: true));
    try {
      await _sendMessage(
        receiverUserId: _receiverUserId,
        message: trimmedMessage,
      );
      final latestState = state;
      if (latestState is ChatLoaded) {
        emit(ChatLoaded(messages: latestState.messages));
      }
      return true;
    } catch (error) {
      final latestState = state;
      if (latestState is ChatLoaded) {
        emit(
          ChatLoaded(
            messages: latestState.messages,
            sendError: error.toString(),
          ),
        );
      } else {
        emit(ChatFailure(error.toString()));
      }
      return false;
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
