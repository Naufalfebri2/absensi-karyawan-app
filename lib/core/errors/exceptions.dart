// ===============================
// EXCEPTIONS (DATA LAYER ONLY)
//===============================

abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

// ===============================
// SERVER EXCEPTION
// ===============================
class ServerException extends AppException {
  const ServerException(super.message);
}

// ===============================
// NETWORK EXCEPTION
// ===============================
class NetworkException extends AppException {
  const NetworkException(super.message);
}

// ===============================
// CACHE / LOCAL EXCEPTION
// ===============================
class CacheException extends AppException {
  const CacheException(super.message);
}

// ===============================
// UNAUTHORIZED EXCEPTION
// ===============================
class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message);
}
