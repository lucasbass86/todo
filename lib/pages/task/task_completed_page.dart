import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:todo/themes/themes.dart';

class TaskCompletedPage extends StatelessWidget {
  static final String routeName = 'TaskCompletedPage';
  final VoidCallback? onTap;

  const TaskCompletedPage({super.key, this.onTap});

  static const Color primaryBlue = Color(0xFF3165F5);
  static const Color darkBlue = Color(0xFF102B59);
  static const Color green = Color(0xFF35C393);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF2F7FD),
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.border, width: 2),
              boxShadow: [
                BoxShadow(color: AppTheme.primary, blurRadius: 20, offset: const Offset(0, 6)),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final height = constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : MediaQuery.sizeOf(context).height;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: height - 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Icono de tarea completada y confeti
                        SizedBox(
                          width: 280,
                          height: 190,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const _Confetti(),
                              Container(
                                width: 112,
                                height: 112,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  size: 72,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          '¡Tarea completada!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // color: darkBlue,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 14),

                        const Text(
                          'Buen trabajo 🎉',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // color: Color(0xFF29456F),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 52),

                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          // child: ElevatedButton(onPressed: onTap, child: const Text('Volver')),
                          child: ElevatedButton(
                            onPressed: () => onTap ?? Navigator.pop(context),
                            child: const Text('Volver'),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Confetti extends StatelessWidget {
  const _Confetti();

  static const List<Color> colors = [
    Color(0xFF3478F6),
    Color(0xFFFFCE42),
    Color(0xFFFF625C),
    Color(0xFF28C997),
    Color(0xFFB14EE8),
    Color(0xFFFF9651),
    Color(0xFF35BDE0),
    Color(0xFFE2B56C),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(280, 190), painter: _ConfettiPainter());
  }
}

class _ConfettiPainter extends CustomPainter {
  static const List<Color> colors = _Confetti.colors;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(13);

    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..strokeCap = StrokeCap.round;

    for (int i = 0; i < 24; i++) {
      final angle = (2 * math.pi * i / 24) + (random.nextDouble() - 0.5) * 0.22;

      final radius = 78 + random.nextDouble() * 18;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;

      final length = 4.0 + random.nextDouble() * 3;
      final isVertical = i % 3 == 0;

      paint
        ..color = colors[i % colors.length]
        ..strokeWidth = 4.0;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate((random.nextDouble() - 0.5) * 1.2 + (isVertical ? math.pi / 2 : 0.6));

      canvas.drawLine(Offset(-length / 2, 0), Offset(length / 2, 0), paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
