class ServerException implements Exception {
  final String message;
  ServerException([this.message = "Server error occurred"]);
}

class CacheException implements Exception {}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = "Unauthorized"]);
}
