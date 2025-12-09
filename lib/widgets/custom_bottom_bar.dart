import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


/// Navigation item configuration for the bottom bar
enum CustomBottomBarItem {
  dashboard(
    route: '/main-dashboard',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    label: 'Home',
    useCustomIcon: false,
  ),
  ctrlCenter(
    route: '/ctrl-center',
    icon: Icons.psychology_outlined,
    activeIcon: Icons.psychology,
    label: 'CTRL',
    useCustomIcon: true,
    customIconPath: 'assets/images/ctrl-logo-png-transparent-1765008694800.png',
  ),
  analytics(
    route: '/usage-analytics',
    icon: Icons.bar_chart_outlined,
    activeIcon: Icons.bar_chart,
    label: 'Analytics',
    useCustomIcon: false,
  ),
  settings(
    route: '/settings-screen',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
    label: 'Settings',
    useCustomIcon: false,
  );

  const CustomBottomBarItem({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.useCustomIcon = false,
    this.customIconPath,
  });

  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool useCustomIcon;
  final String? customIconPath;
}

/// Custom bottom navigation bar widget implementing thumb-friendly interaction design
/// with vibe-based theming and haptic feedback for emotional wellness app.
///
/// Features:
/// - Platform-native bottom tab bar with 56dp height (Android) / standard iOS dimensions
/// - Dynamic theming based on current vibe state
/// - Haptic feedback on navigation
/// - Smooth 200ms ease-out transitions
/// - Minimum 44pt/48dp touch targets with 8pt spacing
/// - Accessibility support with semantic labels
class CustomBottomBar extends StatefulWidget {
  /// Current active route path
  final String currentRoute;

  /// Callback when navigation item is tapped
  final Function(String route)? onNavigate;

  /// Optional custom vibe color for theming (defaults to theme primary color)
  final Color? vibeColor;

  /// Whether to show labels (defaults to true)
  final bool showLabels;

  /// Custom elevation (defaults to 8)
  final double elevation;

