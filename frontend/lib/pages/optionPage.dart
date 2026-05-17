import 'package:flutter/material.dart';
import 'package:frontend/pages/loginForm.dart';
import 'package:frontend/pages/signUpForm.dart';
import 'package:frontend/services/user_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/pages/welcomePage.dart';

class OptionPage extends StatefulWidget {
  final void Function(UserService)? onLogin;
  final bool isOrganiser; // passed from WelcomePage to pre-select role

  const OptionPage({super.key, this.onLogin, this.isOrganiser = false});

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  bool _isLogin = true;
  late bool _isStudent;


  // ── Design tokens matching welcome page ──
  static const _green = Color(0xFF286749);
  static const _greenLight = Color(0xFFE4F1EB);
  static const _greenDark = Color(0xFF1F513A);
  static const _grey = Color(0xFF6D7873);
  static const _border = Color(0xFFDEE3E0);

  @override
  void initState() {
    super.initState();
    // pre-select based on what the user tapped on WelcomePage
    _isStudent = !widget.isOrganiser;
  }

  void _toggleMode() {
    setState(() => _isLogin = !_isLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _greenLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── Green top header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Row(
                children: [
                  // Back to welcome page
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomePage()),
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 14,
                          color: _greenDark,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 14,
                            color: _greenDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Role badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isStudent
                              ? Icons.school_rounded
                              : Icons.campaign_rounded,
                          size: 14,
                          color: _greenDark,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _isStudent ? 'Student' : 'Organiser',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _greenDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── White card with form ──
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Heading ──
                      Text(
                        _isLogin ? 'Welcome back' : 'Create account',
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF171C1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isLogin
                            ? 'Sign in to your ${_isStudent ? 'student' : 'organiser'} account'
                            : 'Join UniVents as a ${_isStudent ? 'student' : 'organiser'}',
                        style: TextStyle(fontSize: 14, color: _grey),
                      ),

                      const SizedBox(height: 32),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _isLogin
                            ? LoginForm(
                                key: ValueKey('login-$_isStudent'),
                                onLogin: widget.onLogin,
                                isOrganiser: !_isStudent,
                              )
                            : SignUpForm(
                                key: ValueKey('signup-$_isStudent'),
                                onLogin: widget.onLogin,
                                isOrganiser: !_isStudent,
                              ),
                      ),

                      const SizedBox(height: 20),

                      // ── Toggle login/signup ──
                      Center(
                        child: TextButton(
                          onPressed: _toggleMode,
                          child: Text(
                            _isLogin
                                ? "Don't have an account? Sign Up"
                                : 'Already have an account? Log In',
                            style: TextStyle(color: _grey, fontSize: 13),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // // ── Switch role link ── a bit redundant since i got back button working
                      // Center(
                      //   child: GestureDetector(
                      //     onTap: () => setState(() => _isStudent = !_isStudent),
                      //     child: Text(
                      //       _isStudent
                      //           ? 'Log in as Organiser instead →'
                      //           : 'Log in as Student instead →',
                      //       style: TextStyle(
                      //         fontSize: 13,
                      //         color: _green,
                      //         fontWeight: FontWeight.w600,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
