import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  const AppErrorWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.error, size: 40), Text(message)],
      ),
    );
  }
}
