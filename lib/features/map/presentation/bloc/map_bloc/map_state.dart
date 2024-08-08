part of 'map_bloc.dart';

class MapState extends Equatable {
  final MapStatus status;
  final LatLng? currentLocation;
  final Set<Marker> parkingMarkers;
  final String? errorMessage;

  const MapState({
    this.status = MapStatus.initial,
    this.currentLocation,
    this.parkingMarkers = const <Marker>{},
    this.errorMessage,
  });

  MapState copyWith({
    MapStatus? status,
    LatLng? currentLocation,
    Set<Marker>? parkingMarkers,
    String? errorMessage,
  }) {
    return MapState(
      status: status ?? this.status,
      currentLocation: currentLocation ?? this.currentLocation,
      parkingMarkers: parkingMarkers ?? this.parkingMarkers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, currentLocation, parkingMarkers, errorMessage];
}
