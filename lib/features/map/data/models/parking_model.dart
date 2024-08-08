import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkeasy/features/map/domain/entities/parking_entity.dart';

class ParkingModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int availableSpots;

  ParkingModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.availableSpots,
  });

  factory ParkingModel.fromMap(Map<String, dynamic> map) {
    return ParkingModel(
      id: map['id'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      availableSpots: map['availableSpots'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'availableSpots': availableSpots,
    };
  }

  ParkingEntity toEntity() {
    return ParkingEntity(
      id: id,
      name: name,
      location: LatLng(latitude, longitude),
      availableSpots: availableSpots,
    );
  }

  static ParkingModel fromEntity(ParkingEntity entity) {
    return ParkingModel(
      id: entity.id,
      name: entity.name,
      latitude: entity.location.latitude,
      longitude: entity.location.longitude,
      availableSpots: entity.availableSpots,
    );
  }
}
