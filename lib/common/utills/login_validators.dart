String? emailValidator(String? value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern.toString());
  if (value!=null && !regex.hasMatch(value)) {
    return 'Email format is invalid';
  } else {
    return null;
  }
}

String? passwordValidator(String? value) {
  if (value!=null && value.length < 8) {
    return 'Password must be longer than 8 characters';
  } else {
    return null;
  }
}

String? nameValidator(String? value) {
  if (value==null || value.isEmpty) return 'Please enter your name.';
  return null;
}