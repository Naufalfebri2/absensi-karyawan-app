import 'package:intl/intl.dart';

extension DateExt on DateTime {
  String toShortDate() => DateFormat('dd/MM/yyyy').format(this);
  String toLongDate() => DateFormat('EEEE, dd MMMM yyyy', 'id').format(this);
  String toTime() => DateFormat('HH:mm:ss').format(this);
}
