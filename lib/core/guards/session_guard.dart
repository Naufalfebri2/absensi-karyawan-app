class SessionGuard {
  static bool isSessionExpired(DateTime expiryTime) {
    return DateTime.now().isAfter(expiryTime);
  }
}
