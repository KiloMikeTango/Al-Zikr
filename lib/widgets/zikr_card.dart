// lib/widgets/zikr_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ZikrCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isAction;

  const ZikrCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 100, // Reduced height for a more modern, compact look
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            // Left Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.philosopher(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AL Zikr',
                      style: GoogleFonts.lobster(
                        fontSize: 16,
                        color: Colors.white24, // Very subtle secondary branding
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Modern Divider (Thin and short)
            Container(width: 1, height: 40, color: Colors.white10),

            // Action Area
            Container(
              width: 80,
              alignment: Alignment.center,
              child: isAction ? _buildPlayButton() : _buildIcon(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.greenAccent.shade700, Colors.greenAccent.shade400],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.play_arrow_rounded,
        color: Colors.black,
        size: 28,
      ),
    );
  }

  Widget _buildIcon() {
    return Icon(icon, color: Colors.white38, size: 24);
  }
}
