import 'package:chatapp/features/chat/domain/entities/user_entity.dart';
import 'package:chatapp/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: ListTile(
          leading: const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/cartton.png'),
          ),
          title: Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          subtitle: Text(user.email),
          trailing: Icon(
            Icons.chat_bubble_outline,
            color: Colors.blue.shade600,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => ChatPage(receiverUser: user),
              ),
            );
          },
        ),
      ),
    );
  }
}
