import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/theme_manager_service.dart';

/// Widget for font size and style customization
class FontCustomizationSectionWidget extends StatelessWidget {
  final ThemeManagerService themeManager;
  final VoidCallback onFontChanged;

  const FontCustomizationSectionWidget({
    super.key,
    required this.themeManager,
    required this.onFontChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                Icons.text_fields,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Font Customization',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Font size slider
          _buildFontSizeSlider(theme),
          SizedBox(height: 2.h),

          // Font style selector
          _buildFontStyleSelector(theme),
        ],
      ),
    );
  }

  Widget _buildFontSizeSlider(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Font Size',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${(themeManager.fontSizeMultiplier * 100).toInt()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Icon(
              Icons.text_decrease,
              size: 20,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            Expanded(
              child: Slider(
                value: themeManager.fontSizeMultiplier,
                min: 0.8,
                max: 1.5,
                divisions: 14,
                label: '${(themeManager.fontSizeMultiplier * 100).toInt()}%',
                onChanged: (value) async {
                  HapticFeedback.selectionClick();
                  await themeManager.setFontSizeMultiplier(value);
                  onFontChanged();
                },
              ),
            ),
            Icon(
              Icons.text_increase,
              size: 24,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('80%', style: theme.textTheme.bodySmall),
              Text('150%', style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFontStyleSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Font Style',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: ThemeManagerService.fontStyleOptions.map((fontStyle) {
            final isSelected = themeManager.fontStyle == fontStyle;

            return GestureDetector(
              onTap: () async {
                HapticFeedback.lightImpact();
                await themeManager.setFontStyle(fontStyle);
                onFontChanged();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  fontStyle,
                  style: _getFontStyle(fontStyle, theme, isSelected),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  TextStyle _getFontStyle(String fontStyle, ThemeData theme, bool isSelected) {
    final baseStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isSelected
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.onSurface,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
    );

    switch (fontStyle) {
      case 'Inter':
        return GoogleFonts.inter(textStyle: baseStyle);
      case 'Roboto':
        return GoogleFonts.roboto(textStyle: baseStyle);
      case 'Poppins':
        return GoogleFonts.poppins(textStyle: baseStyle);
      case 'Lato':
        return GoogleFonts.lato(textStyle: baseStyle);
      case 'Open Sans':
        return GoogleFonts.openSans(textStyle: baseStyle);
      default:
        return baseStyle!;
    }
  }
}
