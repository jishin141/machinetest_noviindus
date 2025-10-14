import 'package:flutter/material.dart';

class Responsive {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Screen size helpers
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  // Get responsive values
  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // Spacing
  static double getSpacing(
    BuildContext context, {
    double mobile = 8,
    double tablet = 12,
    double desktop = 16,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Padding
  static EdgeInsets getHorizontalPadding(
    BuildContext context, {
    double mobile = 12,
    double tablet = 16,
    double desktop = 20,
  }) {
    final padding = isMobile(context)
        ? mobile
        : isTablet(context)
        ? tablet
        : desktop;
    return EdgeInsets.symmetric(horizontal: padding);
  }

  static EdgeInsets getVerticalPadding(
    BuildContext context, {
    double mobile = 8,
    double tablet = 12,
    double desktop = 16,
  }) {
    final padding = isMobile(context)
        ? mobile
        : isTablet(context)
        ? tablet
        : desktop;
    return EdgeInsets.symmetric(vertical: padding);
  }

  static EdgeInsets getAllPadding(
    BuildContext context, {
    double mobile = 12,
    double tablet = 16,
    double desktop = 20,
  }) {
    final padding = isMobile(context)
        ? mobile
        : isTablet(context)
        ? tablet
        : desktop;
    return EdgeInsets.all(padding);
  }

  // Font sizes
  static double getSmallFontSize(
    BuildContext context, {
    double mobile = 14,
    double tablet = 14,
    double desktop = 16,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static double getBodyFontSize(
    BuildContext context, {
    double mobile = 16,
    double tablet = 16,
    double desktop = 18,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static double getTitleFontSize(
    BuildContext context, {
    double mobile = 18,
    double tablet = 18,
    double desktop = 20,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static double getLargeFontSize(
    BuildContext context, {
    double mobile = 28,
    double tablet = 20,
    double desktop = 24,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Component sizes
  static double getChipHeight(
    BuildContext context, {
    double mobile = 40,
    double tablet = 44,
    double desktop = 48,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static double getAvatarRadius(
    BuildContext context, {
    double mobile = 14,
    double tablet = 16,
    double desktop = 18,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static double getIconSize(
    BuildContext context, {
    double mobile = 20,
    double tablet = 24,
    double desktop = 28,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Aspect ratios
  static double getAspectRatio(
    BuildContext context, {
    double mobile = 16 / 9,
    double tablet = 16 / 9,
    double desktop = 16 / 9,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Video player dimensions
  static double getVideoHeight(
    BuildContext context, {
    double mobile = 200,
    double tablet = 250,
    double desktop = 300,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Button sizes
  static double getButtonHeight(
    BuildContext context, {
    double mobile = 46,
    double tablet = 48,
    double desktop = 48,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Grid columns
  static int getGridColumns(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Container dimensions
  static double getContainerWidth(
    BuildContext context, {
    double mobile = double.infinity,
    double tablet = 600,
    double desktop = 800,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Border radius
  static double getBorderRadius(
    BuildContext context, {
    double mobile = 8,
    double tablet = 12,
    double desktop = 16,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Elevation
  static double getElevation(
    BuildContext context, {
    double mobile = 2,
    double tablet = 4,
    double desktop = 6,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }
}
