// --- Data Layer Exceptions ---
// These are typically caught within your Repository implementation

/// Base class for exceptions originating from data sources.
abstract class DataSourceException implements Exception {
  final String message;
  final dynamic originalException; // Keep the original exception for logging/debugging
  final StackTrace? stackTrace;

  DataSourceException(this.message, [this.originalException, this.stackTrace]);

  @override
  String toString() => '$runtimeType: $message'
      '${originalException != null ? '\nOriginal Exception: $originalException' : ''}'
      '${stackTrace != null ? '\nStackTrace: $stackTrace' : ''}';
}

/// Exception for errors returned specifically by Firebase services (Auth, Firestore, Storage, etc.).
class FirebaseDataSourceException extends DataSourceException {
  /// The specific error code provided by the Firebase SDK (e.g., 'user-not-found').
  final String code;

  FirebaseDataSourceException({
    required this.code,
    required String message,
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(message, originalException, stackTrace);

  @override
  String toString() => 'FirebaseDataSourceException(code: $code, message: $message)'
      '${originalException != null ? '\nOriginal Exception: $originalException' : ''}'
      '${stackTrace != null ? '\nStackTrace: $stackTrace' : ''}';
}

/// Exception for errors related to local caching operations.
class CacheException extends DataSourceException {
  CacheException(String message, [dynamic originalException, StackTrace? stackTrace])
      : super('Cache Error: $message', originalException, stackTrace);
}

/// Exception for network connectivity issues detected locally (e.g., no internet connection check).
/// Note: Firebase also reports network errors via FirebaseDataSourceException with specific codes.
class NetworkException extends DataSourceException {
  NetworkException(String message, [dynamic originalException, StackTrace? stackTrace])
      : super('Local Network Error: $message', originalException, stackTrace);
}

/// Exception for unexpected errors during data handling.
class UnexpectedDataSourceException extends DataSourceException {
  UnexpectedDataSourceException(String message, [dynamic originalException, StackTrace? stackTrace])
      : super('Unexpected Data Source Error: $message', originalException, stackTrace);
}