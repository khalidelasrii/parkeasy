import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkeasy/core/constant/constants.dart';
import 'package:parkeasy/core/constant/enum.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:parkeasy/features/map/presentation/bloc/map_bloc/map_bloc.dart';
import 'package:parkeasy/routes.dart';
import 'package:parkeasy/service_locator.dart' as di;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<MapBloc>()..add(LoadMap()),
      child: const MapPageContent(),
    );
  }
}

class MapPageContent extends StatelessWidget {
  const MapPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              if (state.status == MapStatus.loaded) {
                return GoogleMap(
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: state.currentLocation!,
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    context
                        .read<MapBloc>()
                        .add(UpdateCurrentLocation(state.currentLocation!));
                  },
                  markers: state.parkingMarkers,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          const Center(child: ParkingList()),
        ],
      ),
      floatingActionButton: const MyfloatingActionButton(),
    );
  }
}

class ParkingList extends StatelessWidget {
  const ParkingList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state.status == MapStatus.loaded) {
          return ListView.builder(
            itemCount: state.parkingMarkers.length,
            itemBuilder: (context, index) {
              return ParkingCard();
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class ParkingCard extends StatelessWidget {
  // final Map<String, dynamic> parking;

  const ParkingCard({
    super.key,
    //  required this.parking
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle navigation to the selected parking spot
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(parking['name'],
              //     style: const TextStyle(fontWeight: FontWeight.bold)),
              // Text('Places disponibles: ${parking['availableSpots']}'),
              // Text('Distance: ${parking['distance']} km'),
            ],
          ),
        ),
      ),
    );
  }
}

class MyfloatingActionButton extends StatefulWidget {
  const MyfloatingActionButton({super.key});

  @override
  State<MyfloatingActionButton> createState() => _MyfloatingActionButtonState();
}

class _MyfloatingActionButtonState extends State<MyfloatingActionButton> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: bluecolor, width: 2),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4)
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Rechercher...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  context.read<MapBloc>().add(SearchParking(query: query));
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            return GestureDetector(
              onTap: () {
                context.go(Routes.profile);
              },
              child: CircleAvatar(
                backgroundColor: bluecolor,
                radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(70)),
                    child: state.user?.profileUrl == null
                        ? const CircularProgressIndicator()
                        : CachedNetworkImage(
                            imageUrl: state.user!.profileUrl!,
                            fit: BoxFit.cover,
                            height: 70,
                            width: 70,
                          ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
