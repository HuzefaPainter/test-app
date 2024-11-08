import 'package:employee_app/ui_helpers/no_glow_behavior.dart';
import 'package:flutter/material.dart';

class NoGlowConfiguration extends StatelessWidget {
  final Widget child;
  const NoGlowConfiguration({super.key, required this.child});

  //MARK: build
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlowBehavior(),
      child: child,
    );
  }
}
