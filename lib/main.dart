import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.highContrastDark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double yAngle = 0.0;
  double xAngle = 0.0;
  double yPrevAngle = 0.0;
  double xPrevAngle = 0.0;
  double height = 200.0;
  double width = 350.0;
  final maxRotationAngle = 0.5;
  double radius = 20.0;

  Offset baseOffsetFromOffset(Offset mousePosition) {
    if (mousePosition.dx > width / 2) {
      return mousePosition.dy > height / 2
          ? const Offset(-1.0, 1.0)
          : const Offset(-1.0, -1.0);
    } else {
      return mousePosition.dy > height / 2
          ? const Offset(1.0, 1.0)
          : const Offset(1.0, -1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final originSize = Size(width / 2, height / 2);

    double calcGreaterThanOffset(
        double maxRotationAngle, double lOffset, double midLSize) {
      return ((maxRotationAngle * lOffset) / midLSize) - maxRotationAngle;
    }

    double calcLessThanOffset(
        double maxRotationAngle, double lOffset, double midLSize) {
      return maxRotationAngle - ((maxRotationAngle * lOffset) / midLSize);
    }

    double getXAngle(double difference) {
      final dx = originSize.width;
      if (difference > dx) {
        return calcGreaterThanOffset(maxRotationAngle, difference, dx);
      }
      return calcLessThanOffset(maxRotationAngle, difference, dx);
    }

    double getYAngle(double difference) {
      final dy = originSize.height;
      if (difference > dy) {
        return calcGreaterThanOffset(maxRotationAngle, difference, dy);
      }
      return calcLessThanOffset(maxRotationAngle, difference, dy);
    }

    Offset getAngles(Offset mousePosition) {
      final baseOffset = baseOffsetFromOffset(mousePosition);
      final angleX = getXAngle(mousePosition.dx) * baseOffset.dx;
      final angleY = getYAngle(mousePosition.dy) * baseOffset.dy;
      return Offset(angleX, angleY);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: MouseRegion(
          onHover: (PointerHoverEvent event) {
            final angles = getAngles(event.localPosition);
            setState(() {
              yAngle = angles.dy;
              xAngle = angles.dx;
            });
          },
          onEnter: (PointerEnterEvent event) {
            setState(() {
              yAngle = 0.0;
              xAngle = 0.0;
            });
          },
          onExit: (PointerExitEvent event) {
            setState(() {
              yAngle = 0.0;
              xAngle = 0.0;
            });
          },
          child: TweenAnimationBuilder(
            tween: Tween<Offset>(
              begin: Offset(xPrevAngle, yPrevAngle),
              end: Offset(xAngle, yAngle),
            ),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.elasticOut,
            builder: (context, Offset offset, child) {
              return GestureDetector(
                onPanUpdate: (details) {
                  // final dy = details.delta.dy;
                  // final dx = details.delta.dx;
                  // final ys = xAngle - dx / 100;
                  // final xs = yAngle + dy / 100;
                  // final x = ys > 0.5 ? 0.5 : (ys < -0.5 ? -0.5 : ys);
                  // final y = xs > 0.5 ? 0.5 : (xs < -0.5 ? -0.5 : xs);
                  // setState(() {
                  //   yAngle = y;
                  //   xAngle = x;
                  // });
                },
                onTap: () {
                  setState(() {
                    yAngle = pi;
                  });
                },
                child: Stack(
                  children: [
                    Transform(
                      origin: const Offset(150, 100),
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(offset.dx)
                        ..rotateX(offset.dy),
                      child: CustomPaint(
                        painter: GradienBorderPainter(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.white70,
                              Colors.white60,
                              Colors.white54,
                              Colors.white38,
                            ],
                          ),
                          strokeWidth: 2,
                          bRadius: radius, // Add border radius declaration
                        ),
                        child: Container(
                          height: height,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radius),
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(0, 33, 149, 243),
                                Color.fromARGB(157, 69, 42, 248),
                                Color.fromARGB(255, 68, 42, 248),
                                Color.fromARGB(255, 212, 0, 195),
                                Color.fromARGB(255, 255, 198, 0),
                              ],
                            ),
                          ),
                          child: const CardContent(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  const CardContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "Lorem Bank",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const Icon(
                Icons.card_travel,
                size: 14,
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "5782 8181 7777 0000",
                style: GoogleFonts.ibmPlexMono(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                "Johnny Doe",
                style: GoogleFonts.ibmPlexSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class GradienBorderPainter extends CustomPainter {
  GradienBorderPainter({
    required this.gradient,
    required this.strokeWidth,
    required this.bRadius,
  });

  final Gradient gradient;
  final double strokeWidth;
  final Paint p = Paint();
  final double bRadius;

  @override
  void paint(Canvas canvas, Size size) {
    //create the inner rectangle smaller than the size by stroke width
    final Rect innerRect = Rect.fromLTRB(strokeWidth, strokeWidth,
        size.width - strokeWidth, size.height - strokeWidth);
    //create the outer rectangle same size as the parent
    final Rect outerRect = Offset.zero & size;

    final RRect innerRoundedRect =
        RRect.fromRectAndRadius(innerRect, Radius.circular(bRadius));
    final RRect outerRoundedRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(bRadius));
    // create a shader from the gradient and the outerRect and use it
    p.shader = gradient.createShader(outerRect);
    final Path borderPath =
        _calculateBorderPath(outerRoundedRect, innerRoundedRect);
    canvas.drawPath(borderPath, p);
  }

  Path _calculateBorderPath(RRect outerRect, RRect innerRect) {
    final Path outerRectPath = Path()..addRRect(outerRect);
    final Path innerRectPath = Path()..addRRect(innerRect);
    return Path.combine(PathOperation.difference, outerRectPath, innerRectPath);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
