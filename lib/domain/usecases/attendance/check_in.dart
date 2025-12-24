import '../../repositories/attendance_repository.dart';
import '../../entities/attendance_entity.dart';

class CheckIn {
  final AttendanceRepository repository;

  CheckIn(this.repository);

  Future<AttendanceEntity> call({
    required double latitude,
    required double longitude,
    required String photoPath,
  }) {
    return repository.checkIn(
      latitude: latitude,
      longitude: longitude,
      photoPath: photoPath,
    );
  }
}
