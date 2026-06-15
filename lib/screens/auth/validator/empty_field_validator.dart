String? validateField(String? value, String fieldNameRequiredMessage) {
  if (value == null || value.isEmpty) {
    return fieldNameRequiredMessage;
  }
  return null;
}