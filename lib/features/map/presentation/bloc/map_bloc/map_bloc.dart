import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkeasy/core/constant/enum.dart';
import 'package:parkeasy/core/services/shared_pref_service.dart';
import 'package:parkeasy/features/map/domain/usecases/get_current_location_use_case.dart';
import 'package:parkeasy/features/map/domain/usecases/get_nearby_parkings_use_case.dart';
part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GetNearbyParkingsUseCase getNearbyParkingsUseCase;
  final SharedPrefService sharedPrefService;

  MapBloc({
    required this.getCurrentLocationUseCase,
    required this.getNearbyParkingsUseCase,
    required this.sharedPrefService,
  }) : super(const MapState()) {
    on<LoadMap>(_onLoadMap);
    on<UpdateCurrentLocation>(_onUpdateCurrentLocation);
    on<FetchNearbyParkings>(_onFetchNearbyParkings);
  }

  Future<void> _onLoadMap(LoadMap event, Emitter<MapState> emit) async {
    emit(state.copyWith(status: MapStatus.loading));
    try {
      // dernière position
      final lastLat = sharedPrefService.getValue<double>('lastLat', 48.8566);
      final lastLng = sharedPrefService.getValue<double>('lastLng', 2.3522);
      final lastLocation = LatLng(lastLat, lastLng);
      emit(state.copyWith(
        status: MapStatus.loaded,
        currentLocation: lastLocation,
      ));

      //  position actuelle
      final currentLocation = await getCurrentLocationUseCase();

      // update nouvelle position
      sharedPrefService.putValue('lastLat', currentLocation.latitude);
      sharedPrefService.putValue('lastLng', currentLocation.longitude);

      emit(state.copyWith(
        status: MapStatus.loaded,
        currentLocation: currentLocation,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MapStatus.error,
        errorMessage: 'Failed to load map: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateCurrentLocation(
      UpdateCurrentLocation event, Emitter<MapState> emit) async {
    try {
      // update nouvelle position
      sharedPrefService.putValue('lastLat', event.location.latitude);
      sharedPrefService.putValue('lastLng', event.location.longitude);
      final nearbyParkings = await getNearbyParkingsUseCase(event.location);

      emit(state.copyWith(
        status: MapStatus.loaded,
        currentLocation: event.location,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MapStatus.error,
        errorMessage: 'Failed to update location: ${e.toString()}',
      ));
    }
  }

  Future<void> _onFetchNearbyParkings(
      FetchNearbyParkings event, Emitter<MapState> emit) async {
    try {
      final nearbyParkings = await getNearbyParkingsUseCase(event.location);

      emit(state.copyWith(
        status: MapStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MapStatus.error,
        errorMessage: 'Failed to fetch nearby parkings: ${e.toString()}',
      ));
    }
  }
}
