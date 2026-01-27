import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../services/profile_preferences_service.dart';

/// Widget for managing personal goals
class PersonalGoalsWidget extends StatelessWidget {
  final ProfilePreferencesService preferencesService;

  const PersonalGoalsWidget({
    super.key,
    required this.preferencesService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: preferencesService,
      builder: (context, child) {
        final goals = preferencesService.personalGoals;

        return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Goals',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Set and track your digital wellness goals',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () => _showAddGoalDialog(context),
              icon: Icon(Icons.add_circle_outline),
              color: theme.colorScheme.primary,
            ),
          ],
        ),
        SizedBox(height: 2.h),
        if (goals.isEmpty)
          _buildEmptyState(context, theme)
        else
          ...goals.map((goal) => _buildGoalCard(context, theme, goal)),
      ],
    );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.flag_outlined,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          SizedBox(height: 2.h),
          Text(
            'No goals yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Add your first goal to start tracking your digital wellness journey',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton.icon(
            onPressed: () => _showAddGoalDialog(context),
            icon: Icon(Icons.add),
            label: Text('Add Goal'),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, ThemeData theme, String goal) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.flag,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              goal,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          IconButton(
            onPressed: () async {
              await preferencesService.removePersonalGoal(goal);
            },
            icon: Icon(Icons.delete_outline),
            color: theme.colorScheme.error,
          ),
        ],
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Personal Goal'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Goal',
            hintText: 'e.g., Reduce social media usage by 30%',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await preferencesService.addPersonalGoal(controller.text);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}

