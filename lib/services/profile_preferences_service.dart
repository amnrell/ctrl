import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing user profile preferences including regulation layers,
/// personalization settings, goals, and AI learning preferences
class ProfilePreferencesService extends ChangeNotifier {
  static final ProfilePreferencesService _instance =
      ProfilePreferencesService._internal();
  factory ProfilePreferencesService() => _instance;
  ProfilePreferencesService._internal();

  // Regulation Layers
  bool _awarenessEnabled = true;
  bool _interruptionEnabled = true;
  bool _stabilizationEnabled = true;
  bool _cognitiveEnabled = true;
  bool _dopamineBudgetingEnabled = true;

  // Regulation Style
  String _regulationStyle = 'balanced'; // 'gentle', 'balanced', 'strict'
  
  // Identity Settings
  String _userIdentity = '';
  List<String> _personalGoals = [];
  
  // Premium AI Learning
  bool _aiLearningEnabled = false;
  bool _isPremium = false;
  Map<String, dynamic> _aiInsights = {};

  // Getters
  bool get awarenessEnabled => _awarenessEnabled;
  bool get interruptionEnabled => _interruptionEnabled;
  bool get stabilizationEnabled => _stabilizationEnabled;
  bool get cognitiveEnabled => _cognitiveEnabled;
  bool get dopamineBudgetingEnabled => _dopamineBudgetingEnabled;
  String get regulationStyle => _regulationStyle;
  String get userIdentity => _userIdentity;
  List<String> get personalGoals => _personalGoals;
  bool get aiLearningEnabled => _aiLearningEnabled;
  bool get isPremium => _isPremium;
  Map<String, dynamic> get aiInsights => _aiInsights;

  /// Initialize preferences from shared preferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load regulation layers
    _awarenessEnabled = prefs.getBool('layer_awareness') ?? true;
    _interruptionEnabled = prefs.getBool('layer_interruption') ?? true;
    _stabilizationEnabled = prefs.getBool('layer_stabilization') ?? true;
    _cognitiveEnabled = prefs.getBool('layer_cognitive') ?? true;
    _dopamineBudgetingEnabled = prefs.getBool('layer_dopamine') ?? true;
    
    // Load regulation style
    _regulationStyle = prefs.getString('regulation_style') ?? 'balanced';
    
    // Load identity
    _userIdentity = prefs.getString('user_identity') ?? '';
    
    // Load goals
    _personalGoals = prefs.getStringList('personal_goals') ?? [];
    
    // Load premium settings
    _isPremium = prefs.getBool('is_premium') ?? false;
    _aiLearningEnabled = prefs.getBool('ai_learning_enabled') ?? false;
    
    // Load AI insights
    final insightsJson = prefs.getString('ai_insights');
    if (insightsJson != null) {
      // Parse JSON insights if needed
      _aiInsights = {}; // TODO: Parse JSON
    }
    
    notifyListeners();
  }

  /// Toggle regulation layer
  Future<void> toggleLayer(String layerName, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    
    switch (layerName) {
      case 'awareness':
        _awarenessEnabled = enabled;
        await prefs.setBool('layer_awareness', enabled);
        break;
      case 'interruption':
        _interruptionEnabled = enabled;
        await prefs.setBool('layer_interruption', enabled);
        break;
      case 'stabilization':
        _stabilizationEnabled = enabled;
        await prefs.setBool('layer_stabilization', enabled);
        break;
      case 'cognitive':
        _cognitiveEnabled = enabled;
        await prefs.setBool('layer_cognitive', enabled);
        break;
      case 'dopamine':
        _dopamineBudgetingEnabled = enabled;
        await prefs.setBool('layer_dopamine', enabled);
        break;
    }
    
    notifyListeners();
  }

  /// Set regulation style
  Future<void> setRegulationStyle(String style) async {
    _regulationStyle = style;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('regulation_style', style);
    notifyListeners();
  }

  /// Set user identity
  Future<void> setUserIdentity(String identity) async {
    _userIdentity = identity;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_identity', identity);
    notifyListeners();
  }

  /// Add personal goal
  Future<void> addPersonalGoal(String goal) async {
    if (!_personalGoals.contains(goal)) {
      _personalGoals.add(goal);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('personal_goals', _personalGoals);
      notifyListeners();
    }
  }

  /// Remove personal goal
  Future<void> removePersonalGoal(String goal) async {
    _personalGoals.remove(goal);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('personal_goals', _personalGoals);
    notifyListeners();
  }

  /// Enable/disable AI learning (premium feature)
  Future<void> setAILearning(bool enabled) async {
    if (!_isPremium) return;
    _aiLearningEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ai_learning_enabled', enabled);
    notifyListeners();
  }

  /// Update AI insights (called by premium AI service)
  void updateAIInsights(Map<String, dynamic> insights) {
    _aiInsights = insights;
    notifyListeners();
  }

  /// Track user choice for AI learning (premium)
  Future<void> trackUserChoice(String choiceType, dynamic value) async {
    if (!_isPremium || !_aiLearningEnabled) return;
    
    // Store choice for AI learning
    final prefs = await SharedPreferences.getInstance();
    final choices = prefs.getStringList('ai_learning_choices') ?? [];
    choices.add('${DateTime.now().toIso8601String()}:$choiceType:$value');
    await prefs.setStringList('ai_learning_choices', choices);
    
    notifyListeners();
  }
}

