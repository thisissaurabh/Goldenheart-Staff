import 'package:easy_localization/easy_localization.dart';

class SimpleDateConverter {
// Method to parse a date string in 'dd-MM-yyyy' format
  static DateTime parseDateString(String dateString) {
    return DateFormat('dd-MM-yyyy').parse(dateString);
  }

// Method to format a DateTime object into 'yyyy-MM-dd' format
  static String formatDateToCustomFormat(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

// Example usage combining both methods
  static String parseAndFormatDateString(String dateString) {
    DateTime dateTime = parseDateString(dateString);
    return formatDateToCustomFormat(dateTime);
  }
}
