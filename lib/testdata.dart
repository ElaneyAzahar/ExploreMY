import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../repository/state_repo.dart';
import '../models/state_model.dart';

import '../controllers/place_controller.dart';
import '../models/place_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StateListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StateListPage extends StatelessWidget {
  StateListPage({super.key});

  final StateRepository stateRepo = StateRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('States')),
      body: StreamBuilder<List<StateModel>>(
        stream: stateRepo.streamStates(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final states = snapshot.data!;
          if (states.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          return ListView.builder(
            itemCount: states.length,
            itemBuilder: (context, index) {
              final state = states[index];

              return ListTile(
                title: Text(state.name),
                subtitle: Text('State ID: ${state.id}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaceListPage(
                        stateId: state.id,
                        stateName: state.name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class PlaceListPage extends StatelessWidget {
  final String stateId;
  final String stateName;

  PlaceListPage({
    super.key,
    required this.stateId,
    required this.stateName,
  });

  final PlaceController  placeController = PlaceController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Places in $stateName')),
      body: StreamBuilder<List<PlaceModel>>(
        stream: placeController.getPlacesByState(stateId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading places'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final places = snapshot.data!;
          if (places.isEmpty) {
            return const Center(child: Text('No places found'));
          }

          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(place.name),
                  subtitle: Text(
                    'Adult: ${place.adultPrice} | Child: ${place.childPrice}\n${place.desc}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
