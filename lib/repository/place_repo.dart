import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place_model.dart';

class PlaceRepository {
  final FirebaseFirestore _db;

  PlaceRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  // /State/{stateId}/Place
  Stream<List<PlaceModel>> streamPlacesByState(String stateId) {
    return _db
        .collection('State')
        .doc(stateId)
        .collection('Place')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PlaceModel.fromFirestore(
          id: doc.id,
          stateId: stateId,
          data: doc.data(),
        );
      }).toList();
    });
  }

  Stream<PlaceModel> streamPlaceById(String stateId, String placeId) {
    return _db
        .collection('State')
        .doc(stateId)
        .collection('Place')
        .doc(placeId)
        .snapshots()
        .map((doc) {
      final data = doc.data();
      if (data == null) {
        throw Exception('Place not found');
      }

      return PlaceModel.fromFirestore(
        id: doc.id,
        stateId: stateId,
        data: data,
      );
    });
  }

  Future<List<PlaceModel>> getPlacesOnce(String stateId) async {
    final snapshot = await _db
        .collection('State')
        .doc(stateId)
        .collection('Place')
        .get();

    return snapshot.docs.map((doc) {
      return PlaceModel.fromFirestore(
        id: doc.id,
        stateId: stateId,
        data: doc.data(),
      );
    }).toList();
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
    await _db
        .collection('State')
        .doc(stateId)
        .collection('Place')
        .add({
      'Name': name,
      'AdultPrice': adultPrice,
      'ChildPrice': childPrice,
      'Description': desc,
      'Image': image, // Save to Firestore
    });
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
    await _db
        .collection('State')
        .doc(stateId)
        .collection('Place')
        .doc(placeId)
        .update({
      'Name': name,
      'AdultPrice': adultPrice,
      'ChildPrice': childPrice,
      'Description': desc,
      'Image': image, // Update in Firestore
    });
  }

  Future<void> deletePlace({
    required String stateId,
    required String placeId,
  }) async {
    await _db
        .collection('State')
        .doc(stateId)
        .collection('Place')
        .doc(placeId)
        .delete();
  }
}