import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/theme_manager_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';

/// Urge Log Screen
/// Track urges and how they were handled for pattern recognition
class UrgeLogScreen extends StatefulWidget {
  const UrgeLogScreen({super.key});

  @override
  State<UrgeLogScreen> createState() => _UrgeLogScreenState();
}

class _UrgeLogScreenState extends State<UrgeLogScreen> {
  final ThemeManagerService _themeManager = ThemeManagerService();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _delayController = TextEditingController();

  String? _selectedCategory;
  double _urgeStrength = 5.0;
  String? _actionTaken;

  // Urge categories
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Scroll', 'icon': 'phone_android', 'color': Color(0xFF42A5F5)},
    {'name': 'Purchase', 'icon': 'shopping_cart', 'color': Color(0xFF66BB6A)},
    {'name': 'Food', 'icon': 'restaurant', 'color': Color(0xFFFFB300)},
    {'name': 'Substance', 'icon': 'local_bar', 'color': Color(0xFFE57373)},
    {'name': 'Gaming', 'icon': 'sports_esports', 'color': Color(0xFFEC407A)},
    {'name': 'Other', 'icon': 'more_horiz', 'color': Color(0xFF9575CD)},
  ];

  // Action taken options
  final List<Map<String, dynamic>> _actions = [
    {
      'name': 'Resisted',
      'icon': 'block',
      'color': Color(0xFF66BB6A),
      'description': 'Successfully resisted the urge'
    },
    {
      'name': 'Delayed',
      'icon': 'schedule',
      'color': Color(0xFF42A5F5),
      'description': 'Delayed acting on the urge'
    },
    {
      'name': 'Redirected',
      'icon': 'alt_route',
      'color': Color(0xFFFFB300),
      'description': 'Redirected to healthier activity'
    },
    {
      'name': 'Gave In',
      'icon': 'check_circle',
      'color': Color(0xFF9575CD),
      'description': 'Acted on the urge'
    },
  ];

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
    _notesController.dispose();
    _delayController.dispose();
    super.dispose();
  }

  void _logUrge() {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select urge category'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_actionTaken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select action taken'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // TODO: Send to API
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Urge logged successfully! 💪'),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Urge Log',
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
                      iconName: 'trending_up',
                      color: _themeManager.primaryVibeColor,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Track urges and build resistance patterns',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Urge Category
              Text(
                'Urge Category',
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
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category['name'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category['name'];
                      });
                      HapticFeedback.selectionClick();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (category['color'] as Color)
                                .withValues(alpha: 0.2)
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? (category['color'] as Color)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: category['icon'],
                            color: isSelected
                                ? (category['color'] as Color)
                                : theme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            category['name'],
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? (category['color'] as Color)
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

              // Urge Strength
              Text(
                'Urge Strength',
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
                          'Weak',
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
                            _urgeStrength.toInt().toString(),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          'Strong',
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
                        value: _urgeStrength,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        onChanged: (value) {
                          setState(() {
                            _urgeStrength = value;
                          });
                          HapticFeedback.selectionClick();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Action Taken
              Text(
                'Action Taken',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              SizedBox(height: 2.h),

              Column(
                children: _actions.map((action) {
                  final isSelected = _actionTaken == action['name'];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _actionTaken = action['name'];
                        });
                        HapticFeedback.selectionClick();
                      },
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (action['color'] as Color)
                                  .withValues(alpha: 0.2)
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? (action['color'] as Color)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: (action['color'] as Color)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: action['icon'],
                                color: action['color'] as Color,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    action['name'],
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: isSelected
                                          ? (action['color'] as Color)
                                          : theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    action['description'],
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              CustomIconWidget(
                                iconName: 'check_circle',
                                color: action['color'] as Color,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Delay Duration (if delayed)
              if (_actionTaken == 'Delayed') ...[
                SizedBox(height: 1.h),
                Text(
                  'Delay Duration (minutes)',
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
                    controller: _delayController,
                    keyboardType: TextInputType.number,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'e.g., 15',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(3.w),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
              ],

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
                  maxLines: 3,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'What helped you resist or what triggered it?',
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

              // Log Urge button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _logUrge,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _themeManager.primaryVibeColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Log Urge',
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
    );
  }
}
