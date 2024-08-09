import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  Future<String> loadMapStyle(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

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
                  onMapCreated: (GoogleMapController controller) async {
                    context
                        .read<MapBloc>()
                        .add(UpdateCurrentLocation(state.currentLocation!));
                    String mapStyle = await loadMapStyle(
                        theme.brightness == Brightness.dark
                            ? 'assets/dark_map_style.json'
                            : 'assets/light_map_style.json');

                    controller.setMapStyle(mapStyle);
                  },
                  markers: state.parkingMarkers,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.secondary,
                  ),
                );
              }
            },
          ),
          // Center(
          //   child: SizedBox(
          //     height: size.height * 0.6,
          //     child: const ParkingList(),
          //   ),
          // ),
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
              return const ParkingCard();
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
  const ParkingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // Handle navigation to the selected parking spot
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(
          vertical: size.height * 0.01,
          horizontal: size.width * 0.05,
        ),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Parking Name',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  )),
              SizedBox(height: size.height * 0.01),
              Text('Places disponibles: 5', style: theme.textTheme.bodyMedium),
              SizedBox(height: size.height * 0.005),
              Text('Distance: 2 km',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  )),
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
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.08),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: size.height * 0.06,
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border.all(color: theme.primaryColor, width: 2),
                borderRadius: BorderRadius.circular(size.width * 0.05),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                  prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.015,
                  ),
                ),
                onChanged: (query) {
                  context.read<MapBloc>().add(SearchParking(query: query));
                },
              ),
            ),
          ),
          SizedBox(width: size.width * 0.03),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  context.go(Routes.profile);
                },
                child: CircleAvatar(
                  backgroundColor: theme.primaryColor,
                  radius: size.width * 0.06,
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.005),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size.width * 0.055),
                      child: state.user?.profileUrl == null
                          ? CircularProgressIndicator(
                              color: theme.colorScheme.secondary,
                              strokeWidth: 2,
                            )
                          : CachedNetworkImage(
                              imageUrl: state.user!.profileUrl!,
                              fit: BoxFit.cover,
                              height: size.width * 0.11,
                              width: size.width * 0.11,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(
                                color: theme.colorScheme.secondary,
                                strokeWidth: 2,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error, color: Colors.red),
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
