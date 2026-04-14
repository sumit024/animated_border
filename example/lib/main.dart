import 'package:flutter/material.dart';
import 'package:border_animator/border_animator.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Border Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Border Container')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Default solid blue border
            const Text(
              'Default (Solid Blue)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            AnimatedBorder(
              child: Container(
                height: 100,
                alignment: Alignment.center,
                child: const Text('Default Settings'),
              ),
            ),
            const SizedBox(height: 32),

            // 2. Gradient border
            const Text(
              'Gradient Border',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            AnimatedBorder(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.cyan, Colors.green],
              ),
              borderWidth: 4.0,
              child: Container(
                height: 100,
                alignment: Alignment.center,
                child: const Text('Gradient Animation'),
              ),
            ),
            const SizedBox(height: 32),

            // 3. Large radius + slow speed
            const Text(
              'Large Radius + Slow',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            AnimatedBorder(
              borderRadius: 30,
              duration: const Duration(seconds: 5),
              color: Colors.amber,
              segmentLengthFactor: 0.5,
              child: Container(
                height: 120,
                alignment: Alignment.center,
                child: const Text('Slow & Rounded'),
              ),
            ),
            const SizedBox(height: 32),

            // 4. Small segment + fast + red
            const Text(
              'Fast & Short Segment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            AnimatedBorder(
              segmentLengthFactor: 0.1,
              duration: const Duration(milliseconds: 800),
              color: Colors.red,
              borderWidth: 2.0,
              borderRadius: 8,
              child: Container(
                height: 80,
                alignment: Alignment.center,
                child: const Text('Fast & Short'),
              ),
            ),
            const SizedBox(height: 32),

            // 5. Counter-clockwise direction
            const Text(
              'Counter-Clockwise',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            AnimatedBorder(
              direction: BorderDirection.counterClockwise,
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.pink],
              ),
              borderWidth: 3.0,
              child: Container(
                height: 100,
                alignment: Alignment.center,
                child: const Text('Counter-Clockwise'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
