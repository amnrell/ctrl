import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/theme_manager_service.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/ai_suggested_vibes_widget.dart';
import './widgets/vibe_color_wheel_widget.dart';
import './widgets/vibe_option_card_widget.dart';

/// Vibe Selection screen for setting emotional states through color-coded interface
/// with real-time theme preview and AI-powered recommendations
class VibeSelection extends StatefulWidget {
  const VibeSelection({super.key});

  @override
  State<VibeSelection> createState() => _VibeSelectionState();
}

class _VibeSelectionState extends State<VibeSelection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedVibe;
  Color? _selectedColor;
  String _currentVibe = 'Zen';
  Color _currentColor = const Color(0xFF4A7C59);

  final ThemeManagerService _themeManager = ThemeManagerService();

  // Vibe categories for tab organization
  final List<String> _vibeCategories = ['All', 'Calm', 'Energetic', 'Creative'];

  // Comprehensive vibe options with colors and descriptions
  final List<Map<String, dynamic>> _vibeOptions = [
    {
      'name': 'Zen',
      'color': Color(0xFF4A7C59),
      'category': 'Calm',
      'description': 'Grounded and peaceful state',
      'icon': 'self_improvement',
    },
    {
      'name': 'Hopeful',
      'color': Color(0xFFE8B86D),
      'category': 'Energetic',
      'description': 'Optimistic and motivated',
      'icon': 'wb_sunny',
    },
    {
      'name': 'Calm',
      'color': Color(0xFF6B73FF),
      'category': 'Calm',
      'description': 'Thoughtful and introspective',
      'icon': 'water_drop',
    },
    {
      'name': 'Energetic',
      'color': Color(0xFFE74C3C),
      'category': 'Energetic',
      'description': 'Active and dynamic',
      'icon': 'bolt',
    },
    {
      'name': 'Creative',
      'color': Color(0xFF9B59B6),
      'category': 'Creative',
      'description': 'Imaginative and inspired',
      'icon': 'palette',
    },
    {
      'name': 'Focused',
      'color': Color(0xFF2C3E50),
      'category': 'Calm',
      'description': 'Concentrated and determined',
      'icon': 'center_focus_strong',
    },
    {
      'name': 'Joyful',
      'color': Color(0xFFF39C12),
      'category': 'Energetic',
      'description': 'Happy and uplifted',
      'icon': 'sentiment_very_satisfied',
    },
    {
      'name': 'Reflective',
      'color': Color(0xFF34495E),
      'category': 'Calm',
      'description': 'Contemplative and mindful',
      'icon': 'psychology',
    },
    {
      'name': 'Adventurous',
      'color': Color(0xFF16A085),
      'category': 'Energetic',
      'description': 'Bold and exploratory',
      'icon': 'explore',
    },
    {
      'name': 'Inspired',
      'color': Color(0xFFE91E63),
      'category': 'Creative',
      'description': 'Motivated and innovative',
      'icon': 'lightbulb',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _vibeCategories.length, vsync: this);

    // Load current vibe from theme manager to display correct state
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _themeManager.initialize();

      // Use saved vibe name directly
      _currentVibe = _themeManager.currentVibeName;
      _currentColor = _themeManager.primaryVibeColor;

      setState(() {
        _selectedVibe = _currentVibe;
        _selectedColor = _currentColor;
      });
    });

    // Add listener to refresh on tab change
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          // Force rebuild when tab changes
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredVibes() {
    final selectedCategory = _vibeCategories[_tabController.index];
    if (selectedCategory == 'All') {
      return _vibeOptions;
    }
    return _vibeOptions
        .where((vibe) => vibe['category'] == selectedCategory)
        .toList();
  }

  void _onVibeSelected(String vibeName, Color vibeColor) {
    HapticFeedback.mediumImpact();
    setState(() {
      // Ensure immediate state update for responsiveness
      _selectedVibe = vibeName;
      _selectedColor = vibeColor;
    });
    // Force rebuild of widget tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _saveVibe() async {
    HapticFeedback.lightImpact();

    // Save with vibe name to ThemeManagerService BEFORE navigating back
    if (_selectedColor != null && _selectedVibe != null) {
      await _themeManager.setPrimaryVibeColor(
        _selectedColor!,
        vibeName: _selectedVibe!,
      );
    }

    // Apply theme globally and navigate back
    if (mounted) {
      Navigator.pop(context, {
        'vibe': _selectedVibe,
        'color': _selectedColor,
      });
    }
  }

  void _cancelSelection() {
    HapticFeedback.lightImpact();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: _selectedColor ?? _currentColor,
          primaryContainer:
              (_selectedColor ?? _currentColor).withValues(alpha: 0.15),
        ),
      ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Header with current vibe indicator and actions
              _buildHeader(theme),

              // Tab bar for vibe categories
              _buildTabBar(theme),

              // Main content area
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: List.generate(
                    _vibeCategories.length,
                    (index) => _buildVibeGrid(theme),
                  ),
                ),
              ),

              // AI suggested vibes section
              AiSuggestedVibesWidget(
                onVibeSelected: _onVibeSelected,
                selectedVibe: _selectedVibe,
              ),

              // Save button
              _buildSaveButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cancel button
          TextButton(
            onPressed: _cancelSelection,
            child: Text(
              'Cancel',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),

          // Current vibe indicator
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: _selectedColor ?? _currentColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (_selectedColor ?? _currentColor)
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                _selectedVibe ?? _currentVibe,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),

          // Save button
          TextButton(
            onPressed: _selectedVibe != _currentVibe ? _saveVibe : null,
            child: Text(
              'Save',
              style: theme.textTheme.titleMedium?.copyWith(
                color: _selectedVibe != _currentVibe
                    ? (_selectedColor ?? _currentColor)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: _selectedColor ?? _currentColor,
        unselectedLabelColor:
            theme.colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: _selectedColor ?? _currentColor,
        indicatorWeight: 3,
        labelStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: _vibeCategories.map((category) {
          return Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(category),
            ),
          );
        }).toList(),
        onTap: (index) {
          HapticFeedback.selectionClick();
          setState(() {});
        },
      ),
    );
  }

  Widget _buildVibeGrid(ThemeData theme) {
    final filteredVibes = _getFilteredVibes();

    return SingleChildScrollView(
      key: ValueKey(
          '${_tabController.index}_$_selectedVibe'), // Force rebuild on changes
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color wheel visualization
          VibeColorWheelWidget(
            vibes: filteredVibes,
            selectedVibe: _selectedVibe,
            onVibeSelected: _onVibeSelected,
          ),

          SizedBox(height: 3.h),

          // Grid of vibe options
          GridView.builder(
            key: ValueKey('grid_${_tabController.index}_$_selectedVibe'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 0.85,
            ),
            itemCount: filteredVibes.length,
            itemBuilder: (context, index) {
              final vibe = filteredVibes[index];
              final isSelected = _selectedVibe == vibe['name'];
              return VibeOptionCardWidget(
                key: ValueKey(
                    '${vibe['name']}_$isSelected'), // Unique key for each state
                vibeName: vibe['name'] as String,
                vibeColor: vibe['color'] as Color,
                vibeDescription: vibe['description'] as String,
                vibeIcon: vibe['icon'] as String,
                isSelected: isSelected,
                onTap: () => _onVibeSelected(
                  vibe['name'] as String,
                  vibe['color'] as Color,
                ),
                onLongPress: () => _showCustomizationMenu(
                  context,
                  vibe['name'] as String,
                  vibe['color'] as Color,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 6.h,
        child: ElevatedButton(
          onPressed: _selectedVibe != _currentVibe ? _saveVibe : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedColor ?? _currentColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor:
                theme.colorScheme.onSurface.withValues(alpha: 0.12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Apply Vibe',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _showCustomizationMenu(
      BuildContext context, String vibeName, Color vibeColor) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            Text(
              'Customize $vibeName',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),

            SizedBox(height: 2.h),

            ListTile(
              leading: CustomIconWidget(
                iconName: 'palette',
                color: vibeColor,
                size: 24,
              ),
              title: const Text('Adjust Color'),
              subtitle: const Text('Personalize vibe color'),
              onTap: () {
                Navigator.pop(context);
                // Color picker would be implemented here
              },
            ),

            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: vibeColor,
                size: 24,
              ),
              title: const Text('Rename Vibe'),
              subtitle: const Text('Give it a personal name'),
              onTap: () {
                Navigator.pop(context);
                // Rename dialog would be implemented here
              },
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
