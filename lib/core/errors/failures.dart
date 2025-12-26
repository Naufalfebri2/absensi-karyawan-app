import 'package:equatable/equatable.dart';

// ===============================
// FAILURE (DOMAIN LAYER)
// ===============================

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

// ===============================
// SERVER FAILURE
// ===============================
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// ===============================
// NETWORK FAILURE
// ===============================
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

// ===============================
// CACHE FAILURE
// ===============================
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// ===============================
// UNAUTHORIZED FAILURE
// ===============================
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}
