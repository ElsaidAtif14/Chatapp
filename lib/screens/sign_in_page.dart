import 'package:chatapp/helper/Show_Snak_bar.dart';
import 'package:chatapp/helper/show_alart.dart';
import 'package:chatapp/screens/home_page.dart';
import 'package:chatapp/widgets/custom_animated_text.dart';
import 'package:chatapp/widgets/custom_button.dart';
import 'package:chatapp/widgets/custom_text.dart';
import 'package:chatapp/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  static String id = 'SignInPage';
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        titleSpacing: 0,
        title: Text('Back', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              SizedBox(height: 40),
              CustomText(
                text: 'Sign in',
                color: Color(0xff4280EF),
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              CustomAnimatedText(text: 'Please log in into your account'),
              SizedBox(height: 40),
              CustomTextFormField(
                text: 'Email',
                controller: email,
                hintText: 'Enter Your Email',
                validation: (value) {
                  if (value!.isEmpty) {
                    return "Enter a valid Email";
                  }
                },
                ispasssword: false,
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                text: 'Password',
                controller: password,
                hintText: 'Enter Your Password',
                validation: (value) {
                  if (value!.length < 8) {
                    return "Enter a valid password";
                  }
                },
                ispasssword: true,
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Hero(
                  tag: 'signtag',
                  child: CustomButton(
                    text: 'Login',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          UserCredential userCredential = 
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );

                          // تأكد من وجود المستخدم في Firestore
                          DocumentSnapshot userDoc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userCredential.user!.uid)
                              .get();

                          if (!userDoc.exists) {
                            // إذا المستخدم غير موجود في Firestore، قم بإنشائه
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(userCredential.user!.uid)
                                .set({
                              'email': email.text,
                              'name': email.text.substring(0, email.text.indexOf('@')),
                              'createdAt': FieldValue.serverTimestamp(),
                              'uid': userCredential.user!.uid,
                            });
                          }

                          Navigator.pushNamed(context, HomePage.id);
                          showSnakBar(context, 'Logged in successfully!');
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            showSnakBar(context, 'No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            showSnakBar(
                              context,
                              'Wrong password provided for that user.',
                            );
                          } else {
                            showAlert(context, 'Something Error', '${e.message}');
                          }
                        } catch (e) {
                          showAlert(context, 'Error', 'Something went wrong: $e');
                        }
                      } else {
                        debugPrint('Sign in failed');
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