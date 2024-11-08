import 'package:flutter/material.dart';

/* Prevent overscroll from showing the glow effect */
class NoGlowBehavior extends ScrollBehavior {
  //MARK: build
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
