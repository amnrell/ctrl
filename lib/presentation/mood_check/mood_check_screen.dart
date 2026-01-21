import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/theme_manager_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../main_dashboard/widgets/dynamic_background_widget.dart';

/// Mood Check Screen
/// Enhanced mood logging with intensity, context, and notes
class MoodCheckScreen extends StatefulWidget {
  const MoodCheckScreen({super.key});

  @override
  State<MoodCheckScreen> createState() => _MoodCheckScreenState();
}

class _MoodCheckScreenState extends State<MoodCheckScreen>
    with SingleTickerProviderStateMixin {
  final ThemeManagerService _themeManager = ThemeManagerService();
  final TextEditingController _notesController = TextEditingController();

  String? _selectedMood;
  double _intensity = 5.0;
  String? _selectedContext;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Color _currentVibeColor = AppTheme.primaryZen;

  // Mood options with colors and emojis
  final List<Map<String, dynamic>> _moods = [
    {'name': 'Happy', 'emoji': '😊', 'color': Color(0xFFFFD54F)},
    {'name': 'Calm', 'emoji': '😌', 'color': Color(0xFF66BB6A)},
    {'name': 'Energized', 'emoji': '⚡', 'color': Color(0xFFFF7043)},
    {'name': 'Anxious', 'emoji': '😰', 'color': Color(0xFF9575CD)},
    {'name': 'Sad', 'emoji': '😢', 'color': Color(0xFF64B5F6)},
    {'name': 'Angry', 'emoji': '😠', 'color': Color(0xFFE57373)},
    {'name': 'Tired', 'emoji': '😴', 'color': Color(0xFF90A4AE)},
    {'name': 'Neutral', 'emoji': '😐', 'color': Color(0xFFBDBDBD)},
  ];

  // Context options
  final List<Map<String, dynamic>> _contexts = [
    {'name': 'After meditation', 'icon': 'self_improvement'},
    {'name': 'After work', 'icon': 'work'},
    {'name': 'Social interaction', 'icon': 'groups'},
    {'name': 'Exercise', 'icon': 'fitness_center'},
    {'name': 'Screen time', 'icon': 'phone_android'},
    {'name': 'Just woke up', 'icon': 'wb_sunny'},
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
    _notesController.dispose();
    super.dispose();
  }

  void _logMood() {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your mood'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // TODO: Send to API
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Mood logged successfully! 💭'),
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

  Color _getMoodColor() {
    if (_selectedMood == null) return _themeManager.primaryVibeColor;
    final mood = _moods.firstWhere((m) => m['name'] == _selectedMood);
    return mood['color'] as Color;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final moodColor = _getMoodColor();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Mood Check',
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
                          iconName: 'mood',
                          color: _themeManager.primaryVibeColor,
                          size: 24,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'Track your emotional state and build awareness',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // How are you feeling?
                  Text(
                    'How are you feeling?',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Mood grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 2.w,
                      mainAxisSpacing: 2.h,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: _moods.length,
                    itemBuilder: (context, index) {
                      final mood = _moods[index];
                      final isSelected = _selectedMood == mood['name'];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMood = mood['name'];
                          });
                          HapticFeedback.selectionClick();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (mood['color'] as Color)
                                    .withValues(alpha: 0.2)
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? (mood['color'] as Color)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                mood['emoji'],
                                style: TextStyle(fontSize: 32),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                mood['name'],
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isSelected
                                      ? (mood['color'] as Color)
                                      : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Intensity Level
                  Text(
                    'Intensity Level',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Low',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: moodColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _intensity.toInt().toString(),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              'High',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: moodColor,
                            inactiveTrackColor:
                                moodColor.withValues(alpha: 0.2),
                            thumbColor: moodColor,
                            overlayColor: moodColor.withValues(alpha: 0.2),
                            trackHeight: 6,
                          ),
                          child: Slider(
                            value: _intensity,
                            min: 1,
                            max: 10,
                            divisions: 9,
                            onChanged: (value) {
                              setState(() {
                                _intensity = value;
                              });
                              HapticFeedback.selectionClick();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Context
                  Text(
                    'Context (optional)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _contexts.map((context) {
                      final isSelected = _selectedContext == context['name'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedContext = context['name'];
                          });
                          HapticFeedback.selectionClick();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? moodColor.withValues(alpha: 0.2)
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  isSelected ? moodColor : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: context['icon'],
                                color: isSelected
                                    ? moodColor
                                    : theme.colorScheme.onSurfaceVariant,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                context['name'],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isSelected
                                      ? moodColor
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

                  // Notes
                  Text(
                    'Notes (optional)',
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
                      controller: _notesController,
                      maxLines: 4,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Feeling more centered after...',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.6),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(3.w),
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Log Mood button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _logMood,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: moodColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Log Mood',
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
