class PlaceModel {
  final String id;
  final String stateId;
  final String name;
  final String desc;
  final double adultPrice;
  final double childPrice;
  // ✅ 1. Add field definition
  final String image;

  PlaceModel({
    required this.id,
    required this.stateId,
    required this.name,
    required this.desc,
    required this.adultPrice,
    required this.childPrice,
    // ✅ 2. Add to constructor
    required this.image,
  });

  factory PlaceModel.fromFirestore({
    required String id,
    required String stateId,
    required Map<String, dynamic> data,
  }) {
    return PlaceModel(
      id: id,
      stateId: stateId,
      name: (data['Name'] ?? '').toString(),
      desc: (data['Description'] ?? '').toString(),
      adultPrice: (data['AdultPrice'] ?? 0).toDouble(),
      childPrice: (data['ChildPrice'] ?? 0).toDouble(),
      // ✅ 3. Extract from Firestore (assumes database field is named 'Image')
      image: (data['Image'] ?? '').toString(),
    );
  }
}