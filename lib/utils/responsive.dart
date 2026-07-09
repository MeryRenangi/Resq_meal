import 'package:flutter/material.dart';

enum ScreenSize { mobile, tablet, desktop }

abstract final class Responsive {
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 900;

  static ScreenSize of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktopBreakpoint) return ScreenSize.desktop;
    if (width >= tabletBreakpoint) return ScreenSize.tablet;
    return ScreenSize.mobile;
  }

  static int gridColumns(BuildContext context, {int mobile = 2, int tablet = 3, int desktop = 4}) {
    return switch (of(context)) {
      ScreenSize.mobile => mobile,
      ScreenSize.tablet => tablet,
      ScreenSize.desktop => desktop,
    };
  }

  static double contentMaxWidth(BuildContext context) {
    return switch (of(context)) {
      ScreenSize.mobile => double.infinity,
      ScreenSize.tablet => 720,
      ScreenSize.desktop => 1100,
    };
  }

  static EdgeInsets pagePadding(BuildContext context) {
    final size = of(context);
    final horizontal = switch (size) {
      ScreenSize.mobile => 16.0,
      ScreenSize.tablet => 24.0,
      ScreenSize.desktop => 32.0,
    };
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: 16);
  }
}
