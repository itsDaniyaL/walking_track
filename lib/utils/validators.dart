class Validators {
  static final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp passwordRegExp = RegExp(
    r'^(?=.*[A-Z]).{8,}$',
  );

  static final RegExp userNameRegExp = RegExp(
    r'^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*$',
  );

  static final RegExp cellPhoneNumberRegExp =
      RegExp(r'^(\+?\d{1,4}[-.\s]?)?(\(?\d{3}\)?[-.\s]?)?\d{3}[-.\s]?\d{4}$');

  static bool validatorEmail(String email) {
    return emailRegExp.hasMatch(email) && email.isNotEmpty;
  }

  static bool validatorPassword(String password) {
    return passwordRegExp.hasMatch(password) && password.isNotEmpty;
  }

  static bool validatorUserName(String userName) {
    return userNameRegExp.hasMatch(userName) && userName.isNotEmpty;
  }

  static bool validatorCellPhoneNumber(String cellPhoneNumber) {
    return cellPhoneNumberRegExp.hasMatch(cellPhoneNumber) &&
        cellPhoneNumber.isNotEmpty;
  }

  static String? validateGenericFields(String value, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateCellPhoneField(String? value) {
    if ((value == null || value.isEmpty) &&
        (value == null || validatorCellPhoneNumber(value))) {
      return 'Accurate Cell Number is required';
    }
    return null;
  }

  static String? validateEmailField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    return null;
  }

  static String? validateUsernameField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  static String? validatePasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length <= 8) {
      return 'Must include atleast 8+ characters';
    }
    return null;
  }
}
