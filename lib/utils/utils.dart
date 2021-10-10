import 'package:intl/intl.dart';

formatDate(DateTime dateTime) {
  final formattedDate = DateFormat('d MMM');

  return formattedDate.format(dateTime);
}
