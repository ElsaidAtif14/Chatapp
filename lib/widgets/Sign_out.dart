import 'package:chatapp/screens/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signed out successfully'),
        duration: Duration(seconds: 1),
      ),
    );
    // بعد تسجيل الخروج، ممكن ترجّع المستخدم لصفحة البداية
    Navigator.pushReplacementNamed(context, WelcomePage.id);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error while signing out: $e'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
