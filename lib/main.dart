import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/core/theme/app_theme.dart';
import 'package:social_media/features/auth/presentation/screens/login_screen.dart';

import 'app_router.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/post/presentation/bloc/post_bloc.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<PostBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Social Media',
        theme: lightMode,
        routerConfig: router,
      ),
    );
  }
}
