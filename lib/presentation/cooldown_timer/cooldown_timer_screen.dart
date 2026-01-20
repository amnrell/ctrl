import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/theme_manager_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';

/// Cooldown Timer Screen
/// Start and manage cooldown timers for activities
class CooldownTimerScreen extends StatefulWidget {
  const CooldownTimerScreen({super.key});

  @override
  State<CooldownTimerScreen> createState() => _CooldownTimerScreenState();
}

class _CooldownTimerScreenState extends State<CooldownTimerScreen> {
  final ThemeManagerService _themeManager = ThemeManagerService();

  String? _selectedActivity;
  int _selectedDuration = 15; // minutes
  bool _isTimerRunning = false;
  int _remainingSeconds = 0;
  Timer? _timer;

  // Activity types
  final List<Map<String, dynamic>> _activities = [
    {
      'name': 'Social Media',
      'icon': 'phone_android',
      'color': Color(0xFF42A5F5)
    },
    {'name': 'Gaming', 'icon': 'sports_esports', 'color': Color(0xFFEC407A)},
    {'name': 'Shopping', 'icon': 'shopping_bag', 'color': Color(0xFF66BB6A)},
    {'name': 'Eating', 'icon': 'restaurant', 'color': Color(0xFFFFB300)},
    {'name': 'Work', 'icon': 'work', 'color': Color(0xFF9575CD)},
    {'name': 'Other', 'icon': 'more_horiz', 'color': Color(0xFF90A4AE)},
  ];

  // Duration presets
  final List<int> _durations = [5, 10, 15, 30, 60, 120];

  @override
  void initState() {
    super.initState();
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
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_selectedActivity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an activity'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isTimerRunning = true;
      _remainingSeconds = _selectedDuration * 60;
    });

    HapticFeedback.mediumImpact();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _completeTimer();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
    HapticFeedback.selectionClick();
  }

  void _resumeTimer() {
    setState(() {
      _isTimerRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _completeTimer();
      }
    });

    HapticFeedback.selectionClick();
  }

  void _completeTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _remainingSeconds = 0;
    });

    HapticFeedback.heavyImpact();

    // Show completion dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'celebration',
              color: _themeManager.primaryVibeColor,
              size: 28,
            ),
            SizedBox(width: 2.w),
            Text(
              'Cooldown Complete!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        content: Text(
          'Great job! You\'ve completed your $_selectedActivity cooldown.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _cancelTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _remainingSeconds = 0;
    });
    HapticFeedback.selectionClick();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double _getProgress() {
    if (_selectedDuration == 0) return 0;
    final totalSeconds = _selectedDuration * 60;
    return (_remainingSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Cooldown Timer',
        variant: CustomAppBarVariant.withBack,
        vibeColor: _themeManager.primaryVibeColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header description
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: _themeManager.primaryVibeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        _themeManager.primaryVibeColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'timer',
                      color: _themeManager.primaryVibeColor,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Set a cooldown period before engaging in an activity',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              if (!_isTimerRunning && _remainingSeconds == 0) ...[
                // Activity Selection
                Text(
                  'Select Activity',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 2.h),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2.w,
                    mainAxisSpacing: 2.h,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _activities.length,
                  itemBuilder: (context, index) {
                    final activity = _activities[index];
                    final isSelected = _selectedActivity == activity['name'];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedActivity = activity['name'];
                        });
                        HapticFeedback.selectionClick();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (activity['color'] as Color)
                                  .withValues(alpha: 0.2)
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? (activity['color'] as Color)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: activity['icon'],
                              color: isSelected
                                  ? (activity['color'] as Color)
                                  : theme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              activity['name'],
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? (activity['color'] as Color)
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

                // Duration Selection
                Text(
                  'Cooldown Duration',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 2.h),

                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: _durations.map((duration) {
                    final isSelected = _selectedDuration == duration;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDuration = duration;
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
                          duration >= 60
                              ? '${duration ~/ 60}h'
                              : '${duration}m',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? _themeManager.primaryVibeColor
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 4.h),

                // Start Timer button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _themeManager.primaryVibeColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Start Cooldown',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Timer Display
                SizedBox(height: 4.h),

                Center(
                  child: Column(
                    children: [
                      // Activity name
                      Text(
                        _selectedActivity ?? '',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Circular progress
                      SizedBox(
                        width: 60.w,
                        height: 60.w,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background circle
                            SizedBox(
                              width: 60.w,
                              height: 60.w,
                              child: CircularProgressIndicator(
                                value: 1.0,
                                strokeWidth: 12,
                                backgroundColor:
                                    theme.colorScheme.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.surfaceContainerHighest,
                                ),
                              ),
                            ),
                            // Progress circle
                            SizedBox(
                              width: 60.w,
                              height: 60.w,
                              child: CircularProgressIndicator(
                                value: _getProgress(),
                                strokeWidth: 12,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _themeManager.primaryVibeColor,
                                ),
                              ),
                            ),
                            // Time display
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _formatTime(_remainingSeconds),
                                  style: theme.textTheme.displayLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: _themeManager.primaryVibeColor,
                                  ),
                                ),
                                Text(
                                  'remaining',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 6.h),

                      // Control buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Cancel button
                          ElevatedButton(
                            onPressed: _cancelTimer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHighest,
                              foregroundColor: theme.colorScheme.onSurface,
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'close',
                                  color: theme.colorScheme.onSurface,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text('Cancel'),
                              ],
                            ),
                          ),

                          SizedBox(width: 4.w),

                          // Pause/Resume button
                          ElevatedButton(
                            onPressed:
                                _isTimerRunning ? _pauseTimer : _resumeTimer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _themeManager.primaryVibeColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName:
                                      _isTimerRunning ? 'pause' : 'play_arrow',
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(_isTimerRunning ? 'Pause' : 'Resume'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
