import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/otp_cubit.dart';
import '../bloc/otp_state.dart';
import '../bloc/otp_purpose.dart';
import '../bloc/auth_cubit.dart';

class OtpPage extends StatefulWidget {
  final String email;
  final OtpPurpose purpose;

  const OtpPage({super.key, required this.email, required this.purpose});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _submitted = false;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    return name.length <= 2
        ? '***@$domain'
        : '${name.substring(0, 2)}****@$domain';
  }

  void _submitOtp() {
    if (_submitted) return;

    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan 6 digit kode OTP'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    _submitted = true;

    context.read<OtpCubit>().submitOtp(
      email: widget.email,
      otp: otp,
      purpose: widget.purpose,
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF624731), width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          if (index == 5 && value.isNotEmpty) {
            _submitOtp();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              // ===============================
              // HEADER / LOGO AREA (AMAN)
              // ===============================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 32, bottom: 48),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF624731), Color(0xFF8A6A4F)],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 72,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),

              // ===============================
              // CARD OTP
              // ===============================
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.14),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: BlocConsumer<OtpCubit, OtpState>(
                  listener: (context, state) {
                    _submitted = false;

                    if (state is OtpSuccess) {
                      if (widget.purpose == OtpPurpose.login) {
                        context.read<AuthCubit>().setAuthenticated(
                          token: state.token,
                          user: state.user,
                        );
                      } else {
                        context.go(
                          '/reset-password',
                          extra: {'email': widget.email},
                        );
                      }
                    }

                    if (state is OtpError) {
                      for (final c in _controllers) {
                        c.clear();
                      }
                      _focusNodes.first.requestFocus();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is OtpLoading;

                    return Column(
                      children: [
                        const Text(
                          'Verifikasi OTP',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kode dikirim ke ${_maskEmail(widget.email)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, _otpBox),
                        ),

                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submitOtp,
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  )
                                : const Text('Verifikasi'),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: isLoading ? null : () {},
                          child: const Text('Kirim ulang OTP'),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
