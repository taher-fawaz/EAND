import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDialog extends StatelessWidget {
  final String title;
  const AppDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(title),
      actions: [
        ElevatedButton(
          onPressed: () {
            context.pop(false);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          child: Text('cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () {
            context.pop(true);
          },
          child: Text('ok', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
