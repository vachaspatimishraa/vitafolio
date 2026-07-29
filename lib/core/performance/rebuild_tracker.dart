import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// A helper widget to track and log rebuilds of its child widget.
class RebuildTracker extends StatefulWidget {
  final String name;
  final Widget child;
  final int warningThreshold;

  const RebuildTracker({
    super.key,
    required this.name,
    required this.child,
    this.warningThreshold = 5,
  });

  @override
  State<RebuildTracker> createState() => _RebuildTrackerState();
}

class _RebuildTrackerState extends State<RebuildTracker> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    _rebuildCount++;
    if (_rebuildCount > widget.warningThreshold) {
      developer.log(
        '⚠️ HIGH REBUILD COUNT: Widget [${widget.name}] has rebuilt $_rebuildCount times.',
        name: 'performance.rebuild',
        level: 900, // Warning
      );
    } else {
      developer.log(
        '🔄 Widget [${widget.name}] rebuild #$_rebuildCount',
        name: 'performance.rebuild',
        level: 500, // Info
      );
    }
    return widget.child;
  }
}
