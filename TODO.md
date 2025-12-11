# TODO: Fix LoginUser Constructor Error

## Tasks:
- [x] Tambahkan import untuk AuthRepositoryImpl dan AuthRemote di main.dart
- [x] Buat instance AuthRemote dengan DioClient.instance
- [x] Buat instance AuthRepositoryImpl dengan AuthRemote
- [x] Pass AuthRepositoryImpl ke LoginUser dan OtpVerify constructors
- [x] Perbaiki test/widget_test.dart untuk menggunakan authRepository
- [x] Test aplikasi untuk memastikan error teratasi
