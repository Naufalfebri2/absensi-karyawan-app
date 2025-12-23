import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/local/attendance_local.dart';
// import '../datasources/remote/attendance_remote.dart'; // ⏳ nanti kalau API siap

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceLocalDataSource localDataSource;
  // final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepositoryImpl({
    required this.localDataSource,
    // required this.remoteDataSource,
  });

  // ===================================================
  // GET ATTENDANCE HISTORY
  // ===================================================
  @override
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int year,
    required int month,
  }) async {
    // 🔹 sementara pakai local (dummy)
    return await localDataSource.getAttendanceHistory(year: year, month: month);

    /*
    // 🔹 nanti jika API sudah siap
    return await remoteDataSource.getAttendanceHistory(
      year: year,
      month: month,
    );
    */
  }

  // ===================================================
  // GET TODAY ATTENDANCE
  // ===================================================
  @override
  Future<AttendanceEntity?> getTodayAttendance(DateTime today) async {
    return await localDataSource.getTodayAttendance(today);

    /*
    return await remoteDataSource.getTodayAttendance(today);
    */
  }

  // ===================================================
  // CHECK IN
  // ===================================================
  @override
  Future<AttendanceEntity> checkIn(DateTime now) async {
    return await localDataSource.checkIn(now);

    /*
    return await remoteDataSource.checkIn(now);
    */
  }

  // ===================================================
  // CHECK OUT
  // ===================================================
  @override
  Future<AttendanceEntity> checkOut(DateTime now) async {
    return await localDataSource.checkOut(now);

    /*
    return await remoteDataSource.checkOut(now);
    */
  }
}
