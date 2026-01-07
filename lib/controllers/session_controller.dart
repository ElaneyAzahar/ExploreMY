import 'package:flutter/foundation.dart';
import '../repository/session_repo.dart';
import '../models/session_model.dart'; // Import the model file

class SessionController extends ChangeNotifier {
  // Dependency Injection for Repository
  final SessionRepository _repository;

  // Constructor allows injecting repo for testing, or uses default
  SessionController({SessionRepository? repository})
      : _repository = repository ?? SessionRepository();

  // --- Local State (The Cart) ---
  final List<SessionItem> _items = [];

  List<SessionItem> get items => List.unmodifiable(_items);

  double get sessionTotal =>
      _items.fold(0.0, (sum, item) => sum + item.total);

  // --- Cart Logic (Your existing logic) ---

  void setPlaceTickets({
    required String stateId,
    required String placeId,
    required String name,
    required double adultPrice,
    required double childPrice,
    required int adultQty,
    required int childQty,
  }) {
    final index = _items.indexWhere(
      (i) => i.stateId == stateId && i.placeId == placeId,
    );

    // If user set both to 0, remove from session
    if (adultQty <= 0 && childQty <= 0) {
      if (index != -1) {
        _items.removeAt(index);
        notifyListeners();
      }
      return;
    }

    final updated = SessionItem(
      stateId: stateId,
      placeId: placeId,
      name: name,
      adultPrice: adultPrice,
      childPrice: childPrice,
      adultQty: adultQty,
      childQty: childQty,
    );

    // Replace if exists, otherwise add
    if (index != -1) {
      _items[index] = updated;
    } else {
      _items.add(updated);
    }

    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearSession() {
    _items.clear();
    notifyListeners();
  }

  SessionItem? getItem(String stateId, String placeId) {
    try {
      return _items
          .firstWhere((i) => i.stateId == stateId && i.placeId == placeId);
    } catch (_) {
      return null;
    }
  }

  // --- Repository Interactions (Connecting to Firebase) ---

  // 1. Submit/Checkout: Saves current cart to Firebase
  Future<void> submitSession() async {
    if (_items.isEmpty) return;

    try {
      // Call repo to save to Cloud Firestore
      await _repository.createSession(_items, sessionTotal);
      
      // Clear local cart after successful save
      clearSession(); 
    } catch (e) {
      print("Error submitting session: $e");
      rethrow; // Let UI handle the error (e.g. show snackbar)
    }
  }

  // 2. Stream History: If you want to show previous orders in a list
  Stream<List<SessionModel>> getSessionHistory() {
    return _repository.streamSessionHistory();
  }
}