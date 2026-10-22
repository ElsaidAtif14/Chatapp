import 'package:chatapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chatapp/features/auth/presentation/cubit/auth_state.dart';
import 'package:chatapp/features/chat/presentation/cubit/users/users_cubit.dart';
import 'package:chatapp/features/chat/presentation/cubit/users/users_state.dart';
import 'package:chatapp/features/chat/presentation/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersList extends StatelessWidget {
  const UsersList({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final isAuthenticated = switch (authState) {
      AuthSuccess() => true,
      AuthLoading(:final user) || AuthFailure(:final user) => user != null,
      AuthInitial() || Unauthenticated() => false,
    };
    if (!isAuthenticated) {
      return const Center(child: Text('Sign in to view users.'));
    }

    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        switch (state) {
          case UsersInitial() || UsersLoading():
            return const Center(child: CircularProgressIndicator());
          case UsersFailure(:final message):
            return Center(child: Text('Error loading users: $message'));
          case UsersLoaded(:final users):
            if (users.isEmpty) {
              return const Center(child: Text('No users found'));
            }
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) => UserTile(user: users[index]),
            );
        }
      },
    );
  }
}
