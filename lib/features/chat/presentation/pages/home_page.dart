import 'package:chatapp/core/di/injection_container.dart';
import 'package:chatapp/features/chat/presentation/cubit/users/users_cubit.dart';
import 'package:chatapp/features/chat/presentation/widgets/app_drawer.dart';
import 'package:chatapp/features/chat/presentation/widgets/users_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String id = 'homepage';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UsersCubit>()..watchUsers(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Pacifico',
            ),
          ),
          centerTitle: true,
        ),
        drawer: const AppDrawer(),
        body: const UsersList(),
      ),
    );
  }
}
