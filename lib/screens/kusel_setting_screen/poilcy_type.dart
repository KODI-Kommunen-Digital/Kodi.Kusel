// terms-and-conditions', 'privacy-policy', 'imprint-page'

enum PolicyType {
  imprintPage('imprint-page'),
  privacyPolicy('privacy-policy'),
  termsAndConditions('terms-and-conditions');

  final String name;

  const PolicyType(this.name);
}
