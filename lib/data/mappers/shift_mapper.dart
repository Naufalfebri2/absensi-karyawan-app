import '../../domain/entities/shift_entity.dart';
import '../models/shift_model.dart';

class ShiftMapper {
  static ShiftEntity toEntity(ShiftModel model) {
    return ShiftEntity(
      id: model.id,
      name: model.name,
      startTime: model.start,
      endTime: model.end,
      toleranceLate: model.toleranceLate,
    );
  }

  // NEW: Needed for create & update shift
  static ShiftModel toModel(ShiftEntity entity) {
    return ShiftModel(
      id: entity.id,
      name: entity.name,
      start: entity.startTime,
      end: entity.endTime,
      toleranceLate: entity.toleranceLate,
    );
  }
}
