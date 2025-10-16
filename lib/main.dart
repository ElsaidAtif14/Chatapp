import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/screens/home_page.dart';
import 'package:chatapp/screens/sign_in_page.dart';
import 'package:chatapp/screens/sign_up_page.dart';

import 'package:chatapp/screens/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ScholarChat());
}
class ScholarChat extends StatelessWidget {
  const ScholarChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        WelcomePage.id:(context)=>WelcomePage(),
        SignInPage.id:(context)=>SignInPage(),
        SignUpPage.id:(context)=>SignUpPage(),
        HomePage.id:(context)=>HomePage()
      },
      initialRoute: WelcomePage.id,
      home: WelcomePage(),
    );
  }
}