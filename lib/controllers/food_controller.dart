import '../models/food_model.dart';
import '../repository/food_repo.dart';

class FoodController {
  final FoodRepository _repository;

  // Constructor with optional repo injection
  FoodController({FoodRepository? repository})
      : _repository = repository ?? FoodRepository();

  // 1. Get Food List (Stream)
  Stream<List<FoodModel>> getFoodByState(String stateId) {
    if (stateId.isEmpty) return const Stream.empty();
    return _repository.streamFoodByState(stateId);
  }

  // 2. Add New Food
  Future<void> addFood({
    required String stateId,
    required String name,
    required String desc,
    required double price,
    required String image, // 1. Added image parameter
  }) async {
    // Basic validation
    if (stateId.isEmpty || name.trim().isEmpty) return;

    await _repository.addFood(
      stateId: stateId,
      name: name.trim(),
      desc: desc.trim(),
      price: price,
      image: image.trim(), // 2. Pass trimmed image string to repo
    );
  }

  // 3. Update Food
  Future<void> updateFood({
    required String stateId,
    required String foodId,
    required String name,
    required String desc,
    required double price,
    required String image, // 3. Added image parameter
  }) async {
    // Basic validation
    if (stateId.isEmpty || foodId.isEmpty || name.trim().isEmpty) return;

    await _repository.updateFood(
      stateId: stateId,
      foodId: foodId,
      name: name.trim(),
      desc: desc.trim(),
      price: price,
      image: image.trim(), // 4. Pass trimmed image string to repo
    );
  }

  // 4. Delete Food
  Future<void> deleteFood({
    required String stateId,
    required String foodId,
  }) async {
    if (stateId.isEmpty || foodId.isEmpty) return;

    await _repository.deleteFood(
      stateId: stateId,
      foodId: foodId,
    );
  }
}