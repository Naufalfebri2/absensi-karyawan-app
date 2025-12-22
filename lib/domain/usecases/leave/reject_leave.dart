import '../../repositories/leave_repository.dart';

class RejectLeaveUsecase {
  final LeaveRepository repo;

  RejectLeaveUsecase(this.repo);

  Future<void> call(int id, String note) {
    return repo.rejectLeave(id, note);
  }
}
