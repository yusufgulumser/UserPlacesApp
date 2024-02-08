import 'package:favorite_places/providers/add_place_provider.dart';
import 'package:favorite_places/screens/add_item.dart';
import 'package:favorite_places/widgets/item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends ConsumerState<MainPage> {
  late Future<void> _placesFuture;
  @override
  void initState() {
    _placesFuture = ref.read(addPlacesProvider.notifier).loadData();
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final userPlaces = ref.watch(addPlacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const AddPlaceScreen()));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: FutureBuilder(
            future: _placesFuture,
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const CircularProgressIndicator()
                    : PlacesList(places: userPlaces),
          )),
    );
  }
}