  const CustomBottomBar({
    super.key,
    required this.currentRoute,
    this.onNavigate,
    this.vibeColor,
    this.showLabels = true,
    this.elevation = 8.0,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _currentIndex = 0;
  final Map<String, bool> _imageLoadErrors = {};

  @override
  void initState() {
    super.initState();
    _updateCurrentIndex();

    // Initialize animation controller for smooth transitions (200ms)
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(CustomBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentRoute != widget.currentRoute) {
      _updateCurrentIndex();
    }
  }

  void _updateCurrentIndex() {
    final items = CustomBottomBarItem.values;
    for (int i = 0; i < items.length; i++) {
      if (items[i].route == widget.currentRoute) {
        setState(() {
          _currentIndex = i;
        });
        break;
      }
    }
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    // Haptic feedback for emotional connection
    HapticFeedback.lightImpact();

    // Animate tap
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    setState(() {
      _currentIndex = index;
    });

    final route = CustomBottomBarItem.values[index].route;

    if (widget.onNavigate != null) {
      widget.onNavigate!(route);
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomNavTheme = theme.bottomNavigationBarTheme;

    // Use custom vibe color or fall back to theme primary
    final activeColor = widget.vibeColor ?? colorScheme.primary;
    final inactiveColor =
        bottomNavTheme.unselectedItemColor ??
        colorScheme.onSurface.withAlpha(150);
    final backgroundColor =
        bottomNavTheme.backgroundColor ?? colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56, // Standard Android bottom nav height
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              CustomBottomBarItem.values.length,
              (index) => _buildNavigationItem(
                context,
                item: CustomBottomBarItem.values[index],
                index: index,
                isSelected: index == _currentIndex,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context, {
    required CustomBottomBarItem item,
    required int index,
    required bool isSelected,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Expanded(
      child: ScaleTransition(
        scale:
            index == _currentIndex
                ? _scaleAnimation
                : const AlwaysStoppedAnimation(1.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onItemTapped(index),
            borderRadius: BorderRadius.circular(12),
            splashColor: activeColor.withAlpha(25),
            highlightColor: activeColor.withAlpha(13),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with smooth transition
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: _buildIconWidget(
                      item,
                      isSelected,
                      activeColor,
                      inactiveColor,
                    ),
                  ),

                  if (widget.showLabels) ...[
                    const SizedBox(height: 4),
                    // Label with smooth color transition
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      style:
                          (isSelected
                              ? textTheme.labelMedium?.copyWith(
                                color: activeColor,
                                fontWeight: FontWeight.w600,
                              )
                              : textTheme.labelMedium?.copyWith(
                                color: inactiveColor,
                                fontWeight: FontWeight.w400,
                              )) ??
                          TextStyle(
                            fontSize: 12,
                            color: isSelected ? activeColor : inactiveColor,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                      child: Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the icon widget with proper error handling and fallback
  Widget _buildIconWidget(
    CustomBottomBarItem item,
    bool isSelected,
    Color activeColor,
    Color inactiveColor,
  ) {
    final color = isSelected ? activeColor : inactiveColor;

    // Handle custom icon (CTRL logo)
    if (item.useCustomIcon && item.customIconPath != null) {
      final hasError = _imageLoadErrors[item.customIconPath] ?? false;

      // If image failed to load, use stylized text fallback
      if (hasError) {
        return _buildCtrlTextIcon(color, item.label);
      }

      // Try to load the image with error handling
      return Image.asset(
        item.customIconPath!,
        width: 24,
        height: 24,
        color: color,
        colorBlendMode: BlendMode.srcIn,
        semanticLabel: '${item.label} navigation',
        errorBuilder: (context, error, stackTrace) {
          // Mark this image as having an error
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _imageLoadErrors[item.customIconPath!] = true;
              });
            }
          });
          // Return fallback immediately
          return _buildCtrlTextIcon(color, item.label);
        },
      );
    }

    // Standard icon
    return Icon(
      isSelected ? item.activeIcon : item.icon,
      key: ValueKey('icon_$isSelected'),
      color: color,
      size: 24,
      semanticLabel: '${item.label} navigation',
    );
  }

  /// Builds a stylized text-based icon for CTRL as fallback
  Widget _buildCtrlTextIcon(Color color, String label) {
    return Container(
      key: ValueKey('text_icon_$label'),
      width: 24,
      height: 24,
      alignment: Alignment.center,
      child: Text(
        'CTRL',
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          color: color,
          letterSpacing: -0.5,
          height: 1,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Removed the extension as it's not needed with the new navigation approach

// For the integration, the method _navigateToScreen replaces previous navigation logic

// Additional part based on the edit snippet:

void _navigateToScreen(BuildContext context, int index) {
  HapticFeedback.lightImpact();

  switch (index) {
    case 0:
      Navigator.pushReplacementNamed(context, '/main-dashboard');
      break;
    case 1:
      Navigator.pushReplacementNamed(context, '/vibe-selection');
      break;
    case 2:
      Navigator.pushReplacementNamed(context, '/ctrl-center');
      break;
    case 3:
      Navigator.pushReplacementNamed(context, '/usage-analytics');
      break;
    case 4:
      Navigator.pushReplacementNamed(context, '/settings-screen');
      break;
  }
}

/// (Optional) List of BottomNavigationBarItems if needed elsewhere
/// Not used directly but preserved as per the snippet
const List<BottomNavigationBarItem> bottomNavigationItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    activeIcon: Icon(Icons.home),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.psychology_outlined),
    activeIcon: Icon(Icons.psychology),
    label: 'Vibes',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.chat_outlined),
    activeIcon: Icon(Icons.chat),
    label: 'CTRL',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.bar_chart_outlined),
    activeIcon: Icon(Icons.bar_chart),
    label: 'Analytics',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.settings_outlined),
    activeIcon: Icon(Icons.settings),
    label: 'Settings',
  ),
];