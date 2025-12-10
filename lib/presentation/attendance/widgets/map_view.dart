import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapView extends StatefulWidget {
  final Function(double lat, double lng) onLocationDetected;

  const MapView({super.key, required this.onLocationDetected});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? mapController;

  LatLng? currentPosition;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  /// ===================================================
  /// STEP 1 — CEK PERMISSION & AMBIL KOORDINAT GPS
  /// ===================================================
  Future<void> _initializeLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentPosition = LatLng(position.latitude, position.longitude);

    widget.onLocationDetected(position.latitude, position.longitude);

    if (mounted) setState(() => isLoading = false);
  }

  /// ===================================================
  /// UPDATE MARKER & CAMERA
  /// ===================================================
  void _moveCamera(LatLng pos) {
    if (mapController == null) return;

    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 17)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            if (currentPosition != null)
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: currentPosition!,
                  zoom: 16,
                ),
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: {
                  Marker(
                    markerId: const MarkerId("user_location"),
                    position: currentPosition!,
                    infoWindow: const InfoWindow(title: "Lokasi Anda"),
                  ),
                },
                onMapCreated: (controller) {
                  mapController = controller;
                  _moveCamera(currentPosition!);
                },
              ),

            /// ===================================================
            /// LOADING STATE
            /// ===================================================
            if (isLoading) const Center(child: CircularProgressIndicator()),

            /// ===================================================
            /// JIKA PERMISSION DITOLAK
            /// ===================================================
            if (!isLoading && currentPosition == null)
              const Center(
                child: Text(
                  "Tidak bisa mendapatkan lokasi.\nAktifkan GPS dan izinkan akses lokasi.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
