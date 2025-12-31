import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/forgot_password_cubit.dart';
import '../bloc/forgot_password_state.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();

  @override
  void dispose() {
    _emailC.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ForgotPasswordCubit>().submitEmail(_emailC.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final loading = state is ForgotPasswordLoading;

        return Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailC,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => loading ? null : _submit(),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter email',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Email is required';
                  }
                  if (!v.contains('@')) {
                    return 'Invalid email format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : _submit,
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Generate OTP'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
