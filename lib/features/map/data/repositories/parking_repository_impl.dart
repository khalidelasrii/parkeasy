import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkeasy/features/map/data/models/parking_model.dart';
import 'dart:convert';

import 'package:parkeasy/features/map/domain/repositories/parking_repository.dart';

class ParkingRepositoryImpl implements ParkingRepository {
  final String apiUrl =
      'https://api.example.com/parkings'; // Remplace avec ton URL API

  @override
  Future<List<Map<String, dynamic>>> getNearbyParkings(LatLng location) async {
    return [];
    // try {
    //   if (true) {
    //     return [
    //       {"": ""}
    //     ] as List<Map<String, dynamic>>;
    //   } else {
    //     throw Exception('Failed to load parkings');
    //   }
    // } catch (e) {
    //   throw Exception('Failed to fetch nearby parkings: ${e.toString()}');
    // }
  }
}
