import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkeasy/features/map/domain/repositories/location_repository.dart';

class GetCurrentLocation {
  final LocationRepository locationRepository;

  GetCurrentLocation(this.locationRepository);

  Future<LatLng> call() async {
    return await locationRepository.getCurrentLocation();
  }
}