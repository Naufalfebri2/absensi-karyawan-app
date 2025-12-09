class RoleGuard {
  static bool hasAccess(String role, List<String> allowedRoles) {
    return allowedRoles.contains(role);
  }
}
