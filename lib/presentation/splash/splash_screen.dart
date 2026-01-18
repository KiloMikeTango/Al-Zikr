// lib/presentation/splash/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../mode_selection/mode_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    // Reduced duration from 10s to 4s for better UX
    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ModeSelectionScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // Minimalist Branding
              Text(
                "Al Zikr",
                style: GoogleFonts.lobster(
                  fontSize: 72,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),

              const Spacer(flex: 2),

              // Ayah Section
              Text(
                'Surah Ar-Ra’d',
                style: GoogleFonts.philosopher(
                  fontSize: 17,
                  letterSpacing: 1,
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                ' ۗالَّذِينَ آمَنُوا وَتَطْمَئِنُّ قُلُوبُهُم بِذِكْرِ اللَّهِ\nأَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
                textAlign: TextAlign.center,
                style: GoogleFonts.amiri(
                  // Better Arabic font for Quranic text
                  fontSize: 22,
                  height: 2,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),

              const SizedBox(height: 32),

              // Decorative Dot instead of a harsh Divider
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(height: 32),

              // Translation
              Text(
                '“ Those who believe find peace in\nremembering Allah. Truly, hearts find peace\nin the remembrance of Allah.”',
                textAlign: TextAlign.center,
                style: GoogleFonts.philosopher(
                  fontSize: 18,
                  height: 1.5,
                  color: Colors.white60,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const Spacer(flex: 3),

              // Subtle Loading indicator
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white10),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
