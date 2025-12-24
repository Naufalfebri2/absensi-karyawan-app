import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../home/bloc/home_cubit.dart';
import '../../home/bloc/home_state.dart';
import '../bloc/checkin_cubit.dart';
import '../bloc/checkin_state.dart';

class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF624731);
    const lightBrown = Color(0xFF957158);

    return BlocProvider(
      create: (_) => CheckInCubit(),
      child: Scaffold(
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
            onPressed: () => context.pop(false),
          ),
        ),

        // ===============================
        // BODY
        // ===============================
        body: BlocConsumer<CheckInCubit, CheckInState>(
          listener: (context, state) {
            if (state is CheckInSuccess) {
              Navigator.pop(context, true);
            }

            if (state is CheckInFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is CheckInLoading;

            // ===============================
            // AMBIL STATUS HARI LIBUR DARI HOME
            // ===============================
            final homeState = context.read<HomeCubit>().state;
            final bool isHoliday =
                homeState is HomeLoaded && homeState.isHoliday;

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
                          'Lokasi Terdeteksi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Universitas Pamulang\nTangerang Selatan',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // ===============================
                  // BUTTON CHECK IN
                  // ===============================
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<CheckInCubit>().submitCheckIn(
                                isHoliday: isHoliday,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isHoliday ? Colors.grey : lightBrown,
                        foregroundColor: Colors.white,
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
                              'Konfirmasi Check In',
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
      ),
    );
  }
}
