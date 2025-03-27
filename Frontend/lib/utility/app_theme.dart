import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF007AFF);
  static const Color secondaryBlue = Color(0xFF5AC8FA);
  static const Color lightBlue = Color(0xFF64D2FF);
  static const Color darkBlue = Color(0xFF0040DD);
  static const Color accentBlue = Color(0xFF32ADE6);

  static const Color background = Color(0xFFF2F2F7);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF8E8E93);
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF636366);
  static const Color error = Color(0xFFFF3B30);
  static const Color accent = Color(0xFFFF9500);

  static const Color buttonBackground = CupertinoColors.activeBlue;
  static const Color buttonText = CupertinoColors.white;
}

class AppFonts {
  static const String primaryFont = 'SF Pro Display';

  static const TextStyle heading = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: primaryFont,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: primaryFont,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: primaryFont,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    fontFamily: primaryFont,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
    fontFamily: primaryFont,
  );
}

class AppButton {
  static Widget fullWidthButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: CupertinoButton(
            onPressed: onPressed,
            color: AppColors.buttonBackground,
            borderRadius: BorderRadius.circular(12),
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              text,
              style: AppFonts.buttonText,
            ),
          ),
        ),
      ),
    );
  }

  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 100,
          child: CupertinoButton(
            onPressed: onPressed,
            color: AppColors.buttonBackground,
            borderRadius: BorderRadius.circular(12),
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              text,
              style: AppFonts.buttonText,
            ),
          ),
        ),
      ),
    );
  }

  static Widget secondaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 100,
          child: CupertinoButton(
            onPressed: onPressed,
            color: AppColors.grey,
            borderRadius: BorderRadius.circular(12),
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              text,
              style: AppFonts.buttonText,
            ),
          ),
        ),
      ),
    );
  }
}
