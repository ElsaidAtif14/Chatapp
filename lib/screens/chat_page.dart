import 'package:chatapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatPage extends StatefulWidget {
  final UserModel receiverUser;

  const ChatPage({super.key, required this.receiverUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          MessageInput(
            onSendMessage: _sendMessage,
            scrollController: _scrollController,
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/cartton.png'),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.receiverUser.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
               ],
          ),
        ],
      ),
    );
  }
Widget _buildMessageList() {
  return StreamBuilder<QuerySnapshot>(
    stream: _chatService.getMessages(widget.receiverUser.id),
    builder: (context, snapshot) {
      if (snapshot.hasError) return _buildErrorWidget();
      if (snapshot.connectionState == ConnectionState.waiting) return _buildLoadingWidget();
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _buildEmptyWidget();

      // نعمل reverse للقائمة علشان نبدأ من آخر رسالة
      final messages = snapshot.data!.docs.reversed.toList();

      return ListView.builder(
        controller: _scrollController,
        reverse: true, // علشان نبدأ من الأسفل
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return MessageBubble(
            document: messages[index],
            currentUserId: _chatService.currentUser.uid,
            receiverName: widget.receiverUser.name,
          );
        },
      );
    },
  );
}
  void _sendMessage(String message) {
    _chatService.sendMessage(widget.receiverUser.id, message);
  }

  Widget _buildErrorWidget() => const Center(child: Text('Error loading messages'));
  Widget _buildLoadingWidget() => const Center(child: CircularProgressIndicator());
  Widget _buildEmptyWidget() => const Center(child: Text('No messages yet'));

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}