import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_model.dart';

class FoodRepository {
  final FirebaseFirestore _db;

  // Dependency injection for testability
  FoodRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  // Helper to access the sub-collection reference
  CollectionReference<Map<String, dynamic>> _getFoodCollection(String stateId) {
    return _db.collection('State').doc(stateId).collection('Food');
  }

  // STREAM: Real-time list of food for a specific state
  Stream<List<FoodModel>> streamFoodByState(String stateId) {
    return _getFoodCollection(stateId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return FoodModel.fromFirestore(
          id: doc.id,
          stateId: stateId,
          data: doc.data(),
        );
      }).toList();
    });
  }

  // FUTURE: One-time fetch (good for dropdowns or static lists)
  Future<List<FoodModel>> getFoodOnce(String stateId) async {
    final snapshot = await _getFoodCollection(stateId).get();
    return snapshot.docs.map((doc) {
      return FoodModel.fromFirestore(
        id: doc.id,
        stateId: stateId,
        data: doc.data(),
      );
    }).toList();
  }

  // ADD: Create a new food item
  Future<void> addFood({
    required String stateId,
    required String name,
    required String desc,
    required double price,
    required String image, // 1. Added image argument
  }) async {
    await _getFoodCollection(stateId).add({
      'Name': name,
      'Description': desc,
      'Price': price,
      'Image': image, // 2. Save image to Firestore
    });
  }

  // UPDATE: Edit an existing food item
  Future<void> updateFood({
    required String stateId,
    required String foodId,
    required String name,
    required String desc,
    required double price,
    required String image, // 3. Added image argument
  }) async {
    await _getFoodCollection(stateId).doc(foodId).update({
      'Name': name,
      'Description': desc,
      'Price': price,
      'Image': image, // 4. Update image in Firestore
    });
  }

  // DELETE: Remove a food item
  Future<void> deleteFood({
    required String stateId,
    required String foodId,
  }) async {
    await _getFoodCollection(stateId).doc(foodId).delete();
  }
}