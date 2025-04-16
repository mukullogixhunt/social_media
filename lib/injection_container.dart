import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'features/auth/auth_injection.dart';
import 'features/post/post_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => GoogleSignIn())
    ..registerLazySingleton(() => FirebaseFirestore.instance);

  initAuth();
  initPost();
}
