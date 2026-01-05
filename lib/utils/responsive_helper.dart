import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Responsive design helper utility for mobile and web
/// Provides breakpoints, adaptive sizing, and layout constraints
class ResponsiveHelper {
  ResponsiveHelper._();

  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  static const double largeDesktopBreakpoint = 1800;

  // Max content width for web
  static const double maxContentWidth = 1400;
  static const double maxContentWidthNarrow = 1200;

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Check if current screen is desktop/web
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Check if current screen is large desktop
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= largeDesktopBreakpoint;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isMobile(context)) {
      return EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h);
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h);
    } else {
      return EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h);
    }
  }

  /// Get responsive horizontal padding
  static double getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) {
      return 4.w;
    } else if (isTablet(context)) {
      return 6.w;
    } else {
      return 8.w;
    }
  }

  /// Get responsive vertical padding
  static double getVerticalPadding(BuildContext context) {
    if (isMobile(context)) {
      return 2.h;
    } else if (isTablet(context)) {
      return 3.h;
    } else {
      return 4.h;
    }
  }

  /// Get responsive spacing between elements
  static double getSpacing(BuildContext context, {double mobile = 2.0, double tablet = 3.0, double desktop = 4.0}) {
    if (isMobile(context)) {
      return mobile.h;
    } else if (isTablet(context)) {
      return tablet.h;
    } else {
      return desktop.h;
    }
  }

  /// Get responsive font size multiplier
  static double getFontSizeMultiplier(BuildContext context) {
    if (isMobile(context)) {
      return 1.0;
    } else if (isTablet(context)) {
      return 1.1;
    } else {
      return 1.2;
    }
  }

  /// Get responsive card padding
  static EdgeInsets getCardPadding(BuildContext context) {
    if (isMobile(context)) {
      return EdgeInsets.all(4.w);
    } else if (isTablet(context)) {
      return EdgeInsets.all(5.w);
    } else {
      return EdgeInsets.all(6.w);
    }
  }

  /// Get responsive grid cross axis count
  static int getGridCrossAxisCount(BuildContext context, {int mobile = 2, int tablet = 3, int desktop = 4}) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  /// Get responsive column count for lists
  static int getColumnCount(BuildContext context, {int mobile = 1, int tablet = 2, int desktop = 3}) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  /// Wrap content with max width constraint for web
  static Widget wrapWithMaxWidth(BuildContext context, Widget child, {double? maxWidth}) {
    if (isDesktop(context)) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? maxContentWidth,
          ),
          child: child,
        ),
      );
    }
    return child;
  }

  /// Get responsive icon size
  static double getIconSize(BuildContext context, {double mobile = 24, double tablet = 28, double desktop = 32}) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  /// Get responsive button height
  static double getButtonHeight(BuildContext context) {
    if (isMobile(context)) {
      return 48;
    } else if (isTablet(context)) {
      return 52;
    } else {
      return 56;
    }
  }

  /// Get responsive border radius
  static double getBorderRadius(BuildContext context, {double mobile = 12, double tablet = 16, double desktop = 20}) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  /// Get responsive app bar height
  static double getAppBarHeight(BuildContext context) {
    if (isMobile(context)) {
      return kToolbarHeight;
    } else if (isTablet(context)) {
      return kToolbarHeight + 8;
    } else {
      return kToolbarHeight + 12;
    }
  }

  /// Get responsive bottom navigation height
  static double getBottomNavHeight(BuildContext context) {
    if (isMobile(context)) {
      return 56;
    } else if (isTablet(context)) {
      return 64;
    } else {
      return 72;
    }
  }

  /// Get responsive dialog width
  static double? getDialogWidth(BuildContext context) {
    if (isMobile(context)) {
      return null; // Full width on mobile
    } else if (isTablet(context)) {
      return MediaQuery.of(context).size.width * 0.6;
    } else {
      return MediaQuery.of(context).size.width * 0.4;
    }
  }

  /// Get responsive drawer width
  static double getDrawerWidth(BuildContext context) {
    if (isMobile(context)) {
      return MediaQuery.of(context).size.width * 0.75;
    } else if (isTablet(context)) {
      return 300;
    } else {
      return 360;
    }
  }

  /// Check if should show sidebar navigation (web)
  static bool shouldShowSidebar(BuildContext context) {
    return isDesktop(context);
  }

  /// Check if should show bottom navigation (mobile/tablet)
  static bool shouldShowBottomNav(BuildContext context) {
    return !isDesktop(context);
  }
}

