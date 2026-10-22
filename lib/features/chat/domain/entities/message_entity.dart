class MessageEntity {
  const MessageEntity({
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
}
