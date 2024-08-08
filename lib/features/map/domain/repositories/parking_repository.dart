import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class ParkingRepository {
  Future<List<Map<String, dynamic>>> getNearbyParkings(LatLng location);
}
