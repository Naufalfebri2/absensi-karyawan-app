abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final int pendingLeaveCount;
  final DateTime now;
  final String locationName;
  final bool hasCheckedIn;

  // ===============================
  // HOLIDAY
  // ===============================
  final bool isHoliday;
  final String? holidayName;

  // ===============================
  // SHIFT / WORKING HOURS
  // ===============================
  final bool canCheckIn;
  final bool canCheckOut;
  final String? restrictionMessage;

  // ===============================
  // GPS VALIDATION 🔥 (INI FIX ERROR)
  // ===============================
  final bool isWithinOfficeRadius;
  final double? distanceFromOffice; // meter
  final String? gpsErrorMessage;

  HomeLoaded({
    required this.pendingLeaveCount,
    required this.now,
    required this.locationName,
    required this.hasCheckedIn,
    required this.isHoliday,
    this.holidayName,
    required this.canCheckIn,
    required this.canCheckOut,
    this.restrictionMessage,
    required this.isWithinOfficeRadius,
    this.distanceFromOffice,
    this.gpsErrorMessage,
  });
}
