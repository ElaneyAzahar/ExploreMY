import 'package:cloud_firestore/cloud_firestore.dart';

// 1. The main "Receipt" or "Order"
class SessionModel {
  final String id;
  final DateTime date;
  final double grandTotal;
  final List<SessionItem> items;

  SessionModel({
    required this.id,
    required this.date,
    required this.grandTotal,
    required this.items,
  });

  // Convert from Firestore
  factory SessionModel.fromFirestore(String id, Map<String, dynamic> data) {
    return SessionModel(
      id: id,
      date: (data['Date'] as Timestamp).toDate(),
      grandTotal: (data['GrandTotal'] ?? 0.0).toDouble(),
      items: (data['Items'] as List<dynamic>?)
              ?.map((item) => SessionItem.fromMap(item))
              .toList() ??
          [],
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'Date': Timestamp.fromDate(date),
      'GrandTotal': grandTotal,
      'Items': items.map((i) => i.toMap()).toList(),
    };
  }
}

// 2. The individual line items (Your existing class + serialization)
class SessionItem {
  final String stateId;
  final String placeId;
  final String name;
  final double adultPrice;
  final double childPrice;
  final int adultQty;
  final int childQty;

  SessionItem({
    required this.stateId,
    required this.placeId,
    required this.name,
    required this.adultPrice,
    required this.childPrice,
    required this.adultQty,
    required this.childQty,
  });

  double get total => (adultQty * adultPrice) + (childQty * childPrice);

  // Convert to Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'StateId': stateId,
      'PlaceId': placeId,
      'Name': name,
      'AdultPrice': adultPrice,
      'ChildPrice': childPrice,
      'AdultQty': adultQty,
      'ChildQty': childQty,
      'Total': total, // Optional: saving calculated total for easier querying later
    };
  }

  // Convert from Map (if you load history later)
  factory SessionItem.fromMap(Map<String, dynamic> data) {
    return SessionItem(
      stateId: data['StateId'] ?? '',
      placeId: data['PlaceId'] ?? '',
      name: data['Name'] ?? '',
      adultPrice: (data['AdultPrice'] ?? 0).toDouble(),
      childPrice: (data['ChildPrice'] ?? 0).toDouble(),
      adultQty: data['AdultQty'] ?? 0,
      childQty: data['ChildQty'] ?? 0,
    );
  }
}