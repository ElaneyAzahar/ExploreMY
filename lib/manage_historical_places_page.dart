import 'package:flutter/material.dart';
import '../controllers/state_controller.dart';
import '../controllers/place_controller.dart';
import '../models/state_model.dart';
import '../models/place_model.dart';
import 'admin_dashboard_page.dart';

class ManagePlacePage extends StatefulWidget {
  const ManagePlacePage({Key? key}) : super(key: key);

  @override
  State<ManagePlacePage> createState() => _ManagePlacePageState();
}

class _ManagePlacePageState extends State<ManagePlacePage> {
  // Logic: Controllers & State
  final StateController _stateController = StateController();
  final PlaceController _placeController = PlaceController();

  String? _selectedStateId;
  String? _selectedStateName;
  bool isStateSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isStateSelected ? Colors.grey.shade50 : null,
      appBar: AppBar(
        title: Text(
          isStateSelected ? 'Places in $_selectedStateName' : 'Select State',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: isStateSelected
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => isStateSelected = false))
            : null,
      ),
      body: isStateSelected ? _buildManagementView() : _buildSelectionView(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- VIEW 1: SELECTION SCREEN (Dynamic from DB) ---
  Widget _buildSelectionView() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.red.shade400, Colors.red.shade700],
        ),
      ),
      child: StreamBuilder<List<StateModel>>(
        stream: _stateController.getStates(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          final states = snapshot.data!;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.map, size: 80, color: Colors.white54),
              const SizedBox(height: 20),
              const Text('Choose a location to manage',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 40),
              ...states.map((state) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildStateBtn(state.id, state.name, Icons.location_on),
                  )),
            ],
          );
        },
      ),
    );
  }

  // --- VIEW 2: MANAGEMENT VIEW ---
  Widget _buildManagementView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Managing: $_selectedStateName',
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              ElevatedButton.icon(
                onPressed: () => _showPlaceDialog(context, null),
                icon: const Icon(Icons.add),
                label: const Text('ADD PLACE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<PlaceModel>>(
            stream: _placeController.getPlacesByState(_selectedStateId!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final places = snapshot.data ?? [];

              if (places.isEmpty) {
                return const Center(
                    child: Text("No places found. Click 'ADD PLACE'."));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: places.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) => _buildGridCard(places[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- UI COMPONENTS ---
  Widget _buildStateBtn(String id, String name, IconData icon) {
    return SizedBox(
      width: 280,
      height: 70,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.red),
        label: Text(name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 8,
        ),
        onPressed: () => setState(() {
          _selectedStateId = id;
          _selectedStateName = name;
          isStateSelected = true;
        }),
      ),
    );
  }

  Widget _buildGridCard(PlaceModel place) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: place.image.isNotEmpty
                  ? Image.network(place.image,
                      fit: BoxFit.cover, width: double.infinity)
                  : Container(
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.image, color: Colors.grey)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(place.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
                Text('RM ${place.adultPrice}',
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => _showPlaceDialog(context, place),
                      child: const Icon(Icons.edit, color: Colors.blue, size: 20),
                    ),
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: () => _confirmDelete(place.id),
                      child: const Icon(Icons.delete, color: Colors.red, size: 20),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- DIALOGS (Styled) ---
  void _showPlaceDialog(BuildContext context, PlaceModel? place) {
    final isEditing = place != null;
    final nameController = TextEditingController(text: place?.name ?? '');
    final adultPriceController = TextEditingController(text: place?.adultPrice.toString() ?? '');
    final childPriceController = TextEditingController(text: place?.childPrice.toString() ?? '');
    final descController = TextEditingController(text: place?.desc ?? '');
    final imageController = TextEditingController(text: place?.image ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isEditing ? 'Edit Details' : 'Add New Place',
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPopupField(nameController, 'Place Name', Icons.map),
              const SizedBox(height: 12),
              _buildPopupField(adultPriceController, 'Adult Price (RM)', Icons.payments),
              const SizedBox(height: 12),
              _buildPopupField(childPriceController, 'Child Price (RM)', Icons.child_care),
              const SizedBox(height: 12),
              _buildPopupField(imageController, 'Image URL', Icons.image),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              if (isEditing) {
                await _placeController.updatePlace(
                  stateId: _selectedStateId!,
                  placeId: place.id,
                  name: nameController.text.trim(),
                  adultPrice: num.parse(adultPriceController.text),
                  childPrice: num.parse(childPriceController.text),
                  desc: descController.text.trim(),
                  image: imageController.text.trim(),
                );
              } else {
                await _placeController.addPlace(
                  stateId: _selectedStateId!,
                  name: nameController.text.trim(),
                  adultPrice: num.parse(adultPriceController.text),
                  childPrice: num.parse(childPriceController.text),
                  desc: descController.text.trim(),
                  image: imageController.text.trim(),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String placeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Confirm Delete', style: TextStyle(color: Colors.red)),
        content: const Text('Remove this place permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _placeController.deletePlace(
                  stateId: _selectedStateId!, placeId: placeId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupField(TextEditingController ctrl, String label, IconData icon) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      color: Colors.white,
      elevation: 10,
      child: InkWell(
        onTap: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const AdminDashboardPage())),
        child: const SizedBox(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dashboard, color: Colors.red),
              Text('Dashboard',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}