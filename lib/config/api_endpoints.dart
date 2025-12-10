class ApiEndpoints {
  // ===========================
  // AUTH
  // ===========================
  static const login = "/auth/login";
  static const verifyOtp = "/auth/verify-otp";

  // ===========================
  // ATTENDANCE
  // ===========================
  static const checkIn = "/attendance/checkin";
  static const checkOut = "/attendance/checkout";
  static const attendanceHistory = "/attendance/history";
  static const attendanceDetail = "/attendance/detail";

  /// NEW → Untuk Get Absensi Hari Ini
  static const todayAttendance = "/attendance/today";

  // ===========================
  // LEAVE
  // ===========================
  static const leaveSubmit = "/leave/submit";
  static const leaveList = "/leave/list";
  static const leaveApprove = "/leave/approve";
  static const leaveHistory = "/leave/history";

  // ===========================
  // SHIFT (Employee)
  // ===========================
  static const shiftList = "/shift/list";

  // ===========================
  // USER
  // ===========================
  static const userProfile = "/user/profile";

  // ===========================
  // NOTIFICATION
  // ===========================
  static const notificationList = "/notifications";

  // ===========================
  // ADMIN MANAGEMENT
  // ===========================
  static const adminUsers = "/admin/users";
  static const adminDepartments = "/admin/departments";

  // CRUD User — Admin
  static const adminCreateUser = "/admin/users/create";
  static const adminUpdateUser = "/admin/users/update";
  static const adminDeleteUser = "/admin/users/delete";

  // CRUD Department — Admin
  static const adminCreateDepartment = "/admin/departments/create";
  static const adminUpdateDepartment = "/admin/departments/update";
  static const adminDeleteDepartment = "/admin/departments/delete";

  // CRUD Shift — Admin
  static const adminShifts = "/admin/shifts";
  static const adminCreateShift = "/admin/shifts/create";
  static const adminUpdateShift = "/admin/shifts/update";
  static const adminDeleteShift = "/admin/shifts/delete";
}
