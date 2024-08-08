
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkeasy/features/map/presentation/bloc/map_bloc/map_bloc.dart';


class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({super.key});


  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is MapLoaded) {
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: state.currentLocation,
              zoom: 14,
            ),
            markers: state.parkingMarkers,
            onMapCreated: (GoogleMapController controller) {
              // Vous pouvez utiliser le contrôleur ici si nécessaire
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}