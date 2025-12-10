// import 'package:go_router/go_router.dart';
// import '../../core/services/local_storage_service.dart';

// class RouteGuard {
//   /// GLOBAL REDIRECT
//   static Future<String?> globalRedirect(GoRouterState state) async {
//     final token = await LocalStorageService.getToken();

//     // Jika belum login → paksa ke login page
//     if (token == null || token.isEmpty) {
//       if (state.location == "/login" || state.location == "/splash") {
//         return null; // biarkan
//       }
//       return "/login";
//     }

//     // Jika sudah login dan mencoba kembali ke login → arahkan ke home
//     if (state.location == "/login") {
//       return "/home";
//     }

//     return null; // tidak ada redirect
//   }

//   /// AUTH GUARD (LOGIN)
//   static Future<String?> authGuard(GoRouterState state) async {
//     final token = await LocalStorageService.getToken();

//     if (token == null || token.isEmpty) {
//       return "/login";
//     }

//     return null;
//   }

//   /// ADMIN ROLE GUARD (HR)
//   static Future<String?> adminGuard(GoRouterState state) async {
//     final token = await LocalStorageService.getToken();
//     final role = await LocalStorageService.getRole();

//     if (token == null || token.isEmpty) {
//       return "/login";
//     }

//     if (role != "admin" && role != "hr") {
//       return "/home"; // Tidak punya izin
//     }

//     return null;
//   }
// }
