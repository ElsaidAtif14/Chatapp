import 'package:chatapp/features/chat/data/models/message_model.dart';
import 'package:chatapp/features/chat/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseChatDataSource {
  FirebaseChatDataSource({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('A signed-in user is required to access chats.');
    }
    return user.uid;
  }

  Stream<List<UserModel>> watchUsers() {
    return _firestore
        .collection('users')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .where((document) => document.id != _currentUserId)
              .map(UserModel.fromFirestore)
              .toList(growable: false),
        );
  }

  Stream<List<MessageModel>> watchMessages(String receiverUserId) {
    final roomId = _chatRoomId(_currentUserId, receiverUserId);
    return _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(MessageModel.fromFirestore)
              .toList(growable: false),
        );
  }

  Future<void> sendMessage({
    required String receiverUserId,
    required String message,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('A signed-in user is required to send messages.');
    }

    final roomId = _chatRoomId(user.uid, receiverUserId);
    await _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .add({
          'senderId': user.uid,
          'senderEmail': user.email ?? '',
          'receiverId': receiverUserId,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  String _chatRoomId(String user1, String user2) {
    final ids = [user1, user2]..sort();
    return ids.join('_');
  }
}
