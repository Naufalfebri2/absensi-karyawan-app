import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/loading_overlay.dart';
import '../../../data/datasources/local/session_local.dart';
import '../bloc/checkin_cubit.dart';
import '../widgets/map_view.dart';
import '../widgets/selfie_camera.dart';

class CheckinPage extends StatefulWidget {
  const CheckinPage({super.key});

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  String? capturedPhoto;
  double? currentLat;
  double? currentLng;

  int? employeeId;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  /// Ambil data user dari session
  Future<void> loadUser() async {
    final user = await SessionLocal.getUser();
    if (mounted) {
      setState(() {
        employeeId = user?.employeeId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Check In")),
      body: BlocConsumer<CheckinCubit, CheckinState>(
        listener: (context, state) {
          // SHOW OVERLAY WHEN LOADING
          if (state is CheckinLoading) {
            LoadingOverlay.showOverlay(
              context,
              message: "Memproses check-in...",
            );
          } else {
            LoadingOverlay.hideOverlay();
          }

          if (state is CheckinSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Check-in berhasil!")));
            Navigator.pop(context);
          }

          if (state is CheckinError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Camera
              SelfieCamera(
                onCaptured: (path) {
                  setState(() => capturedPhoto = path);
                },
              ),

              const SizedBox(height: 20),

              // Map
              MapView(
                onLocationDetected: (lat, lng) {
                  setState(() {
                    currentLat = lat;
                    currentLng = lng;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Button
              ElevatedButton(
                onPressed:
                    (employeeId == null ||
                        capturedPhoto == null ||
                        currentLat == null ||
                        currentLng == null)
                    ? null
                    : () {
                        context.read<CheckinCubit>().doCheckIn(
                          employeeId: employeeId!,
                          photoPath: capturedPhoto!,
                          latitude: currentLat!,
                          longitude: currentLng!,
                        );
                      },
                child: const Text("Check In Sekarang"),
              ),
            ],
          );
        },
      ),
    );
  }
}
