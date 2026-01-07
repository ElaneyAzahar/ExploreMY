import 'package:cloud_firestore/cloud_firestore.dart';
// Provides access to Cloud Firestore

import '../models/state_model.dart';
// Model class that represents one State record

class StateRepository {
  // Holds the Firestore instance
  // Using dependency injection allows easier testing and reuse
  final FirebaseFirestore _db;

  // Constructor
  // If no Firestore instance is passed, use the default one
  StateRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  // Reference to the Firestore collection
  // The collection name must match Firestore exactly
  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('State');

  // Returns a stream of StateModel list
  // This listens to real-time updates from Firestore
  Stream<List<StateModel>> streamStates() {
    return _col.snapshots().map((snapshot) {
      // Convert each Firestore document into a StateModel
      return snapshot.docs.map((doc) {
        return StateModel.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }

  // Fetches all State records once (not real-time)
  // Useful for one-time loading such as dropdowns
  Future<List<StateModel>> getStatesOnce() async {
    final snapshot = await _col.get();

    // Convert Firestore documents into a list of models
    return snapshot.docs.map((doc) {
      return StateModel.fromFirestore(doc.id, doc.data());
    }).toList();
  }

  // Adds a new State document to Firestore
  // "Name" field must match the Firestore field name exactly
  Future<void> addState(String name) async {
    await _col.add({'Name': name});
  }

  // Updates the "Name" field of an existing State document
  // Requires the document ID
  Future<void> updateState(String id, String name) async {
    await _col.doc(id).update({'Name': name});
  }

  // Deletes a State document from Firestore
  // Requires the document ID
  Future<void> deleteState(String id) async {
    await _col.doc(id).delete();
  }
}
