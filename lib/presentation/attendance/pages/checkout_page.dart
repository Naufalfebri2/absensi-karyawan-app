import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/loading_overlay.dart';
import '../../../data/datasources/local/session_local.dart';
import '../bloc/checkout_cubit.dart';
import '../widgets/map_view.dart';
import '../widgets/selfie_camera.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? capturedPhoto;
  double? currentLat;
  double? currentLng;

  int? employeeId;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  /// Ambil employeeId dari session user
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
      appBar: AppBar(title: const Text("Check Out")),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutLoading) {
            LoadingOverlay.showOverlay(context, message: "Checking out...");
          } else {
            LoadingOverlay.hideOverlay();
          }

          if (state is CheckoutSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Check-out berhasil!")),
            );
            Navigator.pop(context);
          }

          if (state is CheckoutError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SelfieCamera(
                onCaptured: (path) {
                  setState(() => capturedPhoto = path);
                },
              ),

              const SizedBox(height: 20),

              MapView(
                onLocationDetected: (lat, lng) {
                  setState(() {
                    currentLat = lat;
                    currentLng = lng;
                  });
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed:
                    (employeeId == null ||
                        capturedPhoto == null ||
                        currentLat == null ||
                        currentLng == null)
                    ? null
                    : () {
                        context.read<CheckoutCubit>().doCheckOut(
                          employeeId: employeeId!,
                          photoPath: capturedPhoto!,
                          latitude: currentLat!,
                          longitude: currentLng!,
                        );
                      },
                child: const Text("Check Out Sekarang"),
              ),
            ],
          );
        },
      ),
    );
  }
}
