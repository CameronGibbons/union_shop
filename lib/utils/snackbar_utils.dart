import 'package:flutter/material.dart';

class SnackbarUtils {
  /// Show a success snackbar when item is added to cart
  static void showAddedToCart(
    BuildContext context,
    String productName, {
    VoidCallback? onViewCart,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $productName to cart'),
        action: onViewCart != null
            ? SnackBarAction(
                label: 'VIEW CART',
                onPressed: onViewCart,
              )
            : null,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show a generic success snackbar
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }

  /// Show a generic error snackbar
  static void showError(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  /// Show a generic info snackbar
  static void showInfo(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }
}
