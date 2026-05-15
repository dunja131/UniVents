import 'package:flutter/material.dart';
import 'package:frontend/pages/loginForm.dart';
import 'package:frontend/pages/signUpForm.dart';
import 'package:frontend/services/user_service.dart';
import 'package:google_fonts/google_fonts.dart';


class OptionPage extends StatefulWidget {
  final void Function(UserService)? onLogin;
  const OptionPage({super.key, this.onLogin});

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  bool _isLogin = true;
  bool _isStudent = true; //tracks whether user is student or organiser
  

  void _toggleMode() {
    setState(() => _isLogin = !_isLogin);
  }

  // reusable toggle widget to avoid repeating code
  Widget _buildToggle({
  required ColorScheme colorScheme,
  required String leftLabel,
  required IconData leftIcon,
  required String rightLabel,
  required IconData rightIcon,
  required bool isLeft,
  required VoidCallback onLeftTap,
  required VoidCallback onRightTap,
}) {
  final activeColor = colorScheme.primary;
 final inactiveColor = colorScheme.onSurfaceVariant;

  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        // Left option - Student
        Expanded(
          child: GestureDetector(
            onTap: onLeftTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isLeft ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: isLeft
                    ? [
                        BoxShadow(
                          color: activeColor.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    leftIcon,
                    size: 16,
                    color: isLeft ? Colors.white : inactiveColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    leftLabel,
                    style: TextStyle(
                      color: isLeft ? Colors.white : inactiveColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Right option - Organiser
        Expanded(
          child: GestureDetector(
            onTap: onRightTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: !isLeft ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: !isLeft
                    ? [
                        BoxShadow(
                          color: activeColor.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    rightIcon,
                    size: 16,
                    color: !isLeft ? Colors.white : inactiveColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    rightLabel,
                    style: TextStyle(
                      color: !isLeft ? Colors.white : inactiveColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  Text(
                    'UniVents',
                    style: GoogleFonts.outfit(
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    'Discover events happening on campus',
                    style: TextStyle(fontSize: 15, color: colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  
                  _buildToggle(
                    colorScheme: colorScheme,
                    leftLabel: 'Student',
                    leftIcon: Icons.school_rounded,
                    rightLabel: 'Organiser',
                    rightIcon: Icons.campaign_rounded,
                    isLeft: _isStudent,
                    onLeftTap: () => setState(() => _isStudent = true),
                    onRightTap: () => setState(() => _isStudent = false),
                  ),

                  const SizedBox(height: 32),

                  // form - passes role down to form
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isLogin
                        ? LoginForm(
                            key: ValueKey('login-$_isStudent'),
                            onLogin: widget.onLogin,
                            isOrganiser:
                                !_isStudent, // TODO: wire to backend when ready
                          )
                        : SignUpForm(
                            key: ValueKey('signup-$_isStudent'),
                            onLogin: widget.onLogin,
                            isOrganiser:
                                !_isStudent, // TODO: wire to backend when ready
                          ),
                  ),

                  const SizedBox(height: 16),

                  // toggle between login and signup
                  TextButton(
                    onPressed: _toggleMode,
                    child: Text(
                      _isLogin
                          ? "Don't have an account? Sign Up"
                          : 'Already have an account? Log In',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
