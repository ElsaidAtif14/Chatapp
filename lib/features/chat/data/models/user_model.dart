import 'package:chatapp/features/chat/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  const UserModel({required this.id, required this.email, required this.name});

  final String id;
  final String email;
  final String name;

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? const <String, dynamic>{};
    return UserModel(
      id: document.id,
      email: data['email'] as String? ?? '',
      name: data['name'] as String? ?? 'Unknown',
    );
  }

  UserEntity toEntity() => UserEntity(id: id, email: email, name: name);
}
