import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class FlowWidget extends StatefulWidget {
  const FlowWidget({super.key});

  @override
  State<FlowWidget> createState() => _FlowWidgetState();
}

class _FlowWidgetState extends State<FlowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
      reverseDuration: const Duration(seconds: 10),
    )..repeat(reverse: true); // Reverse to make it move up and down
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.height);
    return const Scaffold(
      backgroundColor: const Color.fromARGB(236, 31, 31, 31),
      body: BubbleFlow(),
    );
  }
}

class BubblePhysics {
  Offset position;
  Offset velocity;
  final double radius;
  final double mass;

  BubblePhysics({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.mass,
  });

  void update(Size bounds, List<BubblePhysics> others, double delta) {
    // Update position based on velocity
    position += velocity * delta;

    // Bounce off screen boundaries
    if (position.dx <= radius || position.dx >= bounds.width - radius) {
      velocity = Offset(-velocity.dx, velocity.dy);
      // Ensure bubble stays within bounds
      position = Offset(
        position.dx <= radius ? radius : bounds.width - radius,
        position.dy,
      );
    }

    if (position.dy <= radius || position.dy >= bounds.height - radius) {
      velocity = Offset(velocity.dx, -velocity.dy);
      // Ensure bubble stays within bounds
      position = Offset(
        position.dx,
        position.dy <= radius ? radius : bounds.height - radius,
      );
    }

    // Check collisions with other bubbles
    for (var other in others) {
      if (other == this) continue;

      final dx = other.position.dx - position.dx;
      final dy = other.position.dy - position.dy;
      final distance = math.sqrt(dx * dx + dy * dy);
      final minDist = radius + other.radius;

      if (distance < minDist) {
        // Collision detected - calculate new velocities
        final angle = math.atan2(dy, dx);
        final targetX = position.dx + math.cos(angle) * minDist;
        final targetY = position.dy + math.sin(angle) * minDist;

        // Move bubbles apart
        final ax = (targetX - other.position.dx) * 0.05;
        final ay = (targetY - other.position.dy) * 0.05;

        velocity += Offset(-ax, -ay);
        other.velocity += Offset(ax, ay);
      }
    }
  }
}

class CustomFlowDelegate extends FlowDelegate {
  final Animation<double> controller;
  final ValueNotifier<bool> repaint;
  final List<BubblePhysics> bubbles = [];
  final double bubbleRadius = 70.0;

  CustomFlowDelegate({
    required this.controller,
    required this.repaint,
  }) : super(repaint: controller) {
    // Initialize 4 bubbles with diagonal/straight movements
    final initialVelocities = [
      const Offset(60, 60), // Diagonal down-right
      const Offset(-60, 60), // Diagonal down-left
      const Offset(60, -60), // Diagonal up-right
      const Offset(0, 60), // Straight down
      const Offset(-60, -60), // Diagonal up-left
      const Offset(30, -50), // Up-left
      const Offset(-30, 50), // Down-left
      const Offset(50, 0), // Straight down
    ];

    for (int i = 0; i < 7; i++) {
      bubbles.add(BubblePhysics(
        position: Offset(100 + i * 80.0, 100 + i * 80.0),
        velocity: initialVelocities[i],
        radius: bubbleRadius,
        mass: 1.0,
      ));
    }
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Paint text

    // Update and paint bubbles
    const delta = 0.016; // Assuming 60fps
    for (int i = 1; i < context.childCount && i <= bubbles.length; i++) {
      final bubble = bubbles[i - 1];

      // Update bubble physics

      bubble.update(context.size, bubbles, delta);

      // Add subtle floating effect
      final floatOffset = math.sin(controller.value * math.pi * 2) * 2.0;

      // Create transform
      final transform = Matrix4.translationValues(
        bubble.position.dx - bubbleRadius,
        bubble.position.dy - bubbleRadius + floatOffset,
        0.0,
      );

      context.paintChild(i, transform: transform);
    }

    if (context.childCount > 0) {
      final firstChidWidthPos =
          (context.size.width - context.getChildSize(0)!.width) / 2;
      final firstChidHeightPos =
          (context.size.height - context.getChildSize(0)!.height) / 2;
      context.paintChild(0,
          transform: Matrix4.translationValues(
              firstChidWidthPos, firstChidHeightPos, 0));
    }
  }

  // @override
  // BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
  //   return i == 0
  //       ? BoxConstraints(maxWidth: constraints.maxWidth - 32, minWidth: 0)
  //       : constraints;
  // }

  @override
  bool shouldRepaint(CustomFlowDelegate oldDelegate) {
    return controller != oldDelegate.controller ||
        repaint != oldDelegate.repaint;
  }
}

class BubbleFlow extends StatefulWidget {
  const BubbleFlow({Key? key}) : super(key: key);

  @override
  State<BubbleFlow> createState() => _BubbleFlowState();
}

class _BubbleFlowState extends State<BubbleFlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ValueNotifier<bool> _repaint;
  double _centerX = 0.5;
  double _centerY = 0.5;
  double _radius = 0.5;

  double _angle = 0.0;
  List<Color> _colors = [Colors.blue, Colors.purple];
  List<double> _stops = [0.0, 1.0];
  Alignment _begin = Alignment.centerLeft;
  Alignment _end = Alignment.centerRight;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _repaint = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _repaint.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: CustomFlowDelegate(
        controller: _controller,
        repaint: _repaint,
      ),
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: _colors.map((e) => e.withOpacity(0.8)).toList(),
              stops: _stops,
              begin: _begin,
              end: _end,
              transform: GradientRotation(_angle * 3.14159 / 180),
              // tileMode: _tileMode,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Flow Widget Testing',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Bubble(),
        Bubble(),
        Bubble(),
        Bubble(),
        Bubble(),
        Bubble(),
        Bubble(),
      ],
    );
  }
}

class Bubble extends StatelessWidget {
  final double size;
  final bool showReflections;

  const Bubble({
    Key? key,
    this.size = 140,
    this.showReflections = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Main bubble with gradient and edge glow
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.15),
                  Colors.blue.withOpacity(0.2),
                ],
                stops: const [0.0, 0.8, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.blue.withOpacity(0.1),
                    Colors.white.withOpacity(0.2),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Iridescent edge effect
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),

          if (showReflections) ...[
            // Top-left light reflection
            Positioned(
              top: size * 0.2,
              left: size * 0.2,
              child: Container(
                width: size * 0.15,
                height: size * 0.15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.6),
                      Colors.white.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),

            // Small highlight reflection
            Positioned(
              top: size * 0.15,
              left: size * 0.35,
              child: Container(
                width: size * 0.08,
                height: size * 0.08,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.4),
                      Colors.white.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ],

          // Frosted glass effect
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 3,
                sigmaY: 3,
              ),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
