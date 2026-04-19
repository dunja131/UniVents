import 'package:flutter/material.dart';
import 'loginForm.dart';
import 'signUpForm.dart';
import 'package:frontend/services/user_service.dart';



class OptionPage extends StatefulWidget {
  final void Function(UserService)? onLogin;
  const OptionPage({super.key, this.onLogin});

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  bool _isLogin = true;

  void _toggleMode() {
    setState(() => _isLogin = !_isLogin);
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isLogin
                  ? LoginForm(key: const ValueKey('login'), onLogin: widget.onLogin)
                  : SignUpForm(key: const ValueKey('signup'), onLogin: widget.onLogin),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _toggleMode,
            child: Text(
              _isLogin
                  ? "Don't have an account? Sign Up"
                  : 'Already have an account? Log In',
            ),
          ),
        ],
      ),
    );
  }
}
