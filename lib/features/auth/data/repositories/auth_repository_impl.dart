import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:social_media/core/error/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource);

  @override
  User? getCurrentUser() {
    try {
      return _authRemoteDataSource.getCurrentUser();
    } catch (e, s) {
      print("Unexpected error in getCurrentUser: $e\n$s");

      return null;
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final user = await _authRemoteDataSource.signInWithEmail(email, password);

      return Right(user);
    } on FirebaseAuthException catch (e, s) {
      return Left(handleFirebaseFailure(e, s));
    } on SocketException catch (e, s) {
      print("Network Error (SocketException) during sign in: $e\n$s");
      return Left(NetworkFailure(originalException: e));
    } catch (e, s) {
      print("Unexpected error during sign in: $e\n$s");
      return Left(
        UnexpectedFailure(
          message: 'An unexpected error occurred during sign in.',
          originalException: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final user = await _authRemoteDataSource.signInWithGoogle();

      return Right(user);
    } on FirebaseAuthException catch (e, s) {
      return Left(handleFirebaseFailure(e, s));
    } on SocketException catch (e, s) {
      print("Network Error (SocketException) during Google sign in: $e\n$s");
      return Left(NetworkFailure(originalException: e));
    } catch (e, s) {
      print("Unexpected error during Google sign in: $e\n$s");

      return Left(
        UnexpectedFailure(
          message: 'An unexpected error occurred during Google sign in.',
          originalException: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _authRemoteDataSource.logout();

      return const Right(null);
    } on FirebaseAuthException catch (e, s) {
      return Left(handleFirebaseFailure(e, s));
    } on SocketException catch (e, s) {
      print("Network Error (SocketException) during sign out: $e\n$s");
      return Left(NetworkFailure(originalException: e));
    } catch (e, s) {
      print("Unexpected error during sign out: $e\n$s");
      return Left(
        UnexpectedFailure(
          message: 'An unexpected error occurred during sign out.',
          originalException: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      final user = await _authRemoteDataSource.signUpWithEmail(
        name,
        email,
        password,
      );
      return Right(user);
    } on FirebaseAuthException catch (e, s) {
      return Left(handleFirebaseFailure(e, s));
    } on SocketException catch (e, s) {
      print("Network Error (SocketException) during sign up: $e\n$s");
      return Left(NetworkFailure(originalException: e));
    } catch (e, s) {
      print("Unexpected error during sign up: $e\n$s");
      return Left(
        UnexpectedFailure(
          message: 'An unexpected error occurred during sign up.',
          originalException: e,
        ),
      );
    }
  }
}
