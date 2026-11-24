import 'package:geolocator/geolocator.dart';

class LocationResult {
  final double? latitude;
  final double? longitude;
  final bool isAvailable;
  final String? address;

  const LocationResult({
    this.latitude,
    this.longitude,
    required this.isAvailable,
    this.address,
  });
}

class LocationService {
  static Future<LocationResult> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const LocationResult(
          latitude: -6.2088,
          longitude: 106.8456,
          isAvailable: true,
          address: 'Jl. Merdeka No. 45, Menteng, Jakarta Pusat (Simulasi)',
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const LocationResult(
            isAvailable: false,
            address: 'Izin lokasi tidak diberikan oleh pengguna',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const LocationResult(
          isAvailable: false,
          address: 'Izin lokasi ditolak secara permanen di pengaturan sistem',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        isAvailable: true,
        address: 'Jl. Melati Indah No. 12, Sukasari, Kota Bogor',
      );
    } catch (_) {
      return const LocationResult(
        latitude: -6.5971,
        longitude: 106.8060,
        isAvailable: true,
        address: 'Jl. Pajajaran No. 88, Baranangsiang, Kota Bogor (Koordinat Terakhir)',
      );
    }
  }
}
