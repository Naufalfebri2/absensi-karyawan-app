class ApiEndpoints {
  // AUTH
  static const login = "/auth/login";
  static const verifyOtp = "/auth/verify-otp";

  // ATTENDANCE
  static const checkIn = "/attendance/checkin";
  static const checkOut = "/attendance/checkout";
  static const attendanceHistory = "/attendance/history";
  static const attendanceDetail = "/attendance/detail";

// LEAVE
  static const leaveSubmit = "/leave/submit";
  static const leaveList = "/leave/list";
  static const leaveApprove = "/leave/approve";
  static const leaveHistory = "/leave/history";

// SHIFT (Employee)
  static const shiftList = "/shift/list";

// USER
  static const userProfile = "/user/profile";

// NOTIFICATION
  static const notificationList = "/notifications";

  // EMPLOYEE MANAGEMENT
  static const adminUsers = "/admin/users";
  static const adminDepartments = "/admin/departments";

  // Tambahkan modul CRUD user khusus ADMIN
  static const adminCreateUser = "/admin/users/create";
  static const adminUpdateUser = "/admin/users/update";
  static const adminDeleteUser = "/admin/users/delete";

  // SHIFT MANAGEMENT (ADMIN)
  static const adminShifts = "/admin/shifts";
  static const adminCreateShift = "/admin/shifts/create";
  static const adminUpdateShift = "/admin/shifts/update";
  static const adminDeleteShift = "/admin/shifts/delete";
}
