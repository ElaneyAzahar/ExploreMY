import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourismapp/sessionpage.dart';
import '../controllers/place_controller.dart';
import '../controllers/food_controller.dart';
import '../controllers/session_controller.dart';
import '../models/place_model.dart';
import '../models/food_model.dart';
import 'itemcounter.dart';

enum ItemCategory { place, food }

class SelectitemPage extends StatefulWidget {
  final String stateId;
  final String itemId;
  final ItemCategory category;

  const SelectitemPage({
    super.key,
    required this.stateId,
    required this.itemId,
    required this.category,
  });

  @override
  State<SelectitemPage> createState() => _SelectitemPageState();
}

class _SelectitemPageState extends State<SelectitemPage> {
  final PlaceController _placeController = PlaceController();
  final FoodController _foodController = FoodController();

  int qty1 = 0;
  int qty2 = 0;
  double total = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category == ItemCategory.food ? 'Food Details' : 'Place Details',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade400, Colors.red.shade700],
          ),
        ),
        child: widget.category == ItemCategory.place
            ? _buildPlaceStream()
            : _buildFoodStream(),
      ),
    );
  }

  // --- STREAM BUILDERS ---

  Widget _buildPlaceStream() {
    return StreamBuilder<PlaceModel>(
      stream: _placeController.getPlaceById(widget.stateId, widget.itemId),      
      builder: (context, snapshot) {
        if (snapshot.hasError) return _buildStatusMessage('Error loading place');
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.white));

        final place = snapshot.data!;
        final session = context.watch<SessionController>();
        final existing = session.getItem(widget.stateId, place.id);

        return _buildDetailsCard(
          name: place.name,
          desc: place.desc,
          imageUrl: place.image, // ✅ Pass Place Image
          price1: place.adultPrice,
          price2: place.childPrice,
          label1: 'Adult Price',
          label2: 'Child Price',
          initialQty1: existing?.adultQty ?? 0,
          initialQty2: existing?.childQty ?? 0,
          onSave: () => _handleSavePlace(place),
        );
      },
    );
  }

  Widget _buildFoodStream() {
    return StreamBuilder<List<FoodModel>>(
      stream: _foodController.getFoodByState(widget.stateId),
      builder: (context, snapshot) {
        if (snapshot.hasError) return _buildStatusMessage('Error loading food');
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.white));

        FoodModel? food;
        try {
          food = snapshot.data!.firstWhere((f) => f.id == widget.itemId);
        } catch (e) {
          return _buildStatusMessage('Item not found');
        }

        final session = context.watch<SessionController>();
        final existing = session.getItem(widget.stateId, food.id);

        return _buildDetailsCard(
          name: food.name,
          desc: food.desc,
          imageUrl: food.image, // ✅ Pass Food Image (Ensure FoodModel has this field, or use 'food.image')
          price1: food.price,
          price2: null,
          label1: 'Price',
          label2: null,
          initialQty1: existing?.adultQty ?? 0,
          initialQty2: 0,
          onSave: () => _handleSaveFood(food!),
        );
      },
    );
  }

  // --- UNIFIED UI CARD ---

  Widget _buildDetailsCard({
    required String name,
    required String desc,
    required String? imageUrl, // ✅ Receive Image URL
    required double price1,
    required double? price2,
    required String label1,
    required String? label2,
    required int initialQty1,
    required int initialQty2,
    required VoidCallback onSave,
  }) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ 1. Image Logic: Show Image if available, else show Icon
              if (imageUrl != null && imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if URL is bad
                      return _buildFallbackIcon(); 
                    },
                  ),
                )
              else
                _buildFallbackIcon(),

              const SizedBox(height: 16),
              
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const Divider(height: 40),

              // Dynamic Price Rows
              _buildPriceRow(label1, price1),
              if (price2 != null && label2 != null) 
                _buildPriceRow(label2, price2),

              const SizedBox(height: 24),

              ItemCounter(
                adultPrice: price1,
                childPrice: price2 ?? 0,
                initialAdultQty: initialQty1,
                initialKidsQty: initialQty2,
                onChanged: (q1, q2, t) {
                  setState(() {
                    qty1 = q1;
                    qty2 = q2;
                    total = t;
                  });
                },
              ),

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: (qty1 == 0 && qty2 == 0) ? null : onSave,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text(
                    'ADD TO BUDGET',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Helper for Fallback Icon
  Widget _buildFallbackIcon() {
    return Icon(
      widget.category == ItemCategory.food ? Icons.restaurant : Icons.stars,
      color: Colors.red.shade700,
      size: 50,
    );
  }

  Widget _buildPriceRow(String label, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text('RM ${price.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildStatusMessage(String msg) {
    return Center(
        child: Text(msg,
            style: const TextStyle(color: Colors.white, fontSize: 18)));
  }

  // --- SAVE HANDLERS ---

  void _handleSavePlace(PlaceModel place) {
    context.read<SessionController>().setPlaceTickets(
          stateId: widget.stateId,
          placeId: place.id,
          name: place.name,
          adultPrice: place.adultPrice,
          childPrice: place.childPrice,
          adultQty: qty1,
          childQty: qty2,
        );
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const SessionPage()));
  }

  void _handleSaveFood(FoodModel food) {
    context.read<SessionController>().setPlaceTickets(
          stateId: widget.stateId,
          placeId: food.id,
          name: food.name,
          adultPrice: food.price,
          childPrice: 0.0,
          adultQty: qty1,
          childQty: 0,
        );
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const SessionPage()));
  }
}