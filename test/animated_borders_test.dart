import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:animated_borders/animated_borders.dart';

void main() {
  testWidgets('renders with default parameters', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: AnimatedBorder(
              child: SizedBox(width: 200, height: 100),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(AnimatedBorder), findsOneWidget);
  });

  testWidgets('renders child widget', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: AnimatedBorder(
              child: Text('Hello'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('accepts custom parameters without errors', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AnimatedBorder(
              borderWidth: 5.0,
              borderRadius: 20.0,
              duration: const Duration(seconds: 4),
              color: Colors.red,
              segmentLengthFactor: 0.5,
              child: const SizedBox(width: 200, height: 100),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(AnimatedBorder), findsOneWidget);
  });

  testWidgets('accepts gradient parameter', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AnimatedBorder(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.cyan],
              ),
              child: const SizedBox(width: 200, height: 100),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(AnimatedBorder), findsOneWidget);
  });

  testWidgets('animation progresses without errors', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: AnimatedBorder(
              duration: Duration(seconds: 2),
              child: SizedBox(width: 200, height: 100),
            ),
          ),
        ),
      ),
    );

    // Advance animation to midpoint.
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(AnimatedBorder), findsOneWidget);

    // Advance past one full cycle.
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(AnimatedBorder), findsOneWidget);
  });
}
