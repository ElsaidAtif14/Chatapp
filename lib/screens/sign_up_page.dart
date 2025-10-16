import 'dart:async';
import 'dart:io';

import 'package:chatapp/helper/Show_Snak_bar.dart';
import 'package:chatapp/helper/show_alart.dart';
import 'package:chatapp/screens/home_page.dart';
import 'package:chatapp/widgets/custom_animated_text.dart';
import 'package:chatapp/widgets/custom_button.dart';
import 'package:chatapp/widgets/custom_text.dart';
import 'package:chatapp/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static String id = 'SignUpPage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

CollectionReference users = FirebaseFirestore.instance.collection('users');

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        titleSpacing: 0,
        title: const Text(
          'Back',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(height: 40),
              const CustomText(
                text: 'Sign Up',
                color: Color(0xff4280EF),
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              const CustomAnimatedText(text: 'Create a new account'),
              const SizedBox(height: 40),
              CustomTextFormField(
                text: 'Email',
                controller: email,
                hintText: 'Enter Your Email',
                validation: (value) {
                  if (value!.isEmpty) {
                    return "Enter a valid Email";
                  }
                  return null;
                },
                ispasssword: false,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                text: 'Password',
                controller: password,
                hintText: 'Enter Your Password',
                validation: (value) {
                  if (value!.length < 8) {
                    return "Enter a valid password";
                  }
                  return null;
                },
                ispasssword: true,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Hero(
                  tag: 'signtag',
                  child: CustomButton(
                    text: 'Sign Up',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          // 1. إنشاء المستخدم في Authentication
                          UserCredential userCredential = 
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );

                          // 2. حفظ بيانات المستخدم في Firestore بنفس الـ UID
                          await users.doc(userCredential.user!.uid).set({
                            'email': email.text,
                            'name': email.text.substring(0, email.text.indexOf('@')),
                            'createdAt': FieldValue.serverTimestamp(),
                            'uid': userCredential.user!.uid, // حفظ الـ UID
                          });

                          Navigator.pushNamed(context, HomePage.id);
                          showSnakBar(context, 'Account created successfully!');
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            showSnakBar(
                              context,
                              'The password provided is too weak.',
                            );
                          } else if (e.code == 'email-already-in-use') {
                            showSnakBar(
                              context,
                              'The account already exists for that email.',
                            );
                          } else {
                            showAlert(
                              context,
                              'Something Error',
                              '${e.message}',
                            );
                          }
                        } catch (e) {
                          showAlert(context, 'Error', 'Something went wrong: $e');
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}