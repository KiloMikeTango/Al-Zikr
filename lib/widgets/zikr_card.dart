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
    // Using LayoutBuilder allows the card to know how much space it actually has
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = constraints.maxWidth;
        // Dynamic scaling factor based on width
        final double scale = cardWidth > 600 ? 1.2 : 1.0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              constraints: const BoxConstraints(minHeight: 100, maxHeight: 120),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 1. Title and Branding Section
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(left: cardWidth * 0.06),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.philosopher(
                              fontSize: 18 * scale,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'AL Zikr',
                            style: GoogleFonts.lobster(
                              fontSize: 14 * scale,
                              color: Colors.white24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Subtle Vertical Divider
                  Container(
                    width: 1,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.white10,
                  ),

                  // 3. Action / Icon Section
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: isAction
                          ? _buildPlayButton(scale)
                          : _buildIcon(scale),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayButton(double scale) {
    return Container(
      padding: EdgeInsets.all(8 * scale),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF00C853), Color(0xFF64DD17)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C853).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.play_arrow_rounded,
        color: Colors.black,
        size: 28 * scale,
      ),
    );
  }

  Widget _buildIcon(double scale) {
    return Icon(icon, color: Colors.white38, size: 24 * scale);
  }
}
