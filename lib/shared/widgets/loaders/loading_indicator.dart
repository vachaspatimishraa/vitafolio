import 'package:flutter/material.dart';

enum LoaderStyle { circular, linear }

/// Reusable progress indicator supporting Circular and Linear progress styles.
class LoadingIndicator extends StatelessWidget {
  final LoaderStyle style;
  final double? value;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.style = LoaderStyle.circular,
    this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case LoaderStyle.linear:
        return LinearProgressIndicator(value: value, color: color);
      case LoaderStyle.circular:
        return Center(
          child: CircularProgressIndicator(value: value, color: color),
        );
    }
  }
}
