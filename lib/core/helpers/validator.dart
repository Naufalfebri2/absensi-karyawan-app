class Validator {
  static String? notEmpty(
    String? value, {
    String message = "Tidak boleh kosong",
  }) {
    if (value == null || value.isEmpty) return message;
    return null;
  }

  static String? email(String? value) {
    if (value == null || !value.contains("@")) {
      return "Format email tidak valid";
    }
    return null;
  }
}
