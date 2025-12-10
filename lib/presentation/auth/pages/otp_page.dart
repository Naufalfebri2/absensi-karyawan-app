import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/otp_cubit.dart';
import '../bloc/otp_state.dart';
import '../../../core/widgets/loading_overlay.dart';

class OtpPage extends StatefulWidget {
  final String email;
  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final otpC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi OTP")),
      body: BlocConsumer<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state.isLoading) {
            LoadingOverlay.showOverlay(context);
          } else {
            LoadingOverlay.hideOverlay();
          }

          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }

          if (state.isVerified) {
            context.go('/home');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Kode OTP telah dikirim ke email:\n${widget.email}",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: otpC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Masukkan OTP"),
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<OtpCubit>().verifyOtp(otpC.text.trim());
                  },
                  child: const Text("Verifikasi"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
