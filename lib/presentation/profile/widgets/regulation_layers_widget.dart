import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../services/profile_preferences_service.dart';

/// Widget displaying regulation layers with toggle controls
class RegulationLayersWidget extends StatelessWidget {
  final ProfilePreferencesService preferencesService;

  const RegulationLayersWidget({
    super.key,
    required this.preferencesService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return ListenableBuilder(
      listenable: preferencesService,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Regulation Layers',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Control which regulation tools are active. Each layer serves a different purpose in helping you maintain digital wellness.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 2.h),
            _buildLayerCard(
              context,
              theme,
              primaryColor,
              'Awareness',
              'Track your impulses and moods through check-ins and reflection prompts',
              Icons.visibility_outlined,
              Colors.green,
              'awareness',
              preferencesService.awarenessEnabled,
            ),
            SizedBox(height: 1.5.h),
            _buildLayerCard(
              context,
              theme,
              primaryColor,
              'Interruption',
              'Add friction screens and cooldown timers to break compulsive patterns',
              Icons.pause_circle_outline,
              Colors.blue,
              'interruption',
              preferencesService.interruptionEnabled,
            ),
            SizedBox(height: 1.5.h),
            _buildLayerCard(
              context,
              theme,
              primaryColor,
              'Stabilization',
              'Protect active flow states and minimize distracting stat feedback',
              Icons.balance_outlined,
              Colors.purple,
              'stabilization',
              preferencesService.stabilizationEnabled,
            ),
            SizedBox(height: 1.5.h),
            _buildLayerCard(
              context,
              theme,
              primaryColor,
              'Cognitive',
              'Weekly summaries and reflection prompts for deeper self-awareness',
              Icons.psychology_outlined,
              Colors.green,
              'cognitive',
              preferencesService.cognitiveEnabled,
            ),
            SizedBox(height: 1.5.h),
            _buildLayerCard(
              context,
              theme,
              primaryColor,
              'Dopamine Budgeting',
              'Manage your dopamine consumption through smart friction and flow protection',
              Icons.trending_up_outlined,
              Colors.purple,
              'dopamine',
              preferencesService.dopamineBudgetingEnabled,
            ),
             SizedBox(height: 5.h),
          ],
        );
      },
    );
  }

  Widget _buildLayerCard(
    BuildContext context,
    ThemeData theme,
    Color primaryColor,
    String title,
    String description,
    IconData icon,
    Color iconColor,
    String layerKey,
    bool isEnabled,
  ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnabled
              ? iconColor.withValues(alpha: 0.5)
              : theme.colorScheme.outline.withValues(alpha: 0.15),
          width: isEnabled ? 2 : 1,
        ),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) async {
              await preferencesService.toggleLayer(layerKey, value);
            },
          ),
        ],
      ),
    );
  }
}

