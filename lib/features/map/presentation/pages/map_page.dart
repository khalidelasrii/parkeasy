import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkeasy/features/map/presentation/bloc/map_bloc/map_bloc.dart';
import 'package:parkeasy/features/map/presentation/widgets/google_map_widget.dart';
import 'package:parkeasy/service_locator.dart' as di;

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<MapBloc>(),
      child: const MapPageContent(),
    );
  }
}

class MapPageContent extends StatelessWidget {
  const MapPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          GoogleMapWidget(),
          SearchBar(),
          ParkingList(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 10,
      right: 10,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
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
    );
  }
}

class ParkingList extends StatelessWidget {
  const ParkingList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is MapLoaded) {
          return Positioned(
            bottom: 80,
            left: 10,
            right: 10,
            child: SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.nearbyParkings.length,
                itemBuilder: (context, index) {
                  final parking = state.nearbyParkings[index];
                  return ParkingCard(parking: parking);
                },
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class ParkingCard extends StatelessWidget {
  final Map<String, dynamic> parking;

  const ParkingCard({super.key, required this.parking});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(parking['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Places disponibles: ${parking['availableSpots']}'),
            // Ajoutez d'autres informations sur le parking ici
          ],
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Carte'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Liste'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
      onTap: (index) {
        // Gérez la navigation ici
      },
    );
  }
}


