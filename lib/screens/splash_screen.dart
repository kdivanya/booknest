import 'auth_gate_screen.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _goToAuth(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthGateScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -60, right: -60,
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryLighter.withValues(alpha: 0.4),
                ),
              ),
            ),
            Positioned(
              bottom: 100, left: -80,
              child: Container(
                width: 220, height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryLighter.withValues(alpha: 0.25),
                ),
              ),
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 20, 0),
                    child: GestureDetector(
                      onTap: () => _goToAuth(context),
                      child: const Text('Skip',
                          style: TextStyle(fontSize: 14, color: AppColors.textMid)),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [Color(0xFF9B7FD4), Color(0xFF6B4BAF)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20, offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 54, height: 50,
                      child: CustomPaint(painter: _FeatherPainter()),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text('BookNest',
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold,
                        color: AppColors.textDark)),
                const SizedBox(height: 8),
                const Text('Your Cozy Digital Bookstore.',
                    style: TextStyle(fontSize: 15, color: AppColors.textMid)),
                const Spacer(flex: 2),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                  child: SizedBox(
                    width: double.infinity, height: 54,
                    child: ElevatedButton(
                      onPressed: () => _goToAuth(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Explore Now',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatherPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // SVG viewBox: 0 0 101 93
    canvas.scale(size.width / 101, size.height / 93);

    final path = Path()
      ..moveTo(54.9385, 39.1616)
      ..lineTo(4.53712, 85.5526)
      ..cubicTo(2.68282, 87.26, 2.68282, 90.021, 4.53712, 91.7102)
      ..cubicTo(6.39141, 93.3995, 9.38985, 93.4176, 11.2244, 91.7102)
      ..lineTo(25.9799, 78.1235)
      ..cubicTo(27.4397, 78.9591, 28.9981, 79.613, 30.6748, 80.0307)
      ..cubicTo(39.5123, 82.2468, 53.2617, 82.5555, 66.6758, 74.3635)
      ..cubicTo(69.0824, 72.8923, 67.8199, 69.7499, 64.9398, 69.7499)
      ..lineTo(61.7639, 69.7499)
      ..cubicTo(60.7578, 69.7499, 59.949, 69.0051, 59.949, 68.0788)
      ..cubicTo(59.949, 67.3341, 60.4816, 66.6983, 61.2313, 66.4803)
      ..lineTo(80.5041, 61.1583)
      ..cubicTo(81.1748, 60.9766, 81.7666, 60.5952, 82.1611, 60.0503)
      ..cubicTo(83.0291, 58.8878, 83.8576, 57.7071, 84.6467, 56.4901)
      ..cubicTo(85.8697, 54.6192, 84.3508, 52.3124, 81.9836, 52.3124)
      ..lineTo(74.3691, 52.3124)
      ..cubicTo(73.3631, 52.3124, 72.5543, 51.5677, 72.5543, 50.6413)
      ..cubicTo(72.5543, 49.8966, 73.0869, 49.2608, 73.8365, 49.0428)
      ..lineTo(89.7953, 44.629)
      ..cubicTo(90.7027, 44.3747, 91.4523, 43.7571, 91.8074, 42.9397)
      ..cubicTo(97.5479, 29.6073, 100.171, 15.6391, 100.98, 6.68426)
      ..cubicTo(101.138, 4.88602, 100.388, 3.1241, 99.0076, 1.85262)
      ..cubicTo(97.6268, 0.581136, 95.7133, -0.109098, 93.7604, 0.0362143)
      ..cubicTo(77.2295, 1.27137, 45.0752, 7.35633, 27.1043, 23.9038)
      ..cubicTo(11.3033, 38.4532, 11.185, 54.9098, 14.065, 64.7366)
      ..cubicTo(14.4793, 66.1716, 16.4322, 66.4803, 17.5764, 65.4268)
      ..lineTo(50.0266, 35.5651)
      ..cubicTo(51.2496, 34.4389, 53.2617, 34.4389, 54.4848, 35.5651)
      ..cubicTo(55.55, 36.546, 55.6881, 38.0354, 54.9188, 39.1616)
      ..lineTo(54.9385, 39.1616)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
