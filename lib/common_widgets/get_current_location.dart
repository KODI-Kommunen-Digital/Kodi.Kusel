import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> getLatLong() async {
  // Check if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  // Check and request permission if needed
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permission permanently denied.');
  }

  // Get current position
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

Future<String?> getCityFromPosition(Position position) async {
  try {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placeMarks.isNotEmpty) {
      final Placemark place = placeMarks.first;
      return place.locality ?? place.subAdministrativeArea ?? place.administrativeArea;
    }
  } catch (e) {
    print('Error while getting city: $e');
  }
  return null;
}

Future<String?> fetchCity() async {
  final position = await getLatLong();
  final city = await getCityFromPosition(position);
  debugPrint("Detected city: $city");
  return city;
}
