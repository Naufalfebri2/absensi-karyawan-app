import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

// ===============================
// INITIAL
// ===============================
class HomeInitial extends HomeState {
  const HomeInitial();
}

// ===============================
// LOADING
// ===============================
class HomeLoading extends HomeState {
  final HomeLoaded? previous;

  const HomeLoading({this.previous});

  @override
  List<Object?> get props => [previous];
}

// ===============================
// LOADED
// ===============================
class HomeLoaded extends HomeState {
  final int pendingLeaveCount;
  final DateTime now;
  final String locationName;

  // ===============================
  // ATTENDANCE STATE
  // ===============================
  final bool hasCheckedIn;
  final bool hasCheckedOut; // 🔒 KUNCI UTAMA

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
  // GPS VALIDATION
  // ===============================
  final bool isWithinOfficeRadius;
  final double? distanceFromOffice;
  final String? gpsErrorMessage;

  // ===============================
  // 🔥 MONTHLY SUMMARY (NEW)
  // ===============================
  final int presentCount;
  final int lateCount;
  final int absentCount;
  final int overtimeCount;

  const HomeLoaded({
    required this.pendingLeaveCount,
    required this.now,
    required this.locationName,
    required this.hasCheckedIn,
    required this.hasCheckedOut,
    required this.isHoliday,
    this.holidayName,
    required this.canCheckIn,
    required this.canCheckOut,
    this.restrictionMessage,
    required this.isWithinOfficeRadius,
    this.distanceFromOffice,
    this.gpsErrorMessage,

    // 🔥 NEW
    required this.presentCount,
    required this.lateCount,
    required this.absentCount,
    required this.overtimeCount,
  });

  // ===============================
  // COPY WITH
  // ===============================
  HomeLoaded copyWith({
    int? pendingLeaveCount,
    DateTime? now,
    String? locationName,
    bool? hasCheckedIn,
    bool? hasCheckedOut,
    bool? isHoliday,
    String? holidayName,
    bool? canCheckIn,
    bool? canCheckOut,
    String? restrictionMessage,
    bool? isWithinOfficeRadius,
    double? distanceFromOffice,
    String? gpsErrorMessage,

    // 🔥 NEW
    int? presentCount,
    int? lateCount,
    int? absentCount,
    int? overtimeCount,
  }) {
    return HomeLoaded(
      pendingLeaveCount: pendingLeaveCount ?? this.pendingLeaveCount,
      now: now ?? this.now,
      locationName: locationName ?? this.locationName,
      hasCheckedIn: hasCheckedIn ?? this.hasCheckedIn,
      hasCheckedOut: hasCheckedOut ?? this.hasCheckedOut,
      isHoliday: isHoliday ?? this.isHoliday,
      holidayName: holidayName ?? this.holidayName,
      canCheckIn: canCheckIn ?? this.canCheckIn,
      canCheckOut: canCheckOut ?? this.canCheckOut,
      restrictionMessage: restrictionMessage ?? this.restrictionMessage,
      isWithinOfficeRadius: isWithinOfficeRadius ?? this.isWithinOfficeRadius,
      distanceFromOffice: distanceFromOffice ?? this.distanceFromOffice,
      gpsErrorMessage: gpsErrorMessage ?? this.gpsErrorMessage,

      // 🔥 NEW
      presentCount: presentCount ?? this.presentCount,
      lateCount: lateCount ?? this.lateCount,
      absentCount: absentCount ?? this.absentCount,
      overtimeCount: overtimeCount ?? this.overtimeCount,
    );
  }

  @override
  List<Object?> get props => [
    pendingLeaveCount,
    now,
    locationName,
    hasCheckedIn,
    hasCheckedOut,
    isHoliday,
    holidayName,
    canCheckIn,
    canCheckOut,
    restrictionMessage,
    isWithinOfficeRadius,
    distanceFromOffice,
    gpsErrorMessage,

    // 🔥 NEW
    presentCount,
    lateCount,
    absentCount,
    overtimeCount,
  ];
}
