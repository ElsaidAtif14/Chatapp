import 'package:chatapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chatapp/features/auth/presentation/cubit/auth_state.dart';
import 'package:chatapp/features/chat/domain/entities/user_entity.dart';
import 'package:chatapp/core/di/injection_container.dart';
import 'package:chatapp/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chatapp/features/chat/presentation/cubit/chat_state.dart';
import 'package:chatapp/features/chat/presentation/widgets/message_bubble.dart';
import 'package:chatapp/features/chat/presentation/widgets/message_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.receiverUser});

  final UserEntity receiverUser;

  @override
  Widget build(BuildContext context) {
    final authUser = switch (context.read<AuthCubit>().state) {
      AuthSuccess(:final user) => user,
      AuthLoading(:final user) || AuthFailure(:final user) => user,
      AuthInitial() || Unauthenticated() => null,
    };
    if (authUser == null) {
      return const Scaffold(
        body: Center(child: Text('Sign in to open a chat.')),
      );
    }

    return BlocProvider(
      create: (_) => getIt<ChatCubit>(param1: receiverUser.id)..watchMessages(),
      child: _ChatView(receiverUser: receiverUser, currentUserId: authUser.id),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView({required this.receiverUser, required this.currentUserId});

  final UserEntity receiverUser;
  final String currentUserId;

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listenWhen: (previous, current) =>
          previous is ChatLoaded &&
          current is ChatLoaded &&
          previous.sendError != current.sendError &&
          current.sendError != null,
      listener: (context, state) {
        if (state case ChatLoaded(:final sendError?)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unable to send message: $sendError')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          title: Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/cartton.png'),
              ),
              const SizedBox(width: 12),
              Text(
                widget.receiverUser.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(child: _buildMessageList()),
            MessageInput(
              onSendMessage: context.read<ChatCubit>().send,
              scrollController: _scrollController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        switch (state) {
          case ChatInitial() || ChatLoading():
            return const Center(child: CircularProgressIndicator());
          case ChatFailure(:final message):
            return Center(child: Text('Error loading messages: $message'));
          case ChatLoaded(:final messages):
            if (messages.isEmpty) {
              return const Center(child: Text('No messages yet'));
            }
            final reversedMessages = messages.reversed.toList(growable: false);
            return ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: reversedMessages.length,
              itemBuilder: (context, index) => MessageBubble(
                message: reversedMessages[index],
                currentUserId: widget.currentUserId,
              ),
            );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
