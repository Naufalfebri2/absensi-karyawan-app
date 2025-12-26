import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/checkout_cubit.dart';
import '../bloc/checkout_state.dart';
import '../../home/bloc/home_cubit.dart';

import '../widgets/selfie_camera.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  bool _dialogOpen = false; // 🔒 guard popup

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF624731);
    const lightBrown = Color(0xFF957158);

    return Scaffold(
      backgroundColor: Colors.white,

      // ===============================
      // APP BAR
      // ===============================
      appBar: AppBar(
        backgroundColor: brown,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Check Out'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(null),
        ),
      ),

      // ===============================
      // BODY
      // ===============================
      body: BlocConsumer<CheckOutCubit, CheckOutState>(
        listener: (context, state) async {
          if (!mounted) return;

          // ===============================
          // SUCCESS
          // ===============================
          if (state is CheckOutSuccess) {
            // 🔥 AUTO REFRESH HOME
            context.read<HomeCubit>().refresh();

            context.pop({
              'checkOutTime': state.checkOutTime,
              'status': state.status,
            });
          }

          // ===============================
          // FAILURE
          // ===============================
          if (state is CheckOutFailure && !_dialogOpen) {
            _dialogOpen = true;

            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Check Out Gagal'),
                  ],
                ),
                content: Text(
                  state.message,
                  style: const TextStyle(fontSize: 14),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Mengerti'),
                  ),
                ],
              ),
            );

            if (!context.mounted) return;
            _dialogOpen = false;
          }
        },

        builder: (context, state) {
          final isLoading = state is CheckOutLoading;
          final isButtonDisabled = isLoading || _dialogOpen;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 24),

                // ===============================
                // INFO CARD
                // ===============================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: brown,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.logout, color: Colors.white, size: 36),
                      SizedBox(height: 12),
                      Text(
                        'Akhiri Kehadiran',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Ambil foto selfie untuk konfirmasi check out',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ===============================
                // BUTTON CHECK OUT (🔥 WAJIB SELFIE)
                // ===============================
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isButtonDisabled
                        ? null
                        : () async {
                            // ===============================
                            // 1️⃣ AMBIL SELFIE
                            // ===============================
                            final File? selfie = await Navigator.push<File?>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SelfieCameraPage(),
                              ),
                            );

                            // 🔥 Guard context setelah async
                            if (!context.mounted) return;

                            if (selfie == null) return;

                            // ===============================
                            // 2️⃣ SUBMIT CHECK OUT
                            // ===============================
                            context.read<CheckOutCubit>().submitCheckOut(
                              selfieFile: selfie,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightBrown,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: lightBrown.withValues(
                        alpha: 0.6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Konfirmasi Check Out',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
