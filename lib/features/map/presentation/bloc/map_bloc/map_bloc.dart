import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final locationUseCase;
  final parkingUseCase;

  MapBloc({
    required this.locationUseCase,
    required this.parkingUseCase,
  }) : super(MapInitial()) {
    on<LoadMap>(_onLoadMap);
    on<UpdateCurrentLocation>(_onUpdateCurrentLocation);
    on<FetchNearbyParkings>(_onFetchNearbyParkings);
  }

  Future<void> _onLoadMap(LoadMap event, Emitter<MapState> emit) async {
    emit(MapLoading());
    try {
      final currentLocation = await locationUseCase.getCurrentLocation();
      final nearbyParkings =
          await parkingUseCase.getNearbyParkings(currentLocation);
      final parkingMarkers = _createParkingMarkers(nearbyParkings);

      emit(MapLoaded(
        currentLocation: currentLocation,
        parkingMarkers: parkingMarkers,
        nearbyParkings: nearbyParkings,
      ));
    } catch (e) {
      emit(MapError('Failed to load map: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCurrentLocation(
      UpdateCurrentLocation event, Emitter<MapState> emit) async {
    try {
      final nearbyParkings =
          await parkingUseCase.getNearbyParkings(event.location);
      final parkingMarkers = _createParkingMarkers(nearbyParkings);

      emit(MapLoaded(
        currentLocation: event.location,
        parkingMarkers: parkingMarkers,
        nearbyParkings: nearbyParkings,
      ));
    } catch (e) {
      emit(MapError('Failed to update location: ${e.toString()}'));
    }
  }

  Future<void> _onFetchNearbyParkings(
      FetchNearbyParkings event, Emitter<MapState> emit) async {
    try {
      final nearbyParkings =
          await parkingUseCase.getNearbyParkings(event.location);
      final parkingMarkers = _createParkingMarkers(nearbyParkings);

      emit(MapLoaded(
        currentLocation: event.location,
        parkingMarkers: parkingMarkers,
        nearbyParkings: nearbyParkings,
      ));
    } catch (e) {
      emit(MapError('Failed to fetch nearby parkings: ${e.toString()}'));
    }
  }

  Set<Marker> _createParkingMarkers(List<Map<String, dynamic>> parkings) {
    // Implement your marker creation logic here
    // Return a Set of Markers

    return {const Marker(markerId: MarkerId(""))};
  }
}
