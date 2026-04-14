import 'package:flutter/material.dart';

import 'animated_border_painter.dart';

/// A container widget that renders an animated border segment continuously
/// traversing along its edges.
///
/// The border animation loops infinitely, creating a visual effect of a
/// stroke traveling around the container's rounded rectangle border.
///
/// {@tool snippet}
/// ```dart
/// AnimatedBorderContainer(
///   borderWidth: 3.0,
///   borderRadius: 12.0,
///   gradient: LinearGradient(colors: [Colors.purple, Colors.cyan]),
///   duration: Duration(seconds: 2),
///   child: Padding(
///     padding: EdgeInsets.all(16),
///     child: Text('Hello'),
///   ),
/// )
/// ```
/// {@end-tool}
class AnimatedBorder extends StatefulWidget {
  /// Creates an [AnimatedBorder].
  ///
  /// The [child] is displayed inside the animated border.
  ///
  /// If [gradient] is provided, it is used for the border color. Otherwise,
  /// [color] is used (defaults to [Colors.blue]).
  const AnimatedBorder({
    super.key,
    required this.child,
    this.borderWidth = 3.0,
    this.duration = const Duration(seconds: 2),
    this.gradient,
    this.color,
    this.borderRadius = 12.0,
    this.segmentLengthFactor = 0.3,
    this.direction = BorderDirection.clockwise,
  });

  /// The widget to display inside the animated border.
  final Widget child;

  /// The width of the animated border stroke.
  ///
  /// Defaults to 3.0.
  final double borderWidth;

  /// The duration of one full animation cycle.
  ///
  /// Defaults to 2 seconds.
  final Duration duration;

  /// Optional gradient for the border stroke.
  ///
  /// When provided, this takes precedence over [color].
  final Gradient? gradient;

  /// Solid color for the border stroke.
  ///
  /// Used when [gradient] is null. Defaults to [Colors.blue].
  final Color? color;

  /// The corner radius of the border.
  ///
  /// Defaults to 12.0.
  final double borderRadius;

  /// The fraction of the total border perimeter that is visible (0.0 to 1.0).
  ///
  /// A value of 0.3 means 30% of the border is visible at any given time.
  /// Defaults to 0.3.
  final double segmentLengthFactor;

  /// The direction the border segment travels.
  ///
  /// Defaults to [BorderDirection.clockwise].
  final BorderDirection direction;

  @override
  State<AnimatedBorder> createState() => _AnimatedBorderState();
}

class _AnimatedBorderState extends State<AnimatedBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(AnimatedBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      willChange: true, // Tells the engine not to raster-cache this layer.
      painter: AnimatedBorderPainter(
        animation: _controller,
        borderWidth: widget.borderWidth,
        borderRadius: widget.borderRadius,
        segmentLengthFactor: widget.segmentLengthFactor,
        direction: widget.direction,
        gradient: widget.gradient,
        color: widget.color ?? Colors.blue,
      ),
      child: RepaintBoundary(
        child: Padding(
          padding: EdgeInsets.all(widget.borderWidth),
          child: widget.child,
        ),
      ),
    );
  }
}
