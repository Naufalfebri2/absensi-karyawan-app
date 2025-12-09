extension StringExt on String {
  bool get isEmail {
    return contains("@") && contains(".");
  }

  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String mask() {
    if (length <= 4) return "***";
    return "${substring(0, 2)}****${substring(length - 2)}";
  }
}
