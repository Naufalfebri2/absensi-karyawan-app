import 'package:flutter/material.dart';

Future<void> showLeaveDecisionDialog({
  required BuildContext context,
  required String title,
  required String confirmLabel,
  required Color confirmColor,
  required void Function(String note) onConfirm,
}) async {
  final controller = TextEditingController();

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Catatan (opsional)',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
          onPressed: () {
            Navigator.pop(context);
            onConfirm(controller.text.trim());
          },
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}
