import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/cart_model.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  bool _isValidEmail(String email) =>
      RegExp(r'^[\w\.\-]+@[\w\-]+\.\w{2,}$').hasMatch(email.trim());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter email and password.');
      return;
    }
    if (!_isValidEmail(email)) {
      _showError('Please enter a valid email address.');
      return;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters.');
      return;
    }

    AppStore().currentEmail = email;
    AppStore().currentUser = email.split('@').first;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Forgot Password',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your email and we'll send you a link to reset your password.",
              style:
                  TextStyle(fontSize: 13, color: AppColors.textMid, height: 1.5),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: AppColors.textDark),
              decoration: InputDecoration(
                hintText: 'Email address',
                hintStyle: const TextStyle(color: AppColors.textHint),
                prefixIcon:
                    const Icon(Icons.email_outlined, color: AppColors.textLight),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                filled: true,
                fillColor: AppColors.bg,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textLight)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (ctrl.text.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Reset link sent to ${ctrl.text.trim()}'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Send Link'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: back + logo ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_rounded,
                        size: 24, color: AppColors.textDark),
                  ),
                  // FIX: wrap in SizedBox so CustomPaint gets explicit size
                  SizedBox(
                    width: 36,
                    height: 34,
                    child: CustomPaint(painter: _LogoPainter()),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text('Welcome Back',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              const SizedBox(height: 8),
              const Text('Please login to continue your book journey.',
                  style: TextStyle(
                      fontSize: 14, color: AppColors.textMid, height: 1.5)),
              const SizedBox(height: 32),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.bgWhite,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryLighter.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: AppColors.textDark),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle:
                            const TextStyle(color: AppColors.textHint),
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: AppColors.textLight),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.bg,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      style: const TextStyle(color: AppColors.textDark),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle:
                            const TextStyle(color: AppColors.textHint),
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.textLight),
                        suffixIcon: GestureDetector(
                          onTap: () =>
                              setState(() => _obscureText = !_obscureText),
                          child: Icon(
                            _obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textLight,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.bg,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: const Text('Forgot Password?',
                            style: TextStyle(color: AppColors.primary)),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Login',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
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
