import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<User> signUpWithEmail(String name, String email, String password);

  Future<User> signInWithEmail(String email, String password);

  Future<User> signInWithGoogle();

  Future<void> logout();

  User? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firebaseFirestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.firebaseFirestore,
  });

  @override
  Future<User> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User user = userCredential.user!;

    // await firebaseFirestore.collection('users').doc(user.uid).set({
    //   'uid': user.uid,
    //   'name': name,
    //   'email': user.email,
    //   'displayName': user.displayName,
    //   'photoURL': user.photoURL,
    //   'created_at': Timestamp.now(),
    //   'last_sign_in': Timestamp.now(),
    // });

    return user;
  }

  @override
  Future<User> signInWithEmail(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User user = userCredential.user!;

    // try {
    //   await firebaseFirestore.collection('users').doc(user.uid).update({
    //     'last_sign_in': Timestamp.now(),
    //   });
    // } catch (e) {
    //   print("Warning: Failed to update last_sign_in for ${user.uid}: $e");
    // }

    return user;
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'sign-in-cancelled',
        message: 'Google sign-in was cancelled by the user.',
      );
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await firebaseAuth.signInWithCredential(credential);

    final User user = userCredential.user!;

    // final userDocRef = firebaseFirestore.collection('users').doc(user.uid);
    // final userDoc = await userDocRef.get();
    //
    // final userData = {
    //   'uid': user.uid,
    //   'name': user.displayName ?? googleUser.displayName ?? 'N/A',
    //   'email': user.email,
    //   'photoURL': user.photoURL ?? googleUser.photoUrl,
    //   'last_sign_in': Timestamp.now(),
    // };
    //
    // if (!userDoc.exists) {
    //   userData['created_at'] = Timestamp.now();
    //   try {
    //     await userDocRef.set(userData);
    //   } catch (e) {
    //     print(
    //       "Warning: Failed to create Firestore doc for new Google user ${user.uid}: $e",
    //     );
    //   }
    // } else {
    //   try {
    //     await userDocRef.update(userData);
    //   } catch (e) {
    //     print(
    //       "Warning: Failed to update Firestore doc for Google user ${user.uid}: $e",
    //     );
    //   }
    // }

    return user;
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();

    try {
      await googleSignIn.signOut();
    } catch (e) {
      print(
        "Warning: Error during Google Sign Out (might be expected if not signed in with Google): $e",
      );
    }
  }

  @override
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }
}
