import 'package:flutter/material.dart';

/// Provider untuk mengelola data profil pengguna dan greeting dinamis.
///
/// Menggunakan pattern single source of truth untuk nama pengguna
/// yang di-sync dengan ProfileScreen.
class UserProfileProvider extends ChangeNotifier {
  // Default name - akan di-sync dengan ProfileScreen
  String _userName = 'Baren Baruna Harahap';

  String get userName => _userName;

  /// Mengambil nama depan untuk greeting
  String get firstName => _userName.split(' ').first;

  void setUserName(String name) {
    if (_userName != name) {
      _userName = name;
      notifyListeners();
    }
  }

  /// Greeting dinamis berdasarkan waktu
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat pagi';
    if (hour < 15) return 'Selamat siang';
    if (hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  /// Full greeting dengan nama
  String get fullGreeting => '$greeting, $firstName!';
}
