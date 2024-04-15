abstract class NumbersHelper {
  static String? doubleToString(double? doubleNum) {
    if (doubleNum == null) return null;
    int intNum = doubleNum.toInt();
    return intNum == doubleNum ? intNum.toString() : doubleNum.toString();
  }
}
