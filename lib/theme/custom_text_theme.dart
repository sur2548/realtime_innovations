import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realtime_innovations/theme/app_colors.dart';

class CustomTextTheme {
  CustomTextTheme._();

  static TextStyle roboto() {
    return GoogleFonts.roboto();
  }

  /// [InputDecoration] with icon
  static InputDecoration decorationIcon(ImageProvider icon) {
    return InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12),
        child: SizedBox(
          height: 20,
          width: 20,
          child: Center(
            child: ImageIcon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
      ),
      border: const OutlineInputBorder(),
    );
  }
}
