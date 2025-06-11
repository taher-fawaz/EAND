import 'package:flutter/material.dart';
import 'loading_widget.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? overlayColor;
  final double? loadingWidgetSize;
  final Color? loadingWidgetColor;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.overlayColor,
    this.loadingWidgetSize,
    this.loadingWidgetColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? Colors.black.withOpacity(0.5),
            child: AppLoadingWidget(
              size: loadingWidgetSize,
              color: loadingWidgetColor,
            ),
          ),
      ],
    );
  }
}