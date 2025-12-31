import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/login_cubit.dart';
import '../bloc/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (!_formKey.currentState!.validate()) return;

    context.read<LoginCubit>().submitLogin(
      username: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginCubit>().state;
    final isLoading = state is LoginLoading;

    // ===============================
    // COLOR CONSTANT (FIGMA)
    // ===============================
    const borderColor = Color(0xFFC9C6C6);
    const fillColor = Color(0xFFF3F3F3);
    const primaryBrown = Color(0xFF624731);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // EMAIL
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              filled: true,
              fillColor: fillColor,
              labelStyle: const TextStyle(color: Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryBrown),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email should not be empty';
              }
              if (!value.contains('@')) {
                return 'Email format is invalid';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // PASSWORD
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              filled: true,
              fillColor: fillColor,
              labelStyle: const TextStyle(color: Colors.black54),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryBrown),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password should not be empty';
              }
              if (value.length < 6) {
                return 'Minimum of 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          // REMEMBER & FORGOT
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                activeColor: primaryBrown,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
              const Text(
                'Remember me',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const Spacer(),

              TextButton(
                onPressed: () {
                  final email = _emailController.text.trim();
                  context.go('/reset-password', extra: {'email': email});
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(fontSize: 13, color: Color(0xFF1B9E8A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // LOGIN BUTTON (OUTLINE STYLE)
          Center(
            child: SizedBox(
              height: 48,
              width:
                  MediaQuery.of(context).size.width * 0.65, // 🔥 kontrol lebar
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitLogin,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
