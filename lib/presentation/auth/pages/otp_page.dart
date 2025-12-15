import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/otp_cubit.dart';
import '../bloc/otp_state.dart';
import '../bloc/otp_purpose.dart';

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

  // ===============================
  // HELPER: MASK EMAIL
  // ===============================
  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final name = parts[0];
    final domain = parts[1];

    if (name.length <= 2) return '***@$domain';
    return '${name.substring(0, 2)}****@$domain';
  }

  // ===============================
  // SUBMIT OTP
  // ===============================
  void _submitOtp() {
    if (_submitted) return;

    final otpCode = _controllers.map((c) => c.text.trim()).join();

    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Masukkan 6 digit kode OTP"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    _submitted = true;

    context.read<OtpCubit>().submitOtp(
      email: widget.email,
      otp: otpCode,
      purpose: widget.purpose,
    );
  }

  // ===============================
  // OTP BOX
  // ===============================
  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 48,
      height: 58,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          // Auto submit saat digit ke-6
          if (index == 5 && value.isNotEmpty) {
            _submitOtp();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi OTP")),
      body: BlocConsumer<OtpCubit, OtpState>(
        listenWhen: (prev, curr) => curr is OtpSuccess || curr is OtpError,
        listener: (context, state) {
          _submitted = false;

          // ===============================
          // SUCCESS
          // ===============================
          if (state is OtpSuccess) {
            if (widget.purpose == OtpPurpose.login) {
              context.go('/home');
            } else {
              context.go('/reset-password', extra: {'email': widget.email});
            }
          }

          // ===============================
          // ERROR → CLEAR OTP
          // ===============================
          if (state is OtpError) {
            for (final c in _controllers) {
              c.clear();
            }
            _focusNodes.first.requestFocus();

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                ),
              );
          }
        },
        builder: (context, state) {
          final isLoading = state is OtpLoading;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Masukkan Kode OTP",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Kode OTP telah dikirim ke ${_maskEmail(widget.email)}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, _buildOtpBox),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitOtp,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Verifikasi"),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Fitur kirim ulang OTP belum tersedia",
                                ),
                              ),
                            );
                        },
                  child: const Text("Kirim ulang OTP"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
