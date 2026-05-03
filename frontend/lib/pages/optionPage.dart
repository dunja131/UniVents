import 'package:flutter/material.dart';
import 'package:frontend/pages/loginForm.dart';
import 'package:frontend/pages/signUpForm.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/theme/app_colours.dart';
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
    required String leftLabel,
    required String rightLabel,
    required bool isLeft,
    required VoidCallback onLeftTap,
    required VoidCallback onRightTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onLeftTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isLeft ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isLeft
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  leftLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isLeft ? AppColours.primary : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onRightTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: !isLeft ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: !isLeft
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  rightLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !isLeft ? AppColours.primary : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
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
    return Scaffold(
      backgroundColor: Colors.white,
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
                    style: GoogleFonts.montserrat(
                      fontSize: 52,
                      color: Colors.black87,
                      letterSpacing: 3,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    'Discover events happening on campus',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // role toggle - student vs organiser
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'I am a...',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildToggle(
                    leftLabel: 'Student',
                    rightLabel: 'Organiser',
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
