import 'package:flutter/material.dart';
import 'package:tourismapp/selectitempage.dart';
import '../controllers/food_controller.dart';
import '../models/food_model.dart';

class FoodListPage extends StatelessWidget {
  final String stateId;
  final String stateName;
  final bool isAdmin;

  FoodListPage({
    super.key,
    required this.stateId,
    required this.stateName,
    required this.isAdmin,
  });

  final FoodController controller = FoodController();

  // ✅ Updated Dialog: Added Image URL Input
  Future<void> _showFoodDialog(
    BuildContext context, {
    required bool isEdit,
    FoodModel? food,
  }) async {
    final nameCtrl = TextEditingController(text: food?.name ?? '');
    final priceCtrl = TextEditingController(text: food?.price.toString() ?? '');
    final descCtrl = TextEditingController(text: food?.desc ?? '');
    // ✅ 1. Controller for Image URL
    final imageCtrl = TextEditingController(text: food?.image ?? '');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Food' : 'Add Food'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Name Input ---
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Food Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fastfood),
                ),
              ),
              const SizedBox(height: 12),

              // --- Price Input ---
              TextField(
                controller: priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Price (RM)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 12),

              // --- Description Input ---
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
                  hintText: 'https://example.com/food.jpg',
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
              final price = double.tryParse(priceCtrl.text.trim());
              final imageUrl = imageCtrl.text.trim(); // ✅ Get URL text

              if (name.isEmpty || price == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter name and valid price')),
                );
                return;
              }

              // ✅ Pass imageUrl to Controller methods
              if (isEdit) {
                await controller.updateFood(
                  stateId: stateId,
                  foodId: food!.id,
                  name: name,
                  desc: desc,
                  price: price,
                  image: imageUrl, 
                );
              } else {
                await controller.addFood(
                  stateId: stateId,
                  name: name,
                  desc: desc,
                  price: price,
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

  Future<void> _confirmDelete(BuildContext context, FoodModel food) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Item?'),
        content: Text('Delete "${food.name}" from the menu?'),
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
      await controller.deleteFood(stateId: stateId, foodId: food.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food in $stateName'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => _showFoodDialog(context, isEdit: false),
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
                  'Local Delicacies',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<FoodModel>>(
              stream: controller.getFoodByState(stateId),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text('Error loading food'));
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final foodList = snapshot.data!;
                if (foodList.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.no_meals, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text('No food items found'),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: foodList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final food = foodList[index];

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
                                itemId: food.id,
                                category: ItemCategory.food,
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
                                  color: Colors.orange.shade100,
                                  child: (food.image.isNotEmpty)
                                      ? Image.network(
                                          food.image,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            // Show icon if image fails to load
                                            return Icon(
                                              Icons.restaurant_menu,
                                              color: Colors.orange.shade800,
                                              size: 30,
                                            );
                                          },
                                        )
                                      : Icon(
                                          Icons.restaurant_menu,
                                          color: Colors.orange.shade800,
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
                                      food.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'RM ${food.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
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
                                      onPressed: () => _showFoodDialog(
                                        context,
                                        isEdit: true,
                                        food: food,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _confirmDelete(context, food),
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