import 'package:chatapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../widgets/my_drawer.dart';
import '../widgets/user_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static String id = 'homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Pacifico'
          ),
        ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: const UsersList(),
    );
  }
}

class UsersList extends StatelessWidget {
  const UsersList({super.key});

  @override
  Widget build(BuildContext context) {
    final chatService = ChatService();
    
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: chatService.getUsers(),
      builder: (context, snapshot) {
        // معالجة الحالات المختلفة
        if (snapshot.hasError) return _buildErrorWidget(snapshot.error.toString());
        if (snapshot.connectionState == ConnectionState.waiting) return _buildLoadingWidget();
        if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmptyWidget();

        // تصفية اليوزرز (إزالة اليوزر الحالي)
        final users = _filterCurrentUser(snapshot.data!, chatService.currentUser.email!);

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = UserModel.fromFirestore(users[index]);
            return UserTile(user: user);
          },
        );
      },
    );
  }

  // تصفية اليوزر الحالي
  List<DocumentSnapshot> _filterCurrentUser(List<DocumentSnapshot> users, String currentUserEmail) {
    return users.where((doc) {
      final userData = doc.data() as Map<String, dynamic>;
      return userData['email'] != currentUserEmail;
    }).toList();
  }

  // ويدجت الخطأ
  Widget _buildErrorWidget(String error) {
    return Center(
      child: Text('Error: $error'),
    );
  }

  // ويدجت التحميل
  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // ويدجت لا يوجد يوزرز
  Widget _buildEmptyWidget() {
    return const Center(
      child: Text('No users found'),
    );
  }
}