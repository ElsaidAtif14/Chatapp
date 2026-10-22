import 'package:chatapp/features/auth/data/models/auth_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource {
  FirebaseAuthDataSource({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<AuthUserModel> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Firebase Auth returned no user after sign-in.');
    }

    final userDocument = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDocument.get();
    if (!snapshot.exists) {
      final model = AuthUserModel.fromFirebaseUser(user);
      await userDocument.set({
        'email': model.email,
        'name': model.name,
        'uid': model.id,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return model;
    }

    final data = snapshot.data();
    return AuthUserModel.fromFirebaseUser(user, name: data?['name'] as String?);
  }

  Future<AuthUserModel> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError(
        'Firebase Auth returned no user after account creation.',
      );
    }

    final model = AuthUserModel.fromFirebaseUser(user);
    await _firestore.collection('users').doc(user.uid).set({
      'email': model.email,
      'name': model.name,
      'uid': model.id,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return model;
  }

  Future<void> signOut() => _auth.signOut();
}
