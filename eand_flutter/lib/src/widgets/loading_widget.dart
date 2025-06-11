import 'package:flutter/material.dart';

import 'package:eand_flutter/src/core/themes/app_color.dart';

class AppLoadingWidget extends StatelessWidget {
  final double? size;
  final Color? color;

  const AppLoadingWidget({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size ?? 40,
        width: size ?? 40,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: color ?? AppColor.purple,
        ),
      ),
    );
  }
}
