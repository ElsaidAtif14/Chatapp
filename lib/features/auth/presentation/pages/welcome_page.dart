import 'package:chatapp/core/widgets/custom_animated_text.dart';
import 'package:chatapp/core/widgets/custom_button.dart';
import 'package:chatapp/core/widgets/custom_text.dart';
import 'package:chatapp/features/auth/presentation/pages/sign_in_page.dart';
import 'package:chatapp/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const String id = 'welcomepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset('assets/images/X.png'),
          ),
          Positioned(
            left: 0,
            top: 130,
            child: Image.asset('assets/images/R.png'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 130),
                const CustomText(
                  text: 'Welcome',
                  color: Color(0xff4280EF),
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
                const CustomAnimatedText(text: "Let's get started"),
                const Spacer(flex: 1),
                const CustomText(
                  text: 'Existing customer / Get started',
                  color: Color(0xff2C2C2C),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 10),
                Hero(
                  tag: 'signtag',
                  child: CustomButton(
                    text: 'Sign in',
                    onTap: () {
                      Navigator.pushNamed(context, SignInPage.id);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const CustomText(
                      text: 'New customer? ',
                      color: Color(0xff2C2C2C),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignUpPage.id);
                      },
                      child: const CustomText(
                        text: 'Create new account',
                        color: Color(0xff4280EF),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
