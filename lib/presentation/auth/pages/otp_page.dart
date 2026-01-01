import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:absensi_karyawan_app/config/constants/app_image.dart';

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
          content: Text('Please enter the 6-digit OTP code'),
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              // ================= TOP GRADIENT (SAMA LOGIN) =================
              Container(
                height: size.height * 0.42,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF37210E),
                      Color(0xFF624731),
                      Color(0xFF957158),
                    ],
                  ),
                ),
              ),

              // ================= CARD =================
              Align(
                alignment: Alignment.bottomCenter,
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

                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        left: 2,
                        right: 2,
                        top: size.height * 0.28,
                        bottom: 16,
                      ),
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
                      child: Column(
                        children: [
                          const Text(
                            'OTP Verification',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'The code has been sent to ${_maskEmail(widget.email)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
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
                                  : const Text('Verify'),
                            ),
                          ),

                          const SizedBox(height: 16),

                          TextButton(
                            onPressed: isLoading ? null : () {},
                            child: const Text('Resend OTP'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ================= LOGO FLOATING (SAMA LOGIN) =================
              Positioned(
                top: 90,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 123,
                    height: 123,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: ClipOval(
                      child: Image.asset(AppImages.logo, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
