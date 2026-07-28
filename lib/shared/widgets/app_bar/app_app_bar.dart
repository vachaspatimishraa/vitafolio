import 'package:flutter/material.dart';

/// A reusable custom App Bar conforming to Material 3 designs.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final bool showBackButton;
  final List<Widget>? actions;
  final double elevation;

  const AppAppBar({
    super.key,
    this.title,
    this.titleText,
    this.showBackButton = true,
    this.actions,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: title ?? (titleText != null ? Text(titleText!) : null),
      automaticallyImplyLeading: showBackButton,
      actions: actions,
      elevation: elevation,
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      iconTheme: theme.iconTheme,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
