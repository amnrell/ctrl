import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App bar variant types for different screen contexts
enum CustomAppBarVariant {
  /// Standard app bar with title and optional actions
  standard,

  /// App bar with back button for navigation
  withBack,

  /// App bar with close button for modal contexts
  withClose,

  /// Minimal app bar with just actions (transparent background)
  minimal,

  /// App bar with search functionality
  withSearch,
}

/// Custom app bar widget implementing clean emotional minimalism design
/// with vibe-based theming and contextual variations.
///
/// Features:
/// - Multiple variants for different contexts (standard, back, close, minimal, search)
/// - Dynamic vibe color theming
/// - Haptic feedback on interactions
/// - Smooth transitions and animations
/// - Accessibility support
/// - Safe area handling
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar title text
  final String? title;

  /// Custom title widget (overrides title text)
  final Widget? titleWidget;

  /// Leading widget (overrides default back/close button)
  final Widget? leading;

  /// Action widgets displayed on the right
  final List<Widget>? actions;

  /// App bar variant type
  final CustomAppBarVariant variant;

  /// Optional custom vibe color for theming
  final Color? vibeColor;

  /// Whether to center the title (defaults to true)
  final bool centerTitle;

  /// Custom elevation (defaults to 0 for flat design)
  final double elevation;

  /// Background color (defaults to theme surface color)
  final Color? backgroundColor;

  /// Foreground color for text and icons
  final Color? foregroundColor;

  /// Callback when back/close button is pressed
  final VoidCallback? onLeadingPressed;

  /// Search query callback (only for withSearch variant)
  final ValueChanged<String>? onSearchChanged;

  /// Search hint text (only for withSearch variant)
  final String searchHint;

  /// Whether to show search field initially (only for withSearch variant)
  final bool showSearchInitially;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.variant = CustomAppBarVariant.standard,
    this.vibeColor,
    this.centerTitle = true,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.onLeadingPressed,
    this.onSearchChanged,
    this.searchHint = 'Search...',
    this.showSearchInitially = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on variant and theme
    final effectiveBackgroundColor = backgroundColor ??
        (variant == CustomAppBarVariant.minimal
            ? Colors.transparent
            : colorScheme.surface);

    final effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;

    final effectiveVibeColor = vibeColor ?? colorScheme.primary;

    return AppBar(
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: _buildLeading(context, effectiveForegroundColor),
      title: _buildTitle(context, effectiveForegroundColor, effectiveVibeColor),
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, Color foregroundColor) {
    if (leading != null) return leading;

    switch (variant) {
      case CustomAppBarVariant.withBack:
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          color: foregroundColor,
          tooltip: 'Back',
          onPressed: () {
            HapticFeedback.lightImpact();
            if (onLeadingPressed != null) {
              onLeadingPressed!();
            } else {
              Navigator.of(context).pop();
            }
          },
        );

      case CustomAppBarVariant.withClose:
        return IconButton(
          icon: const Icon(Icons.close),
          color: foregroundColor,
          tooltip: 'Close',
          onPressed: () {
            HapticFeedback.lightImpact();
            if (onLeadingPressed != null) {
              onLeadingPressed!();
            } else {
              Navigator.of(context).pop();
            }
          },
        );

      default:
        return null;
    }
  }

  Widget? _buildTitle(
      BuildContext context, Color foregroundColor, Color vibeColor) {
    if (titleWidget != null) return titleWidget;

    if (variant == CustomAppBarVariant.withSearch) {
      return _SearchAppBarTitle(
        hint: searchHint,
        onChanged: onSearchChanged,
        showInitially: showSearchInitially,
        foregroundColor: foregroundColor,
        vibeColor: vibeColor,
      );
    }

    if (title == null) return null;

    final theme = Theme.of(context);

    return Text(
      title!,
      style: theme.appBarTheme.titleTextStyle?.copyWith(
        color: foregroundColor,
      ),
    );
  }
}

/// Internal widget for search app bar functionality
class _SearchAppBarTitle extends StatefulWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final bool showInitially;
  final Color foregroundColor;
  final Color vibeColor;

  const _SearchAppBarTitle({
    required this.hint,
    required this.onChanged,
    required this.showInitially,
    required this.foregroundColor,
    required this.vibeColor,
  });

  @override
  State<_SearchAppBarTitle> createState() => _SearchAppBarTitleState();
}

class _SearchAppBarTitleState extends State<_SearchAppBarTitle> {
  late bool _isSearching;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _isSearching = widget.showInitially;
    if (_isSearching) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        _searchFocusNode.unfocus();
        widget.onChanged?.call('');
      }
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSearching) {
      return Row(
        children: [
          Expanded(
            child: Text(
              widget.hint,
              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                    color: widget.foregroundColor,
                  ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            color: widget.foregroundColor,
            onPressed: _toggleSearch,
            tooltip: 'Search',
          ),
        ],
      );
    }

    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      style: TextStyle(color: widget.foregroundColor),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: widget.foregroundColor.withValues(alpha: 0.6),
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          color: widget.foregroundColor,
          onPressed: _toggleSearch,
          tooltip: 'Clear search',
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}

/// Helper extension for creating common app bar configurations
extension CustomAppBarFactory on CustomAppBar {
  /// Creates a standard app bar with title
  static CustomAppBar standard({
    required String title,
    List<Widget>? actions,
    Color? vibeColor,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      vibeColor: vibeColor,
      variant: CustomAppBarVariant.standard,
    );
  }

  /// Creates an app bar with back navigation
  static CustomAppBar withBack({
    required String title,
    List<Widget>? actions,
    VoidCallback? onBack,
    Color? vibeColor,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      vibeColor: vibeColor,
      variant: CustomAppBarVariant.withBack,
      onLeadingPressed: onBack,
    );
  }

  /// Creates an app bar with close button for modals
  static CustomAppBar withClose({
    required String title,
    List<Widget>? actions,
    VoidCallback? onClose,
    Color? vibeColor,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      vibeColor: vibeColor,
      variant: CustomAppBarVariant.withClose,
      onLeadingPressed: onClose,
    );
  }

  /// Creates a minimal transparent app bar
  static CustomAppBar minimal({
    List<Widget>? actions,
    Color? vibeColor,
  }) {
    return CustomAppBar(
      actions: actions,
      vibeColor: vibeColor,
      variant: CustomAppBarVariant.minimal,
    );
  }

  /// Creates an app bar with search functionality
  static CustomAppBar withSearch({
    required String searchHint,
    required ValueChanged<String> onSearchChanged,
    bool showSearchInitially = false,
    List<Widget>? actions,
    Color? vibeColor,
  }) {
    return CustomAppBar(
      searchHint: searchHint,
      onSearchChanged: onSearchChanged,
      showSearchInitially: showSearchInitially,
      actions: actions,
      vibeColor: vibeColor,
      variant: CustomAppBarVariant.withSearch,
    );
  }
}
