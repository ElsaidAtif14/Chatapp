import 'package:chatapp/features/chat/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  const MessageModel({
    required this.id,
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    this.timestamp,
  });

  final String id;
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final DateTime? timestamp;

  factory MessageModel.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    final timestamp = data['timestamp'];
    return MessageModel(
      id: document.id,
      senderId: data['senderId'] as String? ?? '',
      senderEmail: data['senderEmail'] as String? ?? '',
      receiverId: data['receiverId'] as String? ?? '',
      message: data['message'] as String? ?? '',
      timestamp: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }

  MessageEntity toEntity() => MessageEntity(
    id: id,
    senderId: senderId,
    senderEmail: senderEmail,
    receiverId: receiverId,
    message: message,
    timestamp: timestamp,
  );
}
