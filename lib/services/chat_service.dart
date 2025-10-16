import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // جلب اليوزر الحالي
  User get currentUser => _auth.currentUser!;

  // جلب جميع اليوزرز
  Stream<List<DocumentSnapshot>> getUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) => snapshot.docs);
  }

  // إرسال رسالة
  Future<void> sendMessage(String receiverUserId, String message) async {
    final String currentUserId = currentUser.uid;
    final String currentUserEmail = currentUser.email!;

    // إنشاء chat room ID
    String chatRoomId = _getChatRoomId(currentUserId, receiverUserId);

    // حفظ الرسالة
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'senderEmail': currentUserEmail,
      'receiverId': receiverUserId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // جلب الرسائل
  Stream<QuerySnapshot> getMessages(String receiverUserId) {
    final String currentUserId = currentUser.uid;
    String chatRoomId = _getChatRoomId(currentUserId, receiverUserId);

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // إنشاء chat room ID
  String _getChatRoomId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return ids.join('_');
  }
}