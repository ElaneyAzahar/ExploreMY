//saved trips manage

class SavedTrip {
  final String id;
  final String stateName;
  final String category;
  final List<Map<String, dynamic>> items;
  final int numberOfPax;
  final double totalCost;
  final DateTime savedDate;

  SavedTrip({
    required this.id,
    required this.stateName,
    required this.category,
    required this.items,
    required this.numberOfPax,
    required this.totalCost,
    required this.savedDate,
  });

  // calculate subtotal per pax
  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + (item['price'] as double));
  }

  // date format
  String get formattedDate {
    return '${savedDate.day}/${savedDate.month}/${savedDate.year}';
  }
}

// store saved trip
class SavedTripsManager {
  static final List<SavedTrip> _trips = [];

  // add trip
  static void addTrip(SavedTrip trip) {
    _trips.add(trip);
  }

  //get trip
  static List<SavedTrip> getAllTrips() {
    return List.from(_trips); // Return a copy
  }

  //remove
  static void removeTrip(String tripId) {
    _trips.removeWhere((trip) => trip.id == tripId);
  }

  // clear
  static void clearAllTrips() {
    _trips.clear();
  }

  // trip count
  static int getTripCount() {
    return _trips.length;
  }
}
