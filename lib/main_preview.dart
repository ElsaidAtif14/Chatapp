import 'package:chatapp/core/firebase/firebase_options.dart';
import 'package:chatapp/core/di/injection_container.dart';
import 'package:chatapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chatapp/features/auth/presentation/pages/sign_in_page.dart';
import 'package:chatapp/features/auth/presentation/pages/sign_up_page.dart';
import 'package:chatapp/features/auth/presentation/pages/welcome_page.dart';
import 'package:chatapp/features/chat/presentation/pages/home_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: const ScholarChat(),
      ),
    ),
  );
}

class ScholarChat extends StatelessWidget {
  const ScholarChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      initialRoute: WelcomePage.id,
      routes: {
        WelcomePage.id: (_) => const WelcomePage(),
        SignInPage.id: (_) => const SignInPage(),
        SignUpPage.id: (_) => const SignUpPage(),
        HomePage.id: (_) => const HomePage(),
      },
    );
  }
}
