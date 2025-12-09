class AppConstants {
  // APP INFO
  static const String appName = "Aplikasi Absensi Pegawai";
  static const String appVersion = "1.0.0";

  // LOCATION SETTINGS

  /// Radius maksimal untuk diperbolehkan Check-In / Check-Out
  /// 3 KM = 3000 meter
  static const double allowedRadiusMeters = 3000;

  /// Minimum akurasi lokasi yang diterima GPS (dalam meter)
  static const double minimumLocationAccuracy = 50;

  // TIME FORMAT SETTINGS

  /// Format waktu global aplikasi
  static const String timeFormat = "HH:mm:ss";

  /// Format tanggal global
  static const String dateFormat = "yyyy-MM-dd";

  /// Format tanggal dengan jam
  static const String dateTimeFormat = "yyyy-MM-dd HH:mm:ss";

  // SESSION SETTINGS

  /// Auto-logout setelah user idle (dalam menit)
  static const int sessionTimeoutMinutes = 30;

  /// Interval pengecekan session
  static const int sessionCheckIntervalSeconds = 10;

  // FACE RECOGNITION SETTINGS
  /// Minimum confidence face detection agar foto absen valid
  static const double faceDetectionThreshold = 0.85;

  // CAMERA SETTINGS

  /// Kualitas kompresi foto absensi (0 – 100)
  static const int photoQuality = 70;

  /// Resolusi foto absensi
  static const int photoResolution = 720;

  // NOTIFICATION SETTINGS

  /// Channel ID untuk local notifications
  static const String notificationChannelId = "attendance_notifications";

  /// Nama channel notifikasi
  static const String notificationChannelName = "Attendance Alerts";

  // ATTENDANCE SETTINGS

  /// Toleransi keterlambatan default (jika shift tidak menentukan)
  static const int defaultToleranceLateMinutes = 10;

  /// Jika sudah jam kerja namun belum check-in → kirim notifikasi otomatis
  static const int autoAlertCheckInDelayMinutes = 15;

  /// Update total jam kerja otomatis setiap berapa menit
  static const int workHourCalculationInterval = 60;

  // HOLIDAY SETTINGS

  /// Endpoint API libur nasional, jika ingin integrasi
  static const String holidayApiUrl = "https://api-harilibur.vercel.app/api";

  // DEBUG SETTINGS

  static const bool enableDebugLog = true;
}
