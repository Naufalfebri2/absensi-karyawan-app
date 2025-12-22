import 'dart:io';

import '../../repositories/leave_repository.dart';

class CreateLeave {
  final LeaveRepository repository;

  CreateLeave(this.repository);

  Future<void> call({
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    required int totalDays,
    File? attachment, // 🔥 TAMBAH
  }) {
    return repository.createLeave(
      leaveType: leaveType,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      totalDays: totalDays,
      attachment: attachment, // 🔥 TERUSKAN
    );
  }
}
