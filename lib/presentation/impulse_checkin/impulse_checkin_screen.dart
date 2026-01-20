import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/theme_manager_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../main_dashboard/widgets/dynamic_background_widget.dart';

/// Impulse Check-in Screen
/// Allows users to log impulses with trigger type, intensity, mood, and context
class ImpulseCheckinScreen extends StatefulWidget {
  const ImpulseCheckinScreen({super.key});

  @override
  State<ImpulseCheckinScreen> createState() => _ImpulseCheckinScreenState();
}

class _ImpulseCheckinScreenState extends State<ImpulseCheckinScreen>
    with SingleTickerProviderStateMixin {
  final ThemeManagerService _themeManager = ThemeManagerService();
  final TextEditingController _notesController = TextEditingController();

  // Selected values
  String? _selectedTrigger;
  double _intensity = 5.0;
  String? _selectedMood;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Color _currentVibeColor = AppTheme.primaryZen;

  // Trigger options with icons
  final List<Map<String, dynamic>> _triggers = [
    {'name': 'Attention', 'icon': 'visibility', 'color': Color(0xFFAB47BC)},
    {'name': 'Social Media', 'icon': 'share', 'color': Color(0xFF42A5F5)},
    {'name': 'Gaming', 'icon': 'sports_esports', 'color': Color(0xFFEC407A)},
    {'name': 'Shopping', 'icon': 'shopping_bag', 'color': Color(0xFF66BB6A)},
    {'name': 'Money', 'icon': 'attach_money', 'color': Color(0xFFFFCA28)},
    {'name': 'Habits', 'icon': 'loop', 'color': Color(0xFFFF7043)},
  ];

  // Mood options with emojis
  final List<Map<String, dynamic>> _moods = [
    {'name': 'Happy', 'emoji': '😊', 'color': Color(0xFFFFD54F)},
    {'name': 'Anxious', 'emoji': '😰', 'color': Color(0xFF9575CD)},
    {'name': 'Sad', 'emoji': '😢', 'color': Color(0xFF64B5F6)},
    {'name': 'Angry', 'emoji': '😠', 'color': Color(0xFFE57373)},
    {'name': 'Neutral', 'emoji': '😐', 'color': Color(0xFF90A4AE)},
    {'name': 'Tired', 'emoji': '😴', 'color': Color(0xFF81C784)},
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

  void _logImpulse() {
    if (_selectedTrigger == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select what triggered this impulse'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select how you\'re feeling'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // TODO: Send to API
    // For now, show success message
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Impulse logged successfully! 🎯'),
        backgroundColor: _themeManager.primaryVibeColor,
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate back after short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Impulse Check-in',
        variant: CustomAppBarVariant.withBack,
        vibeColor: _themeManager.primaryVibeColor,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DynamicBackgroundWidget(
              primaryColor: _currentVibeColor,
              secondaryColor: _themeManager.secondaryVibeColor,
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
                          iconName: 'info_outline',
                          color: _themeManager.primaryVibeColor,
                          size: 24,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'Log your impulse to build awareness and track patterns',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Section: What triggered the impulse?
                  Text(
                    'What triggered this impulse?',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Trigger grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 2.h,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _triggers.length,
                    itemBuilder: (context, index) {
                      final trigger = _triggers[index];
                      final isSelected = _selectedTrigger == trigger['name'];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTrigger = trigger['name'];
                          });
                          HapticFeedback.selectionClick();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (trigger['color'] as Color)
                                    .withValues(alpha: 0.2)
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? (trigger['color'] as Color)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: trigger['icon'],
                                color: isSelected
                                    ? (trigger['color'] as Color)
                                    : theme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                trigger['name'],
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isSelected
                                      ? (trigger['color'] as Color)
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
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Section: Intensity Level
                  Text(
                    'Intensity Level',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Intensity slider
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
                              'Mild',
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
                                color: _themeManager.primaryVibeColor,
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
                              'Intense',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: _themeManager.primaryVibeColor,
                            inactiveTrackColor: _themeManager.primaryVibeColor
                                .withValues(alpha: 0.2),
                            thumbColor: _themeManager.primaryVibeColor,
                            overlayColor: _themeManager.primaryVibeColor
                                .withValues(alpha: 0.2),
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

                  // Section: How are you feeling?
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
                      crossAxisCount: 3,
                      childAspectRatio: 1.2,
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
                            borderRadius: BorderRadius.circular(12),
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
                                style: TextStyle(fontSize: 24),
                              ),
                              SizedBox(height: 0.5.h),
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
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Section: What happened? (optional)
                  Text(
                    'What happened? (optional)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Notes text field
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
                        hintText: 'Describe what triggered this impulse...',
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

                  // Log Impulse button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _logImpulse,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _themeManager.primaryVibeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Log Impulse',
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
