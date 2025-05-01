import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

class SnackBarHelper {
  static void showErrorSnackBar(String message, {String title = "Error"}) {
    _showAppleStyleSnackBar(
      title: title,
      message: message,
      gradient: const LinearGradient(
        colors: [Color(0xFFFF5E62), Color(0xFFFF2C55)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      iconData: Icons.error_outline_rounded,
    );
  }

  static void showSuccessSnackBar(String message, {String title = "Success"}) {
    _showAppleStyleSnackBar(
      title: title,
      message: message,
      gradient: const LinearGradient(
        colors: [Color(0xFF34C759), Color(0xFF30D158)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      iconData: Icons.check_circle_outline_rounded,
    );
  }

  static void showInfoSnackBar(String message, {String title = "Info"}) {
    _showAppleStyleSnackBar(
      title: title,
      message: message,
      gradient: const LinearGradient(
        colors: [Color(0xFF007AFF), Color(0xFF5AC8FA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      iconData: Icons.info_outline_rounded,
    );
  }

  static void _showAppleStyleSnackBar({
    required String title,
    required String message,
    required LinearGradient gradient,
    required IconData iconData,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      '',
      '',
      backgroundColor: Colors.transparent,
      duration: duration,
      snackPosition: SnackPosition.TOP,
      dismissDirection: DismissDirection.horizontal,
      isDismissible: true,
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
      snackStyle: SnackStyle.FLOATING,
      barBlur: 0,
      overlayBlur: 0,
      titleText: Container(),
      messageText: Container(),
      snackbarStatus: (status) {},
      userInputForm: Form(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      iconData,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}