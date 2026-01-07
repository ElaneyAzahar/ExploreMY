import 'package:flutter/material.dart';
import 'package:tourismapp/selectitempage.dart';
import '../controllers/place_controller.dart';
import '../models/place_model.dart';

class PlaceListPage2 extends StatelessWidget {
  final String stateId;
  final String stateName;
  final bool isAdmin;

  PlaceListPage2({
    super.key,
    required this.stateId,
    required this.stateName,
    required this.isAdmin,
  });

  final PlaceController controller = PlaceController();

  // ✅ Updated Dialog: Added Image URL Input
  Future<void> _showPlaceDialog(
    BuildContext context, {
    required bool isEdit,
    PlaceModel? place,
  }) async {
    final nameCtrl = TextEditingController(text: place?.name ?? '');
    final adultCtrl = TextEditingController(text: place?.adultPrice.toString() ?? '');
    final childCtrl = TextEditingController(text: place?.childPrice.toString() ?? '');
    final descCtrl = TextEditingController(text: place?.desc ?? '');
    // ✅ 1. Controller for Image URL
    final imageCtrl = TextEditingController(text: place?.image ?? '');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Place' : 'Add Place'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Place name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.place),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: adultCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Adult price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: childCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Child price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.child_care),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 12),
              // ✅ 2. Image URL Input Field
              TextField(
                controller: imageCtrl,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'https://example.com/place.jpg',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              final desc = descCtrl.text.trim();
              final adultPrice = num.tryParse(adultCtrl.text.trim());
              final childPrice = num.tryParse(childCtrl.text.trim());
              final imageUrl = imageCtrl.text.trim(); // ✅ Get URL text

              if (name.isEmpty || adultPrice == null || childPrice == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill name + valid prices'),
                  ),
                );
                return;
              }

              // ✅ Pass imageUrl to Controller methods
              if (isEdit) {
                await controller.updatePlace(
                  stateId: stateId,
                  placeId: place!.id,
                  name: name,
                  adultPrice: adultPrice,
                  childPrice: childPrice,
                  desc: desc,
                  image: imageUrl, 
                );
              } else {
                await controller.addPlace(
                  stateId: stateId,
                  name: name,
                  adultPrice: adultPrice,
                  childPrice: childPrice,
                  desc: desc,
                  image: imageUrl, 
                );
              }

              if (context.mounted) Navigator.pop(context);
            },
            child: Text(isEdit ? 'Save' : 'Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, PlaceModel place) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete place?'),
        content: Text('Delete "${place.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await controller.deletePlace(stateId: stateId, placeId: place.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places in $stateName'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => _showPlaceDialog(context, isEdit: false),
              backgroundColor: Colors.red,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stateName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Places',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<PlaceModel>>(
              stream: controller.getPlacesByState(stateId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading places'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final places = snapshot.data!;
                if (places.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_off, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text('No places found'),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: places.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final place = places[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SelectitemPage(
                                stateId: stateId,
                                itemId: place.id,
                                category: ItemCategory.place,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // ✅ 3. Display Image with fallback
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.red.shade100,
                                  child: (place.image.isNotEmpty)
                                      ? Image.network(
                                          place.image,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.account_balance,
                                              color: Colors.red,
                                              size: 30,
                                            );
                                          },
                                        )
                                      : Icon(
                                          Icons.account_balance,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      place.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    // Optional: Add price range display
                                    const SizedBox(height: 4),
                                    Text(
                                      'Adult: RM ${place.adultPrice.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (isAdmin)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _showPlaceDialog(
                                        context,
                                        isEdit: true,
                                        place: place,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _confirmDelete(context, place),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}