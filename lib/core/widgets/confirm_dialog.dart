import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

// shows a confirmation dialog, returns true only when the user confirms
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(AppStrings.confirm),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
