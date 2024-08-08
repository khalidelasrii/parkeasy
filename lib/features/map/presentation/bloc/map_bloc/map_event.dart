part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class LoadMap extends MapEvent {}

class UpdateCurrentLocation extends MapEvent {
  final LatLng location;

  const UpdateCurrentLocation(this.location);

  @override
  List<Object> get props => [location];
}

class FetchNearbyParkings extends MapEvent {
  final LatLng location;

  const FetchNearbyParkings(this.location);

  @override
  List<Object> get props => [location];
}

class SearchParking extends MapEvent {
  final String query;
  const SearchParking({required this.query});
}
