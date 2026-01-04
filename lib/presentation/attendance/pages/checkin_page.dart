import 'dart:io';

import 'package:absensi_karyawan_app/presentation/home/bloc/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/checkin_cubit.dart';
import '../bloc/checkin_state.dart';

import '../widgets/selfie_camera.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
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
        title: const Text('Check In'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(null),
        ),
      ),

      // ===============================
      // BODY
      // ===============================
      body: BlocConsumer<CheckInCubit, CheckInState>(
        listener: (context, state) async {
          // Guard State lifecycle
          if (!mounted) return;

          // ===============================
          // SUCCESS
          // ===============================
          if (state is CheckInSuccess) {
            // 🔥 OPTIMISTIC UI UPDATE (Immediate feedback)
            context.read<HomeCubit>().markCheckedIn();

            // 🔥 DELAYED API REFRESH (Ensure backend sync)
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                context.read<HomeCubit>().refresh();
              }
            });

            // kembali ke Home
            context.pop({
              'status': state.status,
              'checkInTime': state.checkInTime,
            });
          }

          // ===============================
          // FAILURE (DIALOG)
          // ===============================
          if (state is CheckInFailure && !_dialogOpen) {
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
                    Icon(Icons.location_off, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Lokasi Tidak Valid'),
                  ],
                ),
                content: Text(
                  state.message,
                  style: const TextStyle(fontSize: 14),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Understand'),
                  ),
                ],
              ),
            );

            // 🔥 FIX UTAMA (BuildContext safety)
            if (!context.mounted) return;

            _dialogOpen = false;
          }
        },

        builder: (context, state) {
          final isLoading = state is CheckInLoading;
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
                      Icon(Icons.location_on, color: Colors.white, size: 36),
                      SizedBox(height: 12),
                      Text(
                        'Location Detected',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Pamulang University\nSouth Tangerang',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ===============================
                // BUTTON CHECK IN (SELFIE)
                // ===============================
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isButtonDisabled
                        ? null
                        : () async {
                            // ===============================
                            // 1️⃣ AMBIL FOTO SELFIE
                            // ===============================
                            final File? selfie = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SelfieCameraPage(),
                              ),
                            );

                            // Guard State setelah async
                            if (!context.mounted) return;

                            if (selfie == null) return;

                            // ===============================
                            // 2️⃣ SUBMIT CHECK-IN
                            // ===============================
                            context.read<CheckInCubit>().submitCheckIn(
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
                            'Confirm Check-In',
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
