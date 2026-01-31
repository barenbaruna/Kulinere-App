import 'package:flutter/material.dart';

/// Provider for managing user profile data and dynamic greetings.
///
/// Features:
/// - Single source of truth for user name
/// - Time-based dynamic greetings (Indonesian)
/// - First name extraction for personalized display
class UserProfileProvider extends ChangeNotifier {
  String _userName = 'Baren Baruna Harahap';

  /// Current user name.
  String get userName => _userName;

  /// First name extracted from full name.
  String get firstName => _userName.split(' ').first;

  /// Updates the user name and notifies listeners.
  void setUserName(String name) {
    if (_userName != name) {
      _userName = name;
      notifyListeners();
    }
  }

  /// Time-based greeting in Indonesian.
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat pagi';
    if (hour < 15) return 'Selamat siang';
    if (hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  /// Full personalized greeting with first name.
  String get fullGreeting => '$greeting, $firstName!';
}
