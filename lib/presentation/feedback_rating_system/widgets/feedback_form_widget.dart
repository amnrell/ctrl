import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/theme_manager_service.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Comprehensive feedback form with categorization and screenshot attachment
class FeedbackFormWidget extends StatefulWidget {
  final String initialSentiment;
  final Function(Map<String, dynamic>) onSubmit;
  final VoidCallback onCancel;
  final ThemeManagerService themeManager;

  const FeedbackFormWidget({
    super.key,
    required this.initialSentiment,
    required this.onSubmit,
    required this.onCancel,
    required this.themeManager,
  });

  @override
  State<FeedbackFormWidget> createState() => _FeedbackFormWidgetState();
}

class _FeedbackFormWidgetState extends State<FeedbackFormWidget> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _selectedCategory = 'General';
  bool _includeContact = false;
  XFile? _screenshot;

  final List<String> _categories = [
    'General',
    'Bug Report',
    'Feature Request',
    'UI/UX',
    'Performance',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Share Your Feedback',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: widget.themeManager.primaryVibeColor,
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onCancel,
                icon: const Icon(Icons.close),
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Category selection
          Text(
            'Category',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _selectedCategory = category);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? widget.themeManager.primaryVibeColor
                            .withValues(alpha: 0.15)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? widget.themeManager.primaryVibeColor
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? widget.themeManager.primaryVibeColor
                          : theme.colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 2.h),

          // Feedback text field
          Text(
            'Your Feedback',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _feedbackController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Tell us what you think...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: widget.themeManager.primaryVibeColor,
                  width: 2,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Screenshot attachment
          _buildScreenshotSection(theme),

          SizedBox(height: 2.h),

          // Optional contact information
          Row(
            children: [
              Checkbox(
                value: _includeContact,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  setState(() => _includeContact = value ?? false);
                },
                activeColor: widget.themeManager.primaryVibeColor,
              ),
              Expanded(
                child: Text(
                  'Include my email for follow-up',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),

          if (_includeContact) ...[
            SizedBox(height: 1.h),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'your.email@example.com',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: widget.themeManager.primaryVibeColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],

          SizedBox(height: 3.h),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.themeManager.primaryVibeColor,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Submit Feedback',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenshotSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'image',
                color: widget.themeManager.primaryVibeColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Add Screenshot (Optional)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_screenshot == null)
                TextButton(
                  onPressed: _pickScreenshot,
                  child: Text(
                    'Add',
                    style:
                        TextStyle(color: widget.themeManager.primaryVibeColor),
                  ),
                ),
            ],
          ),
          if (_screenshot != null) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Screenshot attached',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _screenshot = null),
                  icon: const Icon(Icons.close, size: 20),
                  color: theme.colorScheme.error,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickScreenshot() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() => _screenshot = image);
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unable to pick image'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _handleSubmit() {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your feedback'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final feedbackData = {
      'sentiment': widget.initialSentiment,
      'category': _selectedCategory,
      'feedback': _feedbackController.text.trim(),
      'includeContact': _includeContact,
      'email': _includeContact ? _emailController.text.trim() : null,
      'hasScreenshot': _screenshot != null,
      'timestamp': DateTime.now().toIso8601String(),
    };

    widget.onSubmit(feedbackData);
  }
}
