/// Admin configuration and allowed admin emails
class AdminConfig {
  AdminConfig._();

  /// Predefined list of email addresses that have administrative privileges
  static const List<String> adminEmails = [
    'admin@dalili.sy',
    'admin@example.com',
    'rawan@dalili.sy',
  ];

  /// Check whether an email belongs to an administrator
  static bool isAdmin(String? email) {
    if (email == null) return false;
    final normalized = email.trim().toLowerCase();
    return adminEmails.contains(normalized);
  }
}
