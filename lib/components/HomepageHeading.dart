import 'package:employee_app/ui_helpers/constants.dart';
import 'package:flutter/material.dart';

class HomepageHeading extends StatelessWidget {
  final String text;
  const HomepageHeading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 56,
      color: const Color(0xfff2f2f2),
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, height: 1.5, color: APP_BLUE),
      ),
    );
  }
}
