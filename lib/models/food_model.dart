class FoodModel {
  final String id;
  final String stateId;
  final String name;
  final String desc;
  final double price;
  final String image; // 1. Added property

  FoodModel({
    required this.id,
    required this.stateId,
    required this.name,
    required this.desc,
    required this.price,
    required this.image, // 2. Added to constructor
  });

  factory FoodModel.fromFirestore({
    required String id,
    required String stateId,
    required Map<String, dynamic> data,
  }) {
    return FoodModel(
      id: id,
      stateId: stateId,
      name: data['Name'] ?? '',
      desc: data['Description'] ?? '',
      // Safe double conversion
      price: double.tryParse(data['Price'].toString()) ?? 0.0,
      // 3. Extract Image URL safely
      image: data['Image'] ?? '', 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Description': desc,
      'Price': price,
      'Image': image, // 4. Add to Map
    };
  }
}