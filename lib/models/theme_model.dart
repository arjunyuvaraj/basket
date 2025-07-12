import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Store current theme locally (optional)
  String _currentTheme = 'light';

  String get currentTheme => _currentTheme;

  void setCurrentTheme(String theme) {
    _currentTheme = theme;
  }

  Future<void> loadUserTheme() async {
    if (currentUser == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .get();

    if (doc.exists && doc.data() != null) {
      _currentTheme = doc.data()!['theme'] ?? 'light';
      notifyListeners();
    }
  }

  Future<void> handleModeChange() async {
    if (currentUser == null) return;

    final userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email);

    // Toggle theme
    _currentTheme = (_currentTheme == 'dark') ? 'light' : 'dark';

    // Update Firestore
    await userDocRef.update({'theme': _currentTheme});
    notifyListeners();
  }
}
