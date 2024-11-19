import 'dart:math';
import 'package:flutter/material.dart';

class LoadingIndicatorsShowcase extends StatefulWidget {
  const LoadingIndicatorsShowcase({Key? key}) : super(key: key);

  @override
  _LoadingIndicatorsShowcaseState createState() =>
      _LoadingIndicatorsShowcaseState();
}

class _LoadingIndicatorsShowcaseState extends State<LoadingIndicatorsShowcase>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loading Indicaors"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Wrap(
              runSpacing: 30,
              spacing: 30,
              alignment: WrapAlignment.spaceBetween,
              children: [
                _buildIndicator(
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Colors.purple, Colors.pink, Colors.orange],
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  "Instagram",
                ),
                _buildIndicator(
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(0.3),
                        ),
                        child: Transform.scale(
                          scale: 0.8 + (_pulseController.value * 0.2),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  "Pulse",
                ),
                _buildIndicator(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          double bounce = sin(
                              (_pulseController.value * 3.14) + (index * 1.0));
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            child: Transform.translate(
                              offset: Offset(0, -bounce * 8),
                              child: Container(
                                height: 8,
                                width: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  "Bounce",
                ),
                _buildIndicator(
                  RotationTransition(
                    turns: _pulseController,
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CustomPaint(
                        painter: SpinnerPainter(),
                      ),
                    ),
                  ),
                  "Spinner",
                ),
                _buildIndicator(
                  SizedBox(
                    width: 50,
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LinearProgressIndicator(
                              value: _pulseController.value,
                              minHeight: 6,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.green),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(_pulseController.value * 100).toInt()}%',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  "Progress",
                ),
                _buildIndicator(
                  const CircularProgressIndicator(),
                  "Circular",
                ),
                _buildIndicator(
                  const SizedBox(
                    width: 50,
                    child: LinearProgressIndicator(),
                  ),
                  "Linear",
                ),
                _buildIndicator(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(
                                index == 0
                                    ? _pulseController.value
                                    : index == 1
                                        ? _pulseController.value * 0.7
                                        : _pulseController.value * 0.4,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  "Typing",
                ),

                // New indicators start here
                _buildIndicator(
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Stack(
                      alignment: Alignment.center,
                      children: List.generate(8, (index) {
                        return Transform.rotate(
                          angle: index * pi / 4,
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: const Offset(0, -8),
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue.withOpacity(
                                      (1 - _pulseController.value + index / 8) %
                                          1,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  "Fade Dots",
                ),

                _buildIndicator(
                  RotationTransition(
                    turns: _rotationController,
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: Stack(
                        children: List.generate(12, (index) {
                          return Transform.translate(
                            offset: Offset(
                              12 * cos(index * pi / 6),
                              12 * sin(index * pi / 6),
                            ),
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.purple
                                    .withOpacity(1 - (index * 0.08)),
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  "Spin Dots",
                ),

                _buildIndicator(
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.orange
                                .withOpacity(_pulseController.value),
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  "Pulse Ring",
                ),

                _buildIndicator(
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1 - _pulseController.value * 0.5,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green.withOpacity(0.6),
                                ),
                              ),
                            );
                          },
                        ),
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseController.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green.withOpacity(0.3),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  "Double Bounce",
                ),

                _buildIndicator(
                  RotationTransition(
                    turns: _rotationController,
                    child: CustomPaint(
                      painter: CircularDashPainter(),
                      size: const Size(30, 30),
                    ),
                  ),
                  "Dashed Spin",
                ),
                _buildIndicator(
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Stack(
                      alignment: Alignment.center,
                      children: List.generate(3, (index) {
                        return AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            double scale =
                                _pulseController.value - (index * 0.3);
                            scale = scale < 0 ? 0 : scale;
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue.withOpacity(1 - scale),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                  "Ripple",
                ),
                _buildIndicator(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.primaries[(index +
                                      (_pulseController.value * 10).toInt()) %
                                  Colors.primaries.length],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  "Color Dots",
                ),

                _buildIndicator(
                  RotationTransition(
                    turns: _rotationController,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(4, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 8,
                          height: 8,
                          color: Colors.orange,
                        );
                      }),
                    ),
                  ),
                  "Rotating Squares",
                ),

                _buildIndicator(
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      double size = 30 * (1 - _pulseController.value * 0.5);
                      return Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                Colors.red.withOpacity(_pulseController.value),
                            width: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  "Shrinking Ring",
                ),

                _buildIndicator(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          double height = 10 + (_pulseController.value * 20);
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 4,
                            height: height,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  "Expanding Bars",
                ),

                _buildIndicator(
                  SizedBox(
                    height: 20,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            double waveHeight = 10 +
                                sin((_pulseController.value * 2 * pi) + index) *
                                    10;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              width: 4,
                              height: waveHeight,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                  "Waves",
                ),

                _buildIndicator(
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Stack(
                      children: List.generate(4, (index) {
                        return AnimatedBuilder(
                          animation: _rotationController,
                          builder: (context, child) {
                            double angle = _rotationController.value * 2 * pi +
                                (index * pi / 2);
                            return Transform.translate(
                              offset: Offset(15 * cos(angle), 15 * sin(angle)),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                  "Dot Orbit",
                ),

                _buildIndicator(
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: sin(_pulseController.value * pi) * pi / 4,
                        child: Container(
                          width: 4,
                          height: 30,
                          color: Colors.deepPurple,
                        ),
                      );
                    },
                  ),
                  "Pendulum",
                ),
                _buildIndicator(
                  RotationTransition(
                    turns: _rotationController,
                    child: CustomPaint(
                      painter: HexagonPainter(),
                      size: const Size(40, 40),
                    ),
                  ),
                  "Hexagon Spin",
                ),

                _buildIndicator(
                  RotationTransition(
                    turns: _rotationController,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            Colors.blue,
                            Colors.green,
                            Colors.yellow,
                            Colors.blue
                          ],
                          stops: [0.2, 0.5, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),
                  "Gradient Ring",
                ),
                _buildIndicator(
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      double size = 20 + _pulseController.value * 20;
                      return CustomPaint(
                        size: Size(size, size),
                        painter: ZigzagPainter(),
                      );
                    },
                  ),
                  "Zigzag",
                ),
                _buildIndicator(
                  SizedBox(
                    width: 50,
                    height: 20,
                    child: AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        double angle = _rotationController.value * 2 * pi;
                        return Transform.translate(
                          offset: Offset(20 * cos(angle), 0),
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  "Rolling Circle",
                ),

                _buildIndicator(
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      double value = _pulseController.value;
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: value < 0.5
                              ? BoxShape.rectangle
                              : BoxShape.circle,
                          borderRadius:
                              value < 0.5 ? BorderRadius.circular(8) : null,
                          color: Colors.pink,
                        ),
                      );
                    },
                  ),
                  "Morphing Shapes",
                ),
                _buildIndicator(
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      double translateY = 15 * (1 - _pulseController.value);
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: translateY,
                            child: Container(
                              width: 4,
                              height: 20,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  "Climbing Bar",
                ),

                _buildIndicator(
                  Stack(
                    alignment: Alignment.center,
                    children: List.generate(5, (index) {
                      return AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          double opacity =
                              (sin(_pulseController.value * 2 * pi + index) +
                                      1) /
                                  2;
                          return Transform.rotate(
                            angle: pi / 5 * index,
                            child: Opacity(
                              opacity: opacity,
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  "Star Blink",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(Widget indicator, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: Center(child: indicator),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

// Custom Spinner Painter
class SpinnerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const startAngle = -0.5 * 3.14;
    const sweepAngle = 1.5 * 3.14;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// New CircularDashPainter
class CircularDashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = min(centerX, centerY);

    for (var i = 0; i < 8; i++) {
      final double startAngle = i * pi / 4;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        startAngle,
        pi / 8,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final double radius = size.width / 2;
    for (int i = 0; i < 6; i++) {
      double angle = (pi / 3) * i;
      double x = size.width / 2 + radius * cos(angle);
      double y = size.height / 2 + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ZigzagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    double step = size.width / 6;
    for (int i = 0; i < 7; i++) {
      double x = step * i;
      double y = (i % 2 == 0) ? 0 : size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
