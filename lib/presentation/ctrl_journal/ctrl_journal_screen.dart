import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/theme_manager_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../main_dashboard/widgets/dynamic_background_widget.dart';

/// CTRL Journal Screen
/// Allows users to write journal entries with entry type and mood tracking
class CtrlJournalScreen extends StatefulWidget {
  const CtrlJournalScreen({super.key});

  @override
  State<CtrlJournalScreen> createState() => _CtrlJournalScreenState();
}

class _CtrlJournalScreenState extends State<CtrlJournalScreen>
    with SingleTickerProviderStateMixin {
  final ThemeManagerService _themeManager = ThemeManagerService();
  final TextEditingController _contentController = TextEditingController();

  // Selected values
  String _selectedEntryType = 'Reflection';
  String? _moodBefore;
  String? _moodAfter;
  final List<String> _selectedTags = [];
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Color _currentVibeColor = AppTheme.primaryZen;

  // Entry types
  final List<Map<String, dynamic>> _entryTypes = [
    {'name': 'Reflection', 'icon': 'psychology', 'color': Color(0xFF9C27B0)},
    {'name': 'Pattern', 'icon': 'insights', 'color': Color(0xFF2196F3)},
    {
      'name': 'Breakthrough',
      'icon': 'emoji_events',
      'color': Color(0xFFFFB300)
    },
    {'name': 'Struggle', 'icon': 'trending_down', 'color': Color(0xFFE53935)},
  ];

  // Mood options
  final List<Map<String, dynamic>> _moods = [
    {'name': 'Calm', 'emoji': '😌', 'color': Color(0xFF66BB6A)},
    {'name': 'Anxious', 'emoji': '😰', 'color': Color(0xFF9575CD)},
    {'name': 'Happy', 'emoji': '😊', 'color': Color(0xFFFFD54F)},
    {'name': 'Sad', 'emoji': '😢', 'color': Color(0xFF64B5F6)},
    {'name': 'Energized', 'emoji': '⚡', 'color': Color(0xFFFF7043)},
    {'name': 'Tired', 'emoji': '😴', 'color': Color(0xFF90A4AE)},
  ];

  // Tag suggestions
  final List<String> _availableTags = [
    'awareness',
    'progress',
    'setback',
    'insight',
    'gratitude',
    'challenge',
    'growth',
    'mindfulness',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Load current vibe color from theme manager
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _themeManager.initialize();
      if (mounted) {
        setState(() {
          _currentVibeColor = _themeManager.primaryVibeColor;
        });
      }
    });

    // Listen to theme changes
    _themeManager.addListener(() {
      if (mounted) {
        setState(() {
          _currentVibeColor = _themeManager.primaryVibeColor;
        });
      }
    });
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    await _themeManager.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something in your journal'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // TODO: Send to API
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Journal entry saved! 📝'),
        backgroundColor: _themeManager.primaryVibeColor,
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'CTRL Journal',
        variant: CustomAppBarVariant.withBack,
        vibeColor: _themeManager.primaryVibeColor,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DynamicBackgroundWidget(
              primaryColor: _currentVibeColor,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header description
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color:
                          _themeManager.primaryVibeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _themeManager.primaryVibeColor
                            .withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'auto_stories',
                          color: _themeManager.primaryVibeColor,
                          size: 24,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'Write your thoughts and track your emotional journey',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Entry Type Selection
                  Text(
                    'Entry Type',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Entry type chips
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _entryTypes.map((type) {
                      final isSelected = _selectedEntryType == type['name'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedEntryType = type['name'];
                          });
                          HapticFeedback.selectionClick();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (type['color'] as Color)
                                    .withValues(alpha: 0.2)
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? (type['color'] as Color)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: type['icon'],
                                color: isSelected
                                    ? (type['color'] as Color)
                                    : theme.colorScheme.onSurfaceVariant,
                                size: 18,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                type['name'],
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isSelected
                                      ? (type['color'] as Color)
                                      : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 3.h),

                  // Journal Content
                  Text(
                    'Write your thoughts',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _contentController,
                      maxLines: 8,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Today I noticed...',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.6),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(3.w),
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Mood Before
                  Text(
                    'Mood Before (optional)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _moods.map((mood) {
                      final isSelected = _moodBefore == mood['name'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _moodBefore = mood['name'];
                          });
                          HapticFeedback.selectionClick();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (mood['color'] as Color)
                                    .withValues(alpha: 0.2)
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? (mood['color'] as Color)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(mood['emoji'],
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(width: 1.w),
                              Text(
                                mood['name'],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isSelected
                                      ? (mood['color'] as Color)
                                      : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 3.h),

                  // Mood After
                  Text(
                    'Mood After (optional)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _moods.map((mood) {
                      final isSelected = _moodAfter == mood['name'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _moodAfter = mood['name'];
                          });
                          HapticFeedback.selectionClick();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (mood['color'] as Color)
                                    .withValues(alpha: 0.2)
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? (mood['color'] as Color)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(mood['emoji'],
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(width: 1.w),
                              Text(
                                mood['name'],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isSelected
                                      ? (mood['color'] as Color)
                                      : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 3.h),

                  // Tags
                  Text(
                    'Tags (optional)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _availableTags.map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return GestureDetector(
                        onTap: () => _toggleTag(tag),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _themeManager.primaryVibeColor
                                    .withValues(alpha: 0.2)
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? _themeManager.primaryVibeColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            '#$tag',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? _themeManager.primaryVibeColor
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),

                  // Save Entry button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveEntry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _themeManager.primaryVibeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save Entry',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
