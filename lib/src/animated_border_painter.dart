import 'dart:ui';

import 'package:flutter/widgets.dart';

/// The direction in which the animated border segment travels.
enum BorderDirection {
  /// The border segment moves clockwise around the container.
  clockwise,

  /// The border segment moves counter-clockwise around the container.
  counterClockwise,
}

/// A [CustomPainter] that renders an animated border segment traveling
/// along the edges of a rounded rectangle.
///
/// Optimized for 120fps: the path, path metrics, and paint object are cached
/// and only recomputed when the size or configuration changes — not every frame.
/// The only per-frame work is [PathMetric.extractPath] and [Canvas.drawPath].
class AnimatedBorderPainter extends CustomPainter {
  /// Creates an [AnimatedBorderPainter].
  AnimatedBorderPainter({
    required this.animation,
    required this.borderWidth,
    required this.borderRadius,
    required this.segmentLengthFactor,
    required this.direction,
    this.gradient,
    required this.color,
  }) : super(repaint: animation);

  /// The animation driving the border segment position (0.0 to 1.0).
  final Animation<double> animation;

  /// The width of the border stroke.
  final double borderWidth;

  /// The corner radius of the border.
  final double borderRadius;

  /// The fraction of the total border length to show (0.0 to 1.0).
  final double segmentLengthFactor;

  /// The direction the border segment travels.
  final BorderDirection direction;

  /// Optional gradient to apply to the border stroke.
  final Gradient? gradient;

  /// Solid color for the border stroke (used when [gradient] is null).
  final Color color;

  // Cached geometry — only recomputed when size changes.
  Size? _cachedSize;
  PathMetric? _cachedPathMetric;
  double _cachedTotalLength = 0;
  double _cachedSegmentLength = 0;

  // Cached paint — only recomputed when size or paint config changes.
  Paint? _cachedPaint;

  void _rebuildCache(Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(borderWidth / 2),
      Radius.circular(borderRadius),
    );
    final path = Path()..addRRect(rrect);
    final metric = path.computeMetrics().firstOrNull;

    _cachedSize = size;
    _cachedPathMetric = metric;
    _cachedTotalLength = metric?.length ?? 0;
    _cachedSegmentLength =
        _cachedTotalLength * segmentLengthFactor.clamp(0.01, 1.0);

    // Rebuild paint (shader depends on rect size).
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    if (gradient != null) {
      paint.shader = gradient!.createShader(rect);
    } else {
      paint.color = color;
    }

    _cachedPaint = paint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= borderWidth || size.height <= borderWidth) {
      return;
    }

    // Rebuild cached geometry + paint only when size changes.
    if (_cachedSize != size) {
      _rebuildCache(size);
    }

    final pathMetric = _cachedPathMetric;
    if (pathMetric == null || _cachedTotalLength == 0) return;

    final totalLength = _cachedTotalLength;
    final segmentLength = _cachedSegmentLength;
    final progress = direction == BorderDirection.clockwise
        ? animation.value
        : 1.0 - animation.value;
    final start = progress * totalLength;
    final end = start + segmentLength;

    final paint = _cachedPaint!;

    if (end <= totalLength) {
      canvas.drawPath(pathMetric.extractPath(start, end), paint);
    } else {
      // Wrap-around: draw two segments for seamless looping.
      canvas.drawPath(pathMetric.extractPath(start, totalLength), paint);
      canvas.drawPath(pathMetric.extractPath(0, end % totalLength), paint);
    }
  }

  @override
  bool shouldRepaint(AnimatedBorderPainter oldDelegate) {
    // Config changed — invalidate the cache so paint() rebuilds it.
    final changed = borderWidth != oldDelegate.borderWidth ||
        borderRadius != oldDelegate.borderRadius ||
        segmentLengthFactor != oldDelegate.segmentLengthFactor ||
        direction != oldDelegate.direction ||
        gradient != oldDelegate.gradient ||
        color != oldDelegate.color;

    if (changed) {
      _cachedSize = null; // Force cache rebuild on next paint().
    }

    return changed;
  }
}
