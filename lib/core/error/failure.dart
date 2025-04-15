import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// --- Presentation Layer Failures ---
// These are returned by Repositories to the Use Cases/Blocs/ViewModels

/// Base class for all failures reported to the presentation layer.
abstract class Failure extends Equatable {
  /// A user-friendly or developer-friendly message describing the failure.
  final String message;

  /// The specific error code, often from Firebase, for precise UI handling. Can be null.
  final String? code;

  /// The original exception, useful for debugging or more detailed logging. Can be null.
  final dynamic originalException;

  const Failure(this.message, {this.code, this.originalException});

  @override
  List<Object?> get props => [message, code, originalException];

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

// --- Firebase Specific Failures ---

/// Failure related to Firebase Authentication operations.
class AuthFailure extends Failure {
  const AuthFailure({
    required String message,
    required String code,
    dynamic originalException,
  }) : super(message, code: code, originalException: originalException);

  /// Provides a more user-friendly message based on common Auth error codes.
  /// Falls back to the original message if the code is unknown.
  String get userFriendlyMessage {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found for this email/identifier.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email address is already registered.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'requires-recent-login':
        return 'This operation requires you to re-authenticate. Please log out and log back in.';
      case 'too-many-requests':
        return 'We have detected too many requests from your device. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';

      default:
        return message;
    }
  }
}

/// Failure related to Firestore operations.
class FirestoreFailure extends Failure {
  const FirestoreFailure({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(message, code: code, originalException: originalException);

  String get userFriendlyMessage {
    switch (code) {
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'unauthenticated':
        return 'You must be logged in to perform this action.';
      case 'not-found':
        return 'The requested document or resource was not found.';
      case 'unavailable':
        return 'The service is currently unavailable. Please try again later.';
      case 'resource-exhausted':
        return 'Quota exceeded. Please try again later or contact support.';
      case 'cancelled':
        return 'The operation was cancelled.';

      default:
        return message;
    }
  }
}

/// Failure related to Firebase Storage operations.
class StorageFailure extends Failure {
  const StorageFailure({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(message, code: code, originalException: originalException);

  String get userFriendlyMessage {
    switch (code) {
      case 'object-not-found':
        return 'The file or object was not found.';
      case 'unauthorized':
        return 'You are not authorized to perform this action.';
      case 'unauthenticated':
        return 'You must be logged in to perform this action.';
      case 'retry-limit-exceeded':
        return 'Maximum retry attempts reached. Please try again.';
      case 'canceled':
        return 'The operation was cancelled.';
      case 'quota-exceeded':
        return 'Storage quota exceeded. Please manage your files or upgrade your plan.';

      default:
        return message;
    }
  }
}

/// Failure related to Cloud Functions operations.
class FunctionsFailure extends Failure {
  const FunctionsFailure({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(message, code: code, originalException: originalException);

  String get userFriendlyMessage {
    switch (code) {
      case 'internal':
        return 'An internal server error occurred. Please try again later.';
      case 'deadline-exceeded':
        return 'The operation timed out. Please try again.';
      case 'unauthenticated':
        return 'You must be logged in to perform this action.';
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'not-found':
        return 'The requested function or resource was not found.';
      case 'unavailable':
        return 'The function is temporarily unavailable. Please try again later.';

      default:
        return message;
    }
  }
}

// --- General Failures ---

/// Failure indicating a problem with network connectivity.
/// This can originate from a local check or from Firebase reporting a network issue.
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message =
        'Network Error: Please check your connection and try again.',
    String? code,
    dynamic originalException,
  }) : super(message, code: code, originalException: originalException);
}

/// Failure related to local caching operations.
class CacheFailure extends Failure {
  const CacheFailure({required String message, dynamic originalException})
    : super('Cache Failure: $message', originalException: originalException);
}

/// Failure for unexpected errors that weren't caught by more specific types.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(
         'Unexpected Error: $message',
         code: code,
         originalException: originalException,
       );
}

// --- Helper for Mapping ---
// You would typically use this in your Repository implementation's catch blocks

Failure handleFirebaseFailure(FirebaseException e, [StackTrace? s]) {
  print(
    'FirebaseException caught: Code: ${e.code}, Message: ${e.message}, Stacktrace: $s',
  );

  switch (e.code) {
    // --- Auth Codes ---
    case 'invalid-email':
    case 'user-disabled':
    case 'user-not-found':
    case 'wrong-password':
    case 'email-already-in-use':
    case 'operation-not-allowed':
    case 'weak-password':
    case 'requires-recent-login':
    case 'too-many-requests':
      return AuthFailure(
        message: e.message ?? 'Authentication error occurred.',
        code: e.code,
        originalException: e,
      );

    // --- Firestore Codes ---
    case 'permission-denied':
    case 'unauthenticated':
    case 'not-found':
    case 'unavailable':
    case 'resource-exhausted':
    case 'cancelled':
      return FirestoreFailure(
        message: e.message ?? 'Database error occurred.',
        code: e.code,
        originalException: e,
      );

    // --- Storage Codes ---
    case 'object-not-found':
    case 'unauthorized':
    case 'retry-limit-exceeded':
    case 'canceled':
    case 'quota-exceeded':
      return StorageFailure(
        message: e.message ?? 'Storage error occurred.',
        code: e.code,
        originalException: e,
      );

    // --- Functions Codes (Example, might overlap) ---
    case 'internal':
    case 'deadline-exceeded':
      return FunctionsFailure(
        message: e.message ?? 'Cloud function error occurred.',
        code: e.code,
        originalException: e,
      );

    // --- Network Code ---
    case 'network-request-failed':
      return NetworkFailure(
        message: e.message ?? 'Network error.',
        code: e.code,
        originalException: e,
      );

    // --- Default/Unexpected Firebase Error ---
    default:
      return UnexpectedFailure(
        message: e.message ?? 'An unknown Firebase error occurred.',
        code: e.code,
        originalException: e,
      );
  }



}


String mapFailureToMessage(Failure failure) {
  if (failure is AuthFailure) {
    return failure.userFriendlyMessage;
  } else if (failure is FirestoreFailure) {
    return failure.userFriendlyMessage;
  } else if (failure is StorageFailure) {
    return failure.userFriendlyMessage;
  } else if (failure is FunctionsFailure) {
    return failure.userFriendlyMessage;
  } else if (failure is NetworkFailure) {
    return failure.message;
  } else if (failure is CacheFailure) {
    return failure.message;
  } else if (failure is UnexpectedFailure) {
    print(
      "Unexpected Failure occurred: ${failure.message} (Code: ${failure.code}, Original: ${failure.originalException})",
    );
    return 'An unexpected error occurred. Please try again later.';
  } else {
    print(
      "Unknown Failure type: ${failure.runtimeType}, Message: ${failure.message}",
    );
    return 'An unknown error occurred. Please check your connection or try again later.';
  }
}

