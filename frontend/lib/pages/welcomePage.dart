import 'package:flutter/material.dart';
import 'package:frontend/pages/optionPage.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const _green = Color(0xFF286749);
  static const _greenLight = Color(0xFFE4F1EB);
  static const _greenDark = Color(0xFF1F513A);
  static const _grey = Color(0xFF6D7873);
  static const _border = Color(0xFFDEE3E0);
  static const _text = Color(0xFF171C1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _greenLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top green section with illustration + title ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SvgPicture.asset(
                        'lib/images/undraw_festivities.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'UniVents',
                      style: GoogleFonts.outfit(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: _greenDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Discover events on campus',
                      style: TextStyle(
                        fontSize: 14,
                        color: _green.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── White card at bottom ──
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // drag handle
                  Container(
                    width: 36, height: 4,
                    decoration: BoxDecoration(
                      color: _border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'CONTINUE AS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Student ──
                  _RoleCard(
                    icon: Icons.school_rounded,
                    title: 'Student',
                    subtitle: 'Browse and RSVP to events',
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OptionPage(
                          isOrganiser: false,
                          onLogin: (UserService service) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomePage()),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Organiser ──
                  _RoleCard(
                    icon: Icons.campaign_rounded,
                    title: 'Organiser',
                    subtitle: 'Create and manage events',
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OptionPage(
                          isOrganiser: true,
                          onLogin: (UserService service) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomePage()),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'University of Otago · UniVents 2026',
                    style: TextStyle(fontSize: 11, color: _grey),
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



// ── Role card widget ──
class _RoleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _pressed = false;

  static const _green = Color(0xFF286749);
  static const _greenLight = Color(0xFFE4F1EB);
  static const _border = Color(0xFFDEE3E0);
  static const _text = Color(0xFF171C1A);
  static const _grey = Color(0xFF6D7873);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _pressed ? _greenLight : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _pressed ? _green : _border,
            width: _pressed ? 1.5 : 0.5,
          ),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _pressed ? _green.withOpacity(0.15) : _greenLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.icon, size: 20, color: _green),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _text)),
                  const SizedBox(height: 2),
                  Text(widget.subtitle,
                      style: const TextStyle(fontSize: 12, color: _grey)),
                ],
              ),
            ),
            AnimatedSlide(
              duration: const Duration(milliseconds: 120),
              offset: _pressed ? const Offset(0.3, 0) : Offset.zero,
              child: const Icon(Icons.chevron_right_rounded,
                  color: _grey, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}