// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../presentation/splash/splash_page.dart';
// import '../presentation/auth/pages/login_page.dart';
// import '../presentation/auth/pages/otp_page.dart';
// import '../presentation/auth/pages/forgot_password_page.dart';

// import '../presentation/home/pages/home_page.dart';
// import '../presentation/dashboard/pages/dashboard_page.dart';

// import '../presentation/attendance/pages/checkin_page.dart';
// import '../presentation/attendance/pages/checkout_page.dart';
// import '../presentation/attendance/pages/attendance_history_page.dart';

// import '../presentation/leave/pages/leave_form_page.dart';
// import '../presentation/leave/pages/leave_list_page.dart';

// import '../presentation/shift/pages/shift_calendar_page.dart';
// import '../presentation/shift/pages/shift_detail_page.dart';

// import '../presentation/notifications/pages/notification_page.dart';

// import '../presentation/admin/pages/manage_users_page.dart';
// import '../presentation/admin/pages/manage_department_page.dart';
// import '../presentation/admin/pages/manage_shift_page.dart';

// import 'route_guard.dart';

// class AppRouter {
//   static final GoRouter router = GoRouter(
//     initialLocation: "/splash",
//     redirect: RouteGuard.globalRedirect,
//     routes: [
//       /// ============= SPLASH ============
//       GoRoute(
//         path: "/splash",
//         name: "splash",
//         builder: (_, __) => const SplashPage(),
//       ),

//       /// ============= AUTH =============
//       GoRoute(
//         path: "/login",
//         name: "login",
//         builder: (_, __) => const LoginPage(),
//       ),
//       GoRoute(
//         path: "/otp",
//         name: "otp",
//         builder: (_, state) => OtpPage(email: state.extra as String),
//       ),
//       GoRoute(
//         path: "/forgot-password",
//         name: "forgot_password",
//         builder: (_, __) => const ForgotPasswordPage(),
//       ),

//       /// ============= HOME ============
//       GoRoute(
//         path: "/home",
//         name: "home",
//         builder: (_, __) => const HomePage(),
//         redirect: RouteGuard.authGuard,
//       ),

//       /// ============= ADMIN DASHBOARD ============
//       GoRoute(
//         path: "/dashboard",
//         name: "dashboard",
//         builder: (_, __) => const DashboardPage(),
//         redirect: RouteGuard.adminGuard,
//       ),

//       /// ============= ATTENDANCE ============
//       GoRoute(
//         path: "/checkin",
//         name: "checkin",
//         builder: (_, __) => const CheckinPage(),
//         redirect: RouteGuard.authGuard,
//       ),
//       GoRoute(
//         path: "/checkout",
//         name: "checkout",
//         builder: (_, __) => const CheckoutPage(),
//         redirect: RouteGuard.authGuard,
//       ),
//       GoRoute(
//         path: "/attendance-history",
//         name: "attendance_history",
//         builder: (_, __) => const AttendanceHistoryPage(),
//         redirect: RouteGuard.authGuard,
//       ),

//       /// ============= LEAVE ============
//       GoRoute(
//         path: "/leave-form",
//         name: "leave_form",
//         builder: (_, __) => const LeaveFormPage(),
//         redirect: RouteGuard.authGuard,
//       ),
//       GoRoute(
//         path: "/leave-list",
//         name: "leave_list",
//         builder: (_, __) => const LeaveListPage(),
//         redirect: RouteGuard.authGuard,
//       ),

//       /// ============= SHIFT ============
//       GoRoute(
//         path: "/shift-calendar",
//         name: "shift_calendar",
//         builder: (_, __) => const ShiftCalendarPage(),
//         redirect: RouteGuard.authGuard,
//       ),
//       GoRoute(
//         path: "/shift-detail",
//         name: "shift_detail",
//         builder: (_, state) => ShiftDetailPage(shift: state.extra),
//         redirect: RouteGuard.authGuard,
//       ),

//       /// ============= NOTIFICATIONS ============
//       GoRoute(
//         path: "/notifications",
//         name: "notifications",
//         builder: (_, __) => const NotificationPage(),
//         redirect: RouteGuard.authGuard,
//       ),

//       /// ============= ADMIN ============
//       GoRoute(
//         path: "/manage-users",
//         name: "manage_users",
//         builder: (_, __) => const ManageUsersPage(),
//         redirect: RouteGuard.adminGuard,
//       ),
//       GoRoute(
//         path: "/manage-department",
//         name: "manage_department",
//         builder: (_, __) => const ManageDepartmentPage(),
//         redirect: RouteGuard.adminGuard,
//       ),
//       GoRoute(
//         path: "/manage-shift",
//         name: "manage_shift",
//         builder: (_, __) => const ManageShiftPage(),
//         redirect: RouteGuard.adminGuard,
//       ),
//     ],
//   );
// }
