class StateModel {
  final String id;
  final String name;

  StateModel({
    required this.id,
    required this.name,
  });

  // Factory constructor used to convert Firestore data into TourismState object
  factory StateModel.fromFirestore(String id, Map<String, dynamic> data) {
    return StateModel(
      id: id,
      name: (data['Name'] ?? '').toString(),
    );
  }
}
