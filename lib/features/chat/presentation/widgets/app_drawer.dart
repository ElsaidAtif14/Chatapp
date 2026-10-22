import 'package:chatapp/core/helper/show_snack_bar.dart';
import 'package:chatapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chatapp/features/auth/presentation/cubit/auth_state.dart';
import 'package:chatapp/features/auth/presentation/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Center(child: Icon(Icons.message, size: 60)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: const Text('H O M E'),
                  leading: const Icon(Icons.home),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text('S E T T I N G S'),
                  leading: Icon(Icons.settings),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              title: const Text('L O G O U T'),
              leading: const Icon(Icons.logout),
              onTap: () async {
                final signedOut = await context.read<AuthCubit>().signOut();
                if (!context.mounted) {
                  return;
                }
                if (signedOut) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    WelcomePage.id,
                    (_) => false,
                  );
                  showSnackBar(context, 'Signed out successfully');
                } else {
                  final errorMessage = switch (context
                      .read<AuthCubit>()
                      .state) {
                    AuthFailure(:final message) => message,
                    AuthInitial() ||
                    AuthLoading() ||
                    AuthSuccess() ||
                    Unauthenticated() => 'Unable to sign out.',
                  };
                  showSnackBar(context, errorMessage);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
