import '../../repositories/leave_repository.dart';

class GetPendingLeaves {
  final LeaveRepository repository;

  GetPendingLeaves(this.repository);

  Future<List<dynamic>> call() {
    return repository.getPendingLeaves();
  }
}
