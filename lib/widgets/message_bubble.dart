import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final DocumentSnapshot document;
  final String currentUserId;
  final String receiverName;

  const MessageBubble({
    super.key,
    required this.document,
    required this.currentUserId,
    required this.receiverName,
  });

  @override
  Widget build(BuildContext context) {
    final data = document.data() as Map<String, dynamic>;
    final bool isMe = data['senderId'] == currentUserId;

    return Align(
      alignment: isMe ?   Alignment.centerLeft:Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 32, bottom: 32, right: 32),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomLeft: isMe ?Radius.circular(0) : Radius.circular(32),
            bottomRight: isMe ?  Radius.circular(32) : Radius.circular(0),
          ),
          color: isMe ? Color(0xff006D84) : const Color.fromARGB(255, 30, 56, 78), // غير الألوان حسب ما تريد
        ),
        child: Text(
          data['message'] ?? '',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }}