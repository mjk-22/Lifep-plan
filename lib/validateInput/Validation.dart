class Validation {
  static bool validPasswordLength(String password) {
    return (password.length >= 12);
  }

  static bool validConfirmPassword(String password, String confirmPassword) {
    return confirmPassword.compareTo(password) == 0;
  }
}