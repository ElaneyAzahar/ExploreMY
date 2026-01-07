import 'package:flutter/material.dart';
import '../controllers/state_controller.dart';
import '../controllers/food_controller.dart';
import '../models/state_model.dart';
import '../models/food_model.dart';
import 'admin_dashboard_page.dart';

class ManageTraditionalFoodPage extends StatefulWidget {
  const ManageTraditionalFoodPage({Key? key}) : super(key: key);

  @override
  State<ManageTraditionalFoodPage> createState() => _ManageTraditionalFoodPageState();
}

class _ManageTraditionalFoodPageState extends State<ManageTraditionalFoodPage> {
  // Logic: Controllers
  final StateController _stateController = StateController();
  final FoodController _foodController = FoodController();

  // State Variables
  String? _selectedStateId;
  String? _selectedStateName;
  bool isStateSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isStateSelected ? Colors.grey.shade50 : null,
      appBar: AppBar(
        title: Text(
          isStateSelected ? 'Food in $_selectedStateName' : 'Select State',
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

  // --- VIEW 1: SELECTION SCREEN (Red Gradient) ---
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
              const Icon(Icons.restaurant_menu, size: 80, color: Colors.white54),
              const SizedBox(height: 20),
              const Text('Select State to Manage Menu',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 40),
              // Limit height to prevent overflow if many states
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  itemCount: states.length,
                  itemBuilder: (context, index) {
                    final state = states[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildStateBtn(state.id, state.name, Icons.location_on),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- VIEW 2: MANAGEMENT VIEW (White Grid) ---
  Widget _buildManagementView() {
    return Column(
      children: [
        // Red Header
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
              Text('Menu: $_selectedStateName',
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              ElevatedButton.icon(
                onPressed: () => _showFoodDialog(context, null),
                icon: const Icon(Icons.add),
                label: const Text('ADD FOOD'),
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
        
        // Grid List
        Expanded(
          child: StreamBuilder<List<FoodModel>>(
            stream: _foodController.getFoodByState(_selectedStateId!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final foods = snapshot.data ?? [];

              if (foods.isEmpty) {
                return const Center(
                    child: Text("No food items found. Click 'ADD FOOD'."));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: foods.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) => _buildGridCard(foods[index]),
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
      height: 60,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.red),
        label: Text(name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
        ),
        onPressed: () => setState(() {
          _selectedStateId = id;
          _selectedStateName = name;
          isStateSelected = true;
        }),
      ),
    );
  }

  Widget _buildGridCard(FoodModel food) {
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
              child: food.image.isNotEmpty
                  ? Image.network(food.image,
                      fit: BoxFit.cover, width: double.infinity)
                  : Container(
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.fastfood, color: Colors.grey)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
                Text('RM ${food.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => _showFoodDialog(context, food),
                      child: const Icon(Icons.edit, color: Colors.blue, size: 20),
                    ),
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: () => _confirmDelete(food.id),
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

  // --- DIALOGS ---
  void _showFoodDialog(BuildContext context, FoodModel? food) {
    final isEditing = food != null;
    final nameCtrl = TextEditingController(text: food?.name ?? '');
    final priceCtrl = TextEditingController(text: food?.price.toString() ?? '');
    final descCtrl = TextEditingController(text: food?.desc ?? '');
    final imgCtrl = TextEditingController(text: food?.image ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isEditing ? 'Edit Food' : 'Add New Food',
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPopupField(nameCtrl, 'Food Name', Icons.restaurant_menu),
              const SizedBox(height: 12),
              _buildPopupField(priceCtrl, 'Price (RM)', Icons.attach_money, isNumber: true),
              const SizedBox(height: 12),
              _buildPopupField(descCtrl, 'Description', Icons.description),
              const SizedBox(height: 12),
              _buildPopupField(imgCtrl, 'Image URL', Icons.image),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                final double price = double.parse(priceCtrl.text);

                if (isEditing) {
                  await _foodController.updateFood(
                    stateId: _selectedStateId!,
                    foodId: food.id,
                    name: nameCtrl.text.trim(),
                    desc: descCtrl.text.trim(),
                    price: price,
                    image: imgCtrl.text.trim(),
                  );
                } else {
                  await _foodController.addFood(
                    stateId: _selectedStateId!,
                    name: nameCtrl.text.trim(),
                    desc: descCtrl.text.trim(),
                    price: price,
                    image: imgCtrl.text.trim(),
                  );
                }
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid price format')),
                );
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String foodId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Confirm Delete', style: TextStyle(color: Colors.red)),
        content: const Text('Remove this food item permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _foodController.deleteFood(
                  stateId: _selectedStateId!, foodId: foodId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupField(TextEditingController ctrl, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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