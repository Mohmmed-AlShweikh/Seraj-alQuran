import 'package:flutter/material.dart';

extension Responsive on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < 600;
  bool get isTablet => MediaQuery.of(this).size.width >= 600;
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
}
