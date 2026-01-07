import 'package:tourismapp/repository/place_repo.dart';
import '../models/place_model.dart';

class PlaceController {
  final PlaceRepository _repository = PlaceRepository();

  // Stream of places for a specific state
  Stream<List<PlaceModel>> getPlacesByState(String stateId) {
    return _repository.streamPlacesByState(stateId);
  }

  // ✅ NEW METHOD: Add this to get a single place
  Stream<PlaceModel> getPlaceById(String stateId, String placeId) {
    return _repository.streamPlaceById(stateId, placeId);
  }

  // ✅ Added 'image' parameter
  Future<void> addPlace({
    required String stateId,
    required String name,
    required num adultPrice,
    required num childPrice,
    required String desc,
    required String image, // New
  }) async {
    await _repository.addPlace(
      stateId: stateId,
      name: name,
      adultPrice: adultPrice,
      childPrice: childPrice,
      desc: desc,
      image: image, // Pass to Repo
    );
  }

  // ✅ Added 'image' parameter
  Future<void> updatePlace({
    required String stateId,
    required String placeId,
    required String name,
    required num adultPrice,
    required num childPrice,
    required String desc,
    required String image, // New
  }) async {
    await _repository.updatePlace(
      stateId: stateId,
      placeId: placeId,
      name: name,
      adultPrice: adultPrice,
      childPrice: childPrice,
      desc: desc,
      image: image, // Pass to Repo
    );
  }

  Future<void> deletePlace({
    required String stateId,
    required String placeId,
  }) async {
    await _repository.deletePlace(stateId: stateId, placeId: placeId);
  }
}