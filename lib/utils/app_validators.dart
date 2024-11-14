class AppValidators {
  static String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter card number';
    } else if (value.length != 16) {
      return 'Card number must be 16 digits';
    }
    return null;
  }

  static String? validateExpirationMonth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter expiration month';
    } else if (int.tryParse(value) == null ||
        int.parse(value) < 1 ||
        int.parse(value) > 12) {
      return 'Invalid month';
    }
    return null;
  }

  static String? validateExpirationYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter expiration year';
    } else if (int.tryParse(value) == null || value.length != 4) {
      return 'Invalid year';
    }
    return null;
  }

  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter CVV';
    } else if (value.length != 3) {
      return 'CVV must be 3 digits';
    }
    return null;
  }

  static String? validateNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);

    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }
}
