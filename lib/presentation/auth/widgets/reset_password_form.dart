import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/reset_password_cubit.dart';
import '../bloc/reset_password_state.dart';

class ResetPasswordForm extends StatefulWidget {
  final String email;
  const ResetPasswordForm({super.key, required this.email});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordC = TextEditingController();
  final _confirmC = TextEditingController();

  @override
  void dispose() {
    _passwordC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ResetPasswordCubit>().submit(
      email: widget.email,
      password: _passwordC.text,
      confirmPassword: _confirmC.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          context.go('/login');
        }

        if (state is ResetPasswordError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final loading = state is ResetPasswordLoading;

        return Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _passwordC,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password Baru'),
                validator: (v) =>
                    v == null || v.length < 6 ? 'Minimal 6 karakter' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmC,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password',
                ),
                validator: (v) =>
                    v != _passwordC.text ? 'Password tidak sama' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : _submit,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text('Reset Password'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
