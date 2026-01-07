import '../repository/state_repo.dart';
import '../models/state_model.dart';

/// Controller layer (MVC)
/// Handles validation, authorization, and error handling
class StateController {
  final StateRepository _repository;

  StateController({StateRepository? repository})
      : _repository = repository ?? StateRepository();

  /* =========================
     READ (User & Admin)
     ========================= */

  /// Real-time stream of states
  Stream<List<StateModel>> getStates() {
    try {
      return _repository.streamStates();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch states once (non real-time)
  Future<List<StateModel>> fetchStates() async {
    try {
      return await _repository.getStatesOnce();
    } catch (e) {
      throw Exception('Failed to fetch states');
    }
  }

  /* =========================
     CREATE (Admin only)
     ========================= */

  Future<void> addState({
    required String name,
    required bool isAdmin,
  }) async {
    if (!isAdmin) {
      throw Exception('Unauthorized: Admin access required');
    }

    if (name.trim().isEmpty) {
      throw Exception('State name cannot be empty');
    }

    try {
      await _repository.addState(name.trim());
    } catch (e) {
      throw Exception('Failed to add state');
    }
  }

  /* =========================
     UPDATE (Admin only)
     ========================= */

  Future<void> updateState({
    required String id,
    required String name,
    required bool isAdmin,
  }) async {
    if (!isAdmin) {
      throw Exception('Unauthorized: Admin access required');
    }

    if (id.isEmpty || name.trim().isEmpty) {
      throw Exception('Invalid state data');
    }

    try {
      await _repository.updateState(id, name.trim());
    } catch (e) {
      throw Exception('Failed to update state');
    }
  }

  /* =========================
     DELETE (Admin only)
     ========================= */

  Future<void> deleteState({
    required String id,
    required bool isAdmin,
  }) async {
    if (!isAdmin) {
      throw Exception('Unauthorized: Admin access required');
    }

    if (id.isEmpty) {
      throw Exception('Invalid state ID');
    }

    try {
      await _repository.deleteState(id);
    } catch (e) {
      throw Exception('Failed to delete state');
    }
  }
}
