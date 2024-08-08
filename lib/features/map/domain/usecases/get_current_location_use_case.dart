import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkeasy/features/map/domain/repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository locationRepository;

  GetCurrentLocationUseCase(this.locationRepository);

  Future<LatLng> call() async {
    return await locationRepository.getCurrentLocation();
  }
}
