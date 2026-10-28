import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppNoticeType { success, warning, error, info }


abstract final class AppNotice {
  static void show(
      BuildContext context,
      String message, {
        AppNoticeType type = AppNoticeType.info,
        Duration duration = const Duration(seconds: 3),
      }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    // Tránh SnackBar cũ nằm chờ trong hàng đợi.
    messenger.clearSnackBars();
    messenger.removeCurrentSnackBar();

    final (backgroundColor, iconData) = switch (type) {
      AppNoticeType.success => (
      AppColors.primaryDark,
      Icons.check_circle_outline_rounded,
      ),
      AppNoticeType.warning => (
      const Color(0xFF84591A),
      Icons.info_outline_rounded,
      ),
      AppNoticeType.error => (
      const Color(0xFF993E40),
      Icons.error_outline_rounded,
      ),
      AppNoticeType.info => (
      AppColors.text,
      Icons.info_outline_rounded,
      ),
    };

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        backgroundColor: backgroundColor,
        elevation: 5,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, color: Colors.white, size: 21),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void success(BuildContext context, String message) =>
      show(context, message, type: AppNoticeType.success);

  static void warning(BuildContext context, String message) =>
      show(context, message, type: AppNoticeType.warning);

  static void error(BuildContext context, String message) =>
      show(context, message, type: AppNoticeType.error);

  static void info(BuildContext context, String message) =>
      show(context, message);
}
