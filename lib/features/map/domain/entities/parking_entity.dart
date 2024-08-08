import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingEntity extends Equatable {
  final String id;
  final String name;
  final LatLng location;
  final int availableSpots;

  const ParkingEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.availableSpots,
  });

  factory ParkingEntity.fromMap(Map<String, dynamic> map) {
    return ParkingEntity(
      id: map['id'],
      name: map['name'],
      location: LatLng(map['latitude'], map['longitude']),
      availableSpots: map['availableSpots'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'availableSpots': availableSpots,
    };
  }

  @override
  List<Object?> get props => [id, name, location, availableSpots];
}
