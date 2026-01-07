import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/session_model.dart';

class SessionRepository {
  final FirebaseFirestore _db;

  SessionRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('Sessions');

  // 1. SAVE: Takes a list of items and total, creates a new document
  Future<void> createSession(List<SessionItem> items, double total) async {
    final newSession = SessionModel(
      id: '', // ID created by Firestore
      date: DateTime.now(),
      grandTotal: total,
      items: items,
    );

    await _col.add(newSession.toMap());
  }

  // 2. STREAM: Get history of sessions
  Stream<List<SessionModel>> streamSessionHistory() {
    return _col.orderBy('Date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return SessionModel.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }
  
  // 3. DELETE: Remove a session record
  Future<void> deleteSession(String id) async {
    await _col.doc(id).delete();
  }
}