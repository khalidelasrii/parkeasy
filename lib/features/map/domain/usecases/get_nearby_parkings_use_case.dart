import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkeasy/features/map/domain/repositories/parking_repository.dart';

class GetNearbyParkings {
  final ParkingRepository parkingRepository;

  GetNearbyParkings(this.parkingRepository);

  Future<List<Map<String, dynamic>>> call(LatLng location) async {
    return await parkingRepository.getNearbyParkings(location);
  }
}
