import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'login.dart';
import 'register.dart';

// STATELESS WIDGET
class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryLighter.withValues(alpha: 0.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Logo ──
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.bgWhite,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.primaryLighter
                                .withValues(alpha: 0.4),
                            blurRadius: 12),
                      ],
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 28,
                        height: 27,
                        child: CustomPaint(painter: _LogoPainter()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text('Hi! Welcome to',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                  const Text('BookNest',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  const SizedBox(height: 12),
                  const Text(
                    "Step into your sanctuary of stories.\nLet's get you settled in.",
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMid,
                        height: 1.5),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Register',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Login',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9D81B1)
      ..style = PaintingStyle.fill;

    final sx = size.width / 40;
    final sy = size.height / 38;
    canvas.scale(sx, sy);

    final path = Path()
      ..moveTo(21.7578, 16.0016)
      ..lineTo(1.79688, 34.9571)
      ..cubicTo(1.0625, 35.6547, 1.0625, 36.7829, 1.79688, 37.4731)
      ..cubicTo(2.53125, 38.1633, 3.71875, 38.1708, 4.44531, 37.4731)
      ..lineTo(10.2891, 31.9215)
      ..cubicTo(10.8672, 32.2629, 11.4844, 32.5301, 12.1484, 32.7008)
      ..cubicTo(15.6484, 33.6063, 21.0938, 33.7325, 26.4062, 30.3852)
      ..cubicTo(27.3594, 29.784, 26.8594, 28.5, 25.7188, 28.5)
      ..lineTo(24.4609, 28.5)
      ..cubicTo(24.0625, 28.5, 23.7422, 28.1958, 23.7422, 27.8172)
      ..cubicTo(23.7422, 27.5129, 23.9531, 27.2532, 24.25, 27.1641)
      ..lineTo(31.8828, 24.9895)
      ..cubicTo(32.1484, 24.9153, 32.3828, 24.7594, 32.5391, 24.5368)
      ..cubicTo(32.8828, 24.0618, 33.2109, 23.5793, 33.5234, 23.0821)
      ..cubicTo(34.0078, 22.3176, 33.4062, 21.375, 32.4688, 21.375)
      ..lineTo(29.4531, 21.375)
      ..cubicTo(29.0547, 21.375, 28.7344, 21.0708, 28.7344, 20.6922)
      ..cubicTo(28.7344, 20.3879, 28.9453, 20.1282, 29.2422, 20.0391)
      ..lineTo(35.5625, 18.2356)
      ..cubicTo(35.9219, 18.1317, 36.2188, 17.8793, 36.3594, 17.5454)
      ..cubicTo(38.6328, 12.0977, 39.6719, 6.39029, 39.9922, 2.7313)
      ..cubicTo(40.0547, 1.99654, 39.7578, 1.27661, 39.2109, 0.757082)
      ..cubicTo(38.6641, 0.237551, 37.9062, -0.0444806, 37.1328, 0.0148944)
      ..cubicTo(30.5859, 0.519582, 17.8516, 3.00591, 10.7344, 9.76724)
      ..cubicTo(4.47656, 15.7122, 4.42969, 22.4364, 5.57031, 26.4516)
      ..cubicTo(5.73438, 27.0379, 6.50781, 27.1641, 6.96094, 26.7336)
      ..lineTo(19.8125, 14.5321)
      ..cubicTo(20.2969, 14.0719, 21.0938, 14.0719, 21.5781, 14.5321)
      ..cubicTo(22.0, 14.9329, 22.0547, 15.5415, 21.75, 16.0016)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}