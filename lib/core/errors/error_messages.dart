// ===============================
// ERROR MESSAGES
// ===============================

class ErrorMessages {
  static const String unknownError = 'Terjadi kesalahan yang tidak diketahui';
  static const String serverError = 'Terjadi kesalahan pada server';
  static const String networkError = 'Koneksi internet bermasalah';
  static const String timeoutError = 'Koneksi ke server terputus';
  static const String unauthorized =
      'Sesi Anda telah berakhir, silakan login kembali';
  static const String forbidden = 'Anda tidak memiliki akses ke fitur ini';
  static const String notFound = 'Data tidak ditemukan';

  static const String invalidCredential = 'Email atau password salah';
  static const String otpInvalid = 'Kode OTP tidak valid';
  static const String otpExpired = 'Kode OTP sudah kedaluwarsa';

  static const String outsideOfficeRadius = 'Anda berada di luar radius kantor';
  static const String alreadyCheckedIn = 'Anda sudah melakukan check-in';
  static const String alreadyCheckedOut = 'Anda sudah melakukan check-out';

  static const String notificationLoadFailed = 'Gagal memuat notifikasi';
  static const String notificationUpdateFailed =
      'Gagal memperbarui status notifikasi';
}
