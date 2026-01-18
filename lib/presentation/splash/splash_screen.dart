// lib/presentation/splash/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../mode_selection/mode_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(minutes: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ModeSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background from image
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main Logo Text with Glow
              Text(
                "Al Zikr",
                style: GoogleFonts.lobster(
                  fontSize: 80,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 20.0,
                      color: Colors.white.withOpacity(0.7),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
              // Text(
              //   'Al Zikr',
              //   style: TextStyle(
              //     fontSize: 80,
              //     fontFamily:
              //         'Lobster', // Use a stylish serif font if available
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //     shadows: [
              //       Shadow(
              //         blurRadius: 20.0,
              //         color: Colors.white.withOpacity(0.7),
              //         offset: const Offset(0, 0),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 80),

              // Surah Name
              Text(
                'Surah Ar Ra’d',
                style: GoogleFonts.philosopher(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Arabic Ayah
              Text(
                'الَّذِينَ آمَنُوا وَتَطْمَئِنُّ قُلُوبُهُم بِذِكْرِ اللَّهِ\nأَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansArabic(
                  fontSize: 24,
                  height: 1.5,
                  color: Colors.white,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: Colors.white24, thickness: 1),
              ),

              // English Translation
               Text(
                '“ Those who believe find peace in remembering Allah. Truly, hearts find peace in the remembrance of Allah. ”',
                textAlign: TextAlign.center,
                style: GoogleFonts.ruluko(
                  fontSize: 18,
                  height: 1.4,
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
