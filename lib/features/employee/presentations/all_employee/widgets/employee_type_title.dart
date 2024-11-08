import 'package:flutter/material.dart';
import 'package:realtime_innovations/theme/custom_text_theme.dart';

class EmployeeTypeTitle extends StatelessWidget {
  const EmployeeTypeTitle({
    super.key,
    required this.type,
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        type,
        style: CustomTextTheme.roboto().copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1DA1F2),
        ),
      ),
    );
  }
}
