import 'package:flutter/material.dart';

/// Reusable AppLogo widget that loads the official Vitafolio logo.
class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? semanticLabel;

  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.semanticLabel = 'Vitafolio Logo',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Support separate light and dark logo assets in the future.
    // Currently, both resolve to the main high-quality logo asset.
    final String assetPath = isDark
        ? 'assets/icons/logo.png'
        : 'assets/icons/logo.png';

    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticLabel,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,
    );
  }
}
