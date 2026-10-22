import 'package:chatapp/core/helper/show_snack_bar.dart';
import 'package:chatapp/core/widgets/custom_animated_text.dart';
import 'package:chatapp/core/widgets/custom_button.dart';
import 'package:chatapp/core/widgets/custom_text.dart';
import 'package:chatapp/core/widgets/custom_text_form_field.dart';
import 'package:chatapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chatapp/features/auth/presentation/cubit/auth_state.dart';
import 'package:chatapp/features/chat/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const String id = 'SignUpPage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthSuccess():
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomePage.id,
              (_) => false,
            );
            showSnackBar(context, 'Account created successfully!');
            break;
          case AuthFailure(:final message):
            showSnackBar(context, message);
            break;
          case AuthInitial() ||
                AuthLoading() ||
                Unauthenticated():
            break;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 14),
            child: IconButton(
              onPressed: Navigator.of(context).pop,
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
            key: _formKey,
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
                  controller: _email,
                  hintText: 'Enter Your Email',
                  validation: (value) => value == null || value.isEmpty
                      ? 'Enter a valid Email'
                      : null,
                  ispasssword: false,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  text: 'Password',
                  controller: _password,
                  hintText: 'Enter Your Password',
                  validation: (value) => value == null || value.length < 8
                      ? 'Enter a valid password'
                      : null,
                  ispasssword: true,
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Hero(
                    tag: 'signtag',
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return switch (state) {
                          AuthLoading() => CustomButton(
                            text: 'Sign Up',
                            isLoading: true,
                            onTap: () {},
                          ),
                          AuthInitial() ||
                          AuthSuccess() ||
                          AuthFailure() ||
                          Unauthenticated() => CustomButton(
                            text: 'Sign Up',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().signUp(
                                  email: _email.text,
                                  password: _password.text,
                                );
                              }
                            },
                          ),
                        };
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
