import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/home_page.dart';
import 'package:frontend/pages/OrganiserDashboardScreen.dart';


class SignUpForm extends StatefulWidget {
  final void Function(UserService)? onLogin;
  final bool isOrganiser;

  const SignUpForm({super.key, this.onLogin, this.isOrganiser = false});

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

 Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;
  setState(() => _isLoading = true);

  bool loginSucceeded = false;

  try {
    final userService = UserService(
      _emailController.text,
      _passwordController.text,
    );

    if (widget.isOrganiser) {
      // ── Organiser registration ──
      await userService.createOrganiser(
        _firstNameController.text,
        _lastNameController.text,
        _emailController.text,
        _passwordController.text,
      );
       debugPrint('Organiser registered');
    } else {
      // ── Student registration ──
      final user = User(
        userId: '',
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      await userService.createUser(user);
      debugPrint('Student registered');
    }

    // ── Login after registration ──
    await userService.login(isOrganiser: widget.isOrganiser);
    debugPrint('Login complete token: ${userService.authHeader}');

    loginSucceeded = true;

    final isOrganiser = widget.isOrganiser;
    final onLogin = widget.onLogin;


    if (!mounted) return;
    debugPrint('Navigating... isOrganiser: ${widget.isOrganiser}');

    if (widget.isOrganiser) {
      // organiser goes to dashboard
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              OrganiserDashboardScreen(userService: userService),
        ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(initialUserService: userService),
        ),
        (route) => false,
      );
    }
  } catch (e) {
    if (loginSucceeded) return;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sign up failed: $e')),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
  // reusable field builder to avoid repeating decoration code
  Widget _buildField({

    
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FIRST NAME
          _buildField(
            label: 'FIRST NAME',
            hint: 'Jane',
            controller: _firstNameController,
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'First name is required';
              return null;
            },
          ),

          const SizedBox(height: 20),

          // LAST NAME
          _buildField(
            label: 'LAST NAME',
            hint: 'Smith',
            controller: _lastNameController,
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Last name is required';
              return null;
            },
          ),

          const SizedBox(height: 20),

          // EMAIL
          _buildField(
            label: 'EMAIL',
            hint: 'you@email.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email is required';
              if (!value.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),

          const SizedBox(height: 20),

          // PASSWORD
          _buildField(
            label: 'PASSWORD',
            hint: '••••••••',
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Password is required';
              if (value.length < 6)
                return 'Password must be at least 6 characters';
              return null;
            },
          ),

          const SizedBox(height: 20),

          // CONFIRM PASSWORD
          _buildField(
            label: 'CONFIRM PASSWORD',
            hint: '••••••••',
            controller: _confirmPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please confirm your password';
              if (value != _passwordController.text)
                return 'Passwords do not match';
              return null;
            },
          ),

          const SizedBox(height: 24),

          // SIGN UP BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
