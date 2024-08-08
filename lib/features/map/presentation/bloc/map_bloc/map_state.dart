part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();
  
  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final LatLng currentLocation;
  final Set<Marker> parkingMarkers;
  final List<Map<String, dynamic>> nearbyParkings;

  const MapLoaded({
    required this.currentLocation,
    required this.parkingMarkers,
    required this.nearbyParkings,
  });

  @override
  List<Object> get props => [currentLocation, parkingMarkers, nearbyParkings];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object> get props => [message];
}