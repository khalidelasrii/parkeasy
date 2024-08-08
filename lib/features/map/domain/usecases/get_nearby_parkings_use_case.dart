import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkeasy/features/map/domain/repositories/parking_repository.dart';

class GetNearbyParkingsUseCase {
  final ParkingRepository parkingRepository;

  GetNearbyParkingsUseCase(this.parkingRepository);

  Future<List<Map<String, dynamic>>> call(LatLng location) async {
    return await parkingRepository.getNearbyParkings(location);
  }
}
