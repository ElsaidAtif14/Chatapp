import 'package:chatapp/features/chat/domain/entities/message_entity.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  final MessageEntity message;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == currentUserId;
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.only(
          left: 16,
          top: 32,
          bottom: 32,
          right: 32,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(32),
            topRight: const Radius.circular(32),
            bottomLeft: isMe
                ? const Radius.circular(0)
                : const Radius.circular(32),
            bottomRight: isMe
                ? const Radius.circular(32)
                : const Radius.circular(0),
          ),
          color: isMe
              ? const Color(0xff006D84)
              : const Color.fromARGB(255, 30, 56, 78),
        ),
        child: Text(
          message.message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
