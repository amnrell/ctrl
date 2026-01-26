import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../services/profile_preferences_service.dart';

/// Widget for selecting regulation style preference
class RegulationStyleWidget extends StatelessWidget {
  final ProfilePreferencesService preferencesService;

  const RegulationStyleWidget({
    super.key,
    required this.preferencesService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentStyle = preferencesService.regulationStyle;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tune_outlined,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Regulation Style',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose how you want CTRL to interact with you. This affects the intensity and frequency of interventions.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 2.h),
          _buildStyleOption(
            context,
            theme,
            'Gentle',
            'Minimal interventions, subtle reminders. Best for maintaining awareness without disruption.',
            Icons.self_improvement_outlined,
            Colors.green,
            'gentle',
            currentStyle == 'gentle',
          ),
          SizedBox(height: 1.5.h),
          _buildStyleOption(
            context,
            theme,
            'Balanced',
            'Moderate interventions when needed. A good middle ground for most users.',
            Icons.balance_outlined,
            Colors.blue,
            'balanced',
            currentStyle == 'balanced',
          ),
          SizedBox(height: 1.5.h),
          _buildStyleOption(
            context,
            theme,
            'Strict',
            'More frequent and assertive interventions. Best for breaking strong habits.',
            Icons.shield_outlined,
            Colors.orange,
            'strict',
            currentStyle == 'strict',
          ),
        ],
      ),
    );
  }

  Widget _buildStyleOption(
    BuildContext context,
    ThemeData theme,
    String title,
    String description,
    IconData icon,
    Color iconColor,
    String styleValue,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () async {
        await preferencesService.setRegulationStyle(styleValue);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? iconColor.withValues(alpha: 0.1)
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? iconColor.withValues(alpha: 0.5)
                : theme.colorScheme.outline.withValues(alpha: 0.15),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: iconColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

