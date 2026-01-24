import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages notification-specific colors
/// Completely independent from app theme / vibe
class NotificationPaletteService extends ChangeNotifier {
  static final NotificationPaletteService _instance =
      NotificationPaletteService._internal();

  factory NotificationPaletteService() => _instance;
  NotificationPaletteService._internal();

  // -----------------------------
  // STATE
  // -----------------------------

  final Set<String> _enabledVibes = {
    'Zen',
    'Energized',
    'Reflective',
  };

  // Canonical notification colors
  static const Map<String, Color> notificationVibeColors = {
    'Zen': Color(0xFF6BCFCF),
    'Energized': Color(0xFFFF6B6B),
    'Reflective': Color(0xFF8B7CF6),
    'Warning': Color(0xFFFFA726),
    'Critical': Color(0xFFD32F2F),
  };

  // -----------------------------
  // GETTERS
  // -----------------------------

  Set<String> get enabledVibes => _enabledVibes;

  List<Color> get activeColors =>
      _enabledVibes.map((v) => notificationVibeColors[v]!).toList();

  Color get primaryNotificationColor =>
      notificationVibeColors[_enabledVibes.first] ??
      notificationVibeColors.values.first;

  // -----------------------------
  // INIT
  // -----------------------------

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('notification_vibes');

    if (saved != null && saved.isNotEmpty) {
      _enabledVibes
        ..clear()
        ..addAll(saved);
    }

    notifyListeners();
  }

  // -----------------------------
  // MUTATIONS
  // -----------------------------

  Future<void> toggleVibe(String vibe) async {
    if (_enabledVibes.contains(vibe)) {
      _enabledVibes.remove(vibe);
    } else {
      _enabledVibes.add(vibe);
    }

    // Never allow empty set
    if (_enabledVibes.isEmpty) {
      _enabledVibes.add('Zen');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'notification_vibes',
      _enabledVibes.toList(),
    );

    notifyListeners();
  }

  bool isEnabled(String vibe) => _enabledVibes.contains(vibe);
}
