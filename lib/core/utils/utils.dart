import 'package:intl/intl.dart';

class Utils {
  static int compareDatetime(String s1, String s2) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy-HH:mm");
    DateTime dt1 = dateFormat.parse(s1);
    DateTime dt2 = dateFormat.parse(s2);
    return dt1.compareTo(dt2);
  }
}
