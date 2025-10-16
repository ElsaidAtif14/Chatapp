import 'package:chatapp/model/user_model.dart';
import 'package:flutter/material.dart';
import '../screens/chat_page.dart';

class UserTile extends StatelessWidget {
  final UserModel user;

  const UserTile({super.key, required this.user});

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
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 24,
           backgroundImage: AssetImage('assets/images/cartton.png'),
          ),
          title: Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          subtitle: Text(user.email),
          trailing: Icon(Icons.chat_bubble_outline, color: Colors.blue.shade600),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          onTap: () => _openChat(context),
        ),
      ),
    );
  }

  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverUser: user,
        ),
      ),
    );
  }
}