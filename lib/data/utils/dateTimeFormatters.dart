import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy - h:mm a');
  return formatter.format(dateTime.toLocal());
}


String formatDate(DateTime dateTime) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(dateTime.toLocal());
}

String formatTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('h:mm a');
  return formatter.format(dateTime.toLocal());
}
