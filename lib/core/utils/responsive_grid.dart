import 'package:flutter/material.dart';

class ResponsiveGrid {
  static int getColumnCount(double width) {
    if (width >= 1400) return 6;
    if (width >= 1100) return 5;
    if (width >= 800) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  static double getChildAspectRatio(double width) {
    if (width >= 1100) return 1.1;
    if (width >= 800) return 1.15;
    return 1.2;
  }

  static SliverGridDelegate getDelegate(double width) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: getColumnCount(width),
      childAspectRatio: getChildAspectRatio(width),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
    );
  }
}
