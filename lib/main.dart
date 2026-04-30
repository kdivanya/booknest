import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/colors.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const BookNestApp());
}

class BookNestApp extends StatelessWidget {
  const BookNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.bg,
        textTheme: GoogleFonts.dmSerifDisplayTextTheme().copyWith(
          bodyLarge: GoogleFonts.inter(fontSize: 14, color: AppColors.textDark),
          bodyMedium: GoogleFonts.inter(fontSize: 13, color: AppColors.textMid),
          bodySmall: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
