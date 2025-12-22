import '../../repositories/leave_repository.dart';

class GetLeaves {
  final LeaveRepository repository;

  GetLeaves(this.repository);

  Future<List<dynamic>> call() {
    return repository.getLeaves();
  }
}
