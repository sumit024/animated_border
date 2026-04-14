https://github.com/user-attachments/assets/d056baf6-4e0f-4125-af30-7c25842dd175

# border_animator

A Flutter widget that renders an animated border segment continuously traversing along container edges. Lightweight, customizable, and optimized for 120fps.

## Features

- Animated stroke that travels smoothly around a rounded rectangle border
- Solid color or gradient border support
- Clockwise and counter-clockwise direction
- Customizable border radius, width, speed, and segment length
- Optimized for 120fps — cached path metrics, zero unnecessary rebuilds, `RepaintBoundary`-isolated child

## Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  border_animator: ^0.0.1
```

Then import it:

```dart
import 'package:border_animator/border_animator.dart';
```

## Usage

### Basic solid color border

```dart
AnimatedBorder(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Hello'),
  ),
)
```

### Gradient border

```dart
AnimatedBorder(
  gradient: LinearGradient(
    colors: [Colors.purple, Colors.cyan, Colors.green],
  ),
  borderWidth: 4.0,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Gradient'),
  ),
)
```

### Counter-clockwise direction

```dart
AnimatedBorder(
  direction: BorderDirection.counterClockwise,
  color: Colors.orange,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Reversed'),
  ),
)
```

### Custom speed and segment length

```dart
AnimatedBorder(
  duration: Duration(milliseconds: 800),
  segmentLengthFactor: 0.1,
  color: Colors.red,
  borderRadius: 8,
  borderWidth: 2.0,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Fast & Short'),
  ),
)
```

## API Reference

### AnimatedBorder

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | The widget displayed inside the border |
| `borderWidth` | `double` | `3.0` | Stroke width of the border |
| `duration` | `Duration` | `2 seconds` | Duration of one full animation loop |
| `gradient` | `Gradient?` | `null` | Gradient for the border (takes precedence over `color`) |
| `color` | `Color?` | `Colors.blue` | Solid color for the border |
| `borderRadius` | `double` | `12.0` | Corner radius of the border |
| `segmentLengthFactor` | `double` | `0.3` | Visible portion of the border (0.0 - 1.0) |
| `direction` | `BorderDirection` | `clockwise` | Direction of the animation |

### BorderDirection

| Value | Description |
|---|---|
| `clockwise` | Border segment moves clockwise |
| `counterClockwise` | Border segment moves counter-clockwise |

## Performance

The widget is optimized for smooth 120fps rendering:

- **Cached path metrics** — `Path`, `PathMetric`, and `Paint` objects are cached and only recomputed when the widget size or configuration changes, not every frame
- **No setState** — the `AnimationController` is passed as a `repaint` listenable directly to the `CustomPainter`, bypassing the widget rebuild cycle entirely
- **RepaintBoundary** — the child subtree is isolated so it never repaints when the border animates
- **willChange hint** — tells the raster cache not to cache the border layer since it changes every frame
- **Per-frame work** is minimal: one multiply, one `extractPath`, one `drawPath`

## License

See the [LICENSE](LICENSE) file.
