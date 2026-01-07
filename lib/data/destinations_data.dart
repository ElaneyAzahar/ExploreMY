//states data

class DestinationData {
  // place
  static Map<String, List<Map<String, dynamic>>> historicalPlaces = {
    'Melaka': [
      {'name': 'A Famosa', 'price': 0.0, 'description': 'Historic Portuguese fort'},
      {'name': 'Menara Taming Sari', 'price':26.0, 'description': 'Observation tower deck'},
      {'name': 'St. Paul\'s Hill', 'price': 0.0, 'description': 'Ruins of St. Paul\'s Church'},
      {'name': 'Malaysia Heritage Studios', 'price': 81.0, 'description': 'Magical Heritage Experience museum'},
      {'name': 'Baba & Nyonya Heritage Museum', 'price': 20.0, 'description': 'Peranakan culture museum'},
    ],
    'Penang': [
      {'name': 'Fort Cornwallis', 'price': 20.0, 'description': 'Historic British fort'},
      {'name': 'The TOP Penang', 'price': 70.0, 'description': 'Observation deck and skywalk'},
      {'name': 'Penang Hill', 'price': 30.0, 'description': 'Funicular railway to hilltop'},
      {'name': 'Kek Lok Si Temple', 'price': 0.0, 'description': 'Buddhist temple complex'},
      {'name': 'Sun Yat Sen Museum', 'price': 1.0, 'description': 'Museum with guided tour'},
    ],
    'Kuala Lumpur': [
      {'name': 'Petronas Twin Towers', 'price': 85.0, 'description': 'Skybridge and observation deck'},
      {'name': 'Batu Caves', 'price': 0.0, 'description': 'Hindu temple in limestone caves'},
      {'name': 'National Museum', 'price': 5.0, 'description': 'Malaysian history and culture'},
      {'name': 'Merdeka Square', 'price': 0.0, 'description': 'Historic independence square'},
    ],
    'Johor': [
      {'name': 'Sultan Abu Bakar State Mosque', 'price': 0.0, 'description': 'Victorian-style mosque'},
      {'name': 'Johor Old Chinese Temple', 'price': 0.0, 'description': 'Five deity temple'},
      {'name': 'Johor Bahru Old Court House', 'price': 0.0, 'description': 'Heritage building'},
      {'name': 'Istana Besar', 'price': 6.0, 'description': 'Royal museum'},
    ],
    'Kedah': [
      {'name': 'Alor Setar Tower', 'price': 15.0, 'description': 'Observation tower'},
      {'name': 'Zahir Mosque', 'price': 0.0, 'description': 'Beautiful state mosque'},
      {'name': 'Balai Besar', 'price': 0.0, 'description': 'Royal audience hall'},
      {'name': 'Kedah Paddy Museum', 'price': 5.0, 'description': 'Rice cultivation history'},
    ],
    'Kelantan': [
      {'name': 'Istana Jahar', 'price': 5.0, 'description': 'Royal museum'},
      {'name': 'Siti Khadijah Market', 'price': 0.0, 'description': 'Traditional market'},
      {'name': 'State Museum', 'price': 2.0, 'description': 'Cultural artifacts'},
    ],
    'Negeri Sembilan': [
      {'name': 'Istana Seri Menanti', 'price': 5.0, 'description': 'Royal museum'},
      {'name': 'State Museum', 'price': 2.0, 'description': 'Minangkabau architecture'},
    ],
    'Pahang': [
      {'name': 'Sultan Ahmad Shah State Mosque', 'price': 0.0, 'description': 'Modern mosque'},
      {'name': 'Clifford Pier', 'price': 0.0, 'description': 'Historic pier'},
    ],
    'Perak': [
      {'name': 'Kellie\'s Castle', 'price': 5.0, 'description': 'Unfinished mansion'},
      {'name': 'Ubudiah Mosque', 'price': 0.0, 'description': 'Royal mosque'},
      {'name': 'Perak Cave Temple', 'price': 0.0, 'description': 'Cave temple'},
    ],
    'Perlis': [
      {'name': 'Kota Kayang Museum', 'price': 2.0, 'description': 'State history'},
      {'name': 'Al-Hussain Mosque', 'price': 0.0, 'description': 'State mosque'},
    ],
    'Sabah': [
      {'name': 'Sabah State Museum', 'price': 15.0, 'description': 'Bornean culture'},
      {'name': 'Atkinson Clock Tower', 'price': 0.0, 'description': 'Oldest structure'},
      {'name': 'City Mosque', 'price': 0.0, 'description': 'Floating mosque'},
    ],
    'Sarawak': [
      {'name': 'Sarawak Museum', 'price': 0.0, 'description': 'One of the best in Southeast Asia'},
      {'name': 'Fort Margherita', 'price': 10.0, 'description': 'Historic fort'},
      {'name': 'Cat Museum', 'price': 0.0, 'description': 'Unique cat-themed museum'},
    ],
    'Selangor': [
      {'name': 'Sultan Salahuddin Abdul Aziz Mosque', 'price': 0.0, 'description': 'Blue Mosque'},
      {'name': 'i-City Shah Alam', 'price': 10.0, 'description': 'LED light park'},
      {'name': 'Batu Caves', 'price': 0.0, 'description': 'Hindu temple caves'},
    ],
    'Terengganu': [
      {'name': 'Crystal Mosque', 'price': 0.0, 'description': 'Modern glass mosque'},
      {'name': 'Terengganu State Museum', 'price': 5.0, 'description': 'Largest museum in Malaysia'},
      {'name': 'Chinatown Heritage', 'price': 0.0, 'description': 'Historic district'},
    ],
  };

  // Traditional Food for each state
  static Map<String, List<Map<String, dynamic>>> traditionalFood = {
    'Melaka': [
      {'name': 'Chicken Rice', 'price': 9.0, 'description': 'Chicken Rice served with soup and chili sauce'},
      {'name': 'Satay Celup', 'price': 25.0, 'description': 'Hot pot satay style'},
      {'name': 'Cendol', 'price': 5.0, 'description': 'Sweet iced dessert'},
      {'name': 'Nyonya Laksa', 'price': 15.0, 'description': 'Spicy coconut noodle soup'},
      {'name': 'Otak-Otak', 'price': 8.0, 'description': 'Spicy fish cake'},
    ],
    'Penang': [
      {'name': 'Char Kway Teow', 'price': 8.0, 'description': 'Stir-fried flat noodles'},
      {'name': 'Asam Laksa', 'price': 10.0, 'description': 'Sour fish-based noodle soup'},
      {'name': 'Nasi Kandar', 'price': 15.0, 'description': 'Rice with various curries'},
      {'name': 'Hokkien Mee', 'price': 9.0, 'description': 'Prawn noodle soup'},
    ],
    'Kuala Lumpur': [
      {'name': 'Nasi Lemak', 'price': 8.0, 'description': 'Coconut rice with sambal'},
      {'name': 'Bak Kut Teh', 'price': 18.0, 'description': 'Pork rib soup'},
      {'name': 'Roti Canai', 'price': 3.0, 'description': 'Flaky flatbread with curry'},
      {'name': 'Hokkien Mee (KL style)', 'price': 12.0, 'description': 'Dark soy noodles'},
    ],
    'Johor': [
      {'name': 'Laksa Johor', 'price': 10.0, 'description': 'Spaghetti-style laksa'},
      {'name': 'Mee Rebus', 'price': 8.0, 'description': 'Noodles in sweet potato gravy'},
      {'name': 'Otak-Otak Johor', 'price': 6.0, 'description': 'Grilled fish paste'},
    ],
    'Kedah': [
      {'name': 'Nasi Ulam', 'price': 10.0, 'description': 'Herb rice salad'},
      {'name': 'Laksa Kedah', 'price': 9.0, 'description': 'Mackerel-based laksa'},
      {'name': 'Rendang Daging', 'price': 15.0, 'description': 'Slow-cooked beef curry'},
      {'name': 'Jeruk Maman', 'price': 5.0, 'description': 'Pickled fruits'},
    ],
    'Kelantan': [
      {'name': 'Nasi Kerabu', 'price': 12.0, 'description': 'Blue rice with herbs'},
      {'name': 'Ayam Percik', 'price': 18.0, 'description': 'Grilled spiced chicken'},
      {'name': 'Nasi Dagang', 'price': 10.0, 'description': 'Rice with tuna curry'},
      {'name': 'Akok', 'price': 4.0, 'description': 'Traditional cake'},
    ],
    'Negeri Sembilan': [
      {'name': 'Rendang Minang', 'price': 20.0, 'description': 'Minangkabau-style rendang'},
      {'name': 'Masak Lemak Cili Api', 'price': 15.0, 'description': 'Creamy chili dish'},
      {'name': 'Sambal Tempoyak', 'price': 8.0, 'description': 'Fermented durian sambal'},
    ],
    'Pahang': [
      {'name': 'Patin Tempoyak', 'price': 25.0, 'description': 'Fish with fermented durian'},
      {'name': 'Gulai Ikan Patin', 'price': 22.0, 'description': 'Fish curry'},
      {'name': 'Sata', 'price': 6.0, 'description': 'Grilled fish parcels'},
    ],
    'Perak': [
      {'name': 'Ipoh Hor Fun', 'price': 8.0, 'description': 'Silky smooth noodles'},
      {'name': 'Tau Fu Fah', 'price': 3.0, 'description': 'Silky tofu pudding'},
      {'name': 'Ipoh White Coffee', 'price': 4.0, 'description': 'Famous coffee'},
    ],
    'Perlis': [
      {'name': 'Laksa Perlis', 'price': 8.0, 'description': 'Northern-style laksa'},
      {'name': 'Jeruk', 'price': 5.0, 'description': 'Pickled fruits'},
    ],
    'Sabah': [
      {'name': 'Tuaran Mee', 'price': 12.0, 'description': 'Egg noodles'},
      {'name': 'Ngiu Chap', 'price': 15.0, 'description': 'Mixed beef soup'},
      {'name': 'Amplang', 'price': 10.0, 'description': 'Fish crackers'},
    ],
    'Sarawak': [
      {'name': 'Sarawak Laksa', 'price': 10.0, 'description': 'Curry paste laksa'},
      {'name': 'Kolo Mee', 'price': 8.0, 'description': 'Springy noodles'},
    ],
    'Selangor': [
      {'name': 'Nasi Lemak', 'price': 8.0, 'description': 'Coconut rice'},
      {'name': 'Satay Kajang', 'price': 20.0, 'description': 'Grilled meat skewers'},
      {'name': 'Roti Canai', 'price': 3.0, 'description': 'Flaky flatbread'},
    ],
    'Terengganu': [
      {'name': 'Nasi Dagang', 'price': 12.0, 'description': 'Rice with tuna curry'},
      {'name': 'Keropok Lekor', 'price': 6.0, 'description': 'Fish sausage crackers'},
      {'name': 'Satar', 'price': 8.0, 'description': 'Grilled fish cake'},
      {'name': 'Otak-Otak', 'price': 7.0, 'description': 'Spicy fish paste'},
    ],
  };

  // Get historical places for a state
  static List<Map<String, dynamic>> getHistoricalPlaces(String state) {
    return historicalPlaces[state] ?? [
      {'name': 'Coming Soon', 'price': 0.0, 'description': 'More places will be added'},
    ];
  }

  // Get traditional food for a state
  static List<Map<String, dynamic>> getTraditionalFood(String state) {
    return traditionalFood[state] ?? [
      {'name': 'Coming Soon', 'price': 0.0, 'description': 'More food will be added'},
    ];
  }
}

// featured destination
class FeaturedDestination {
  final String title;
  final String description;
  final String state;
  //final String imagePath; 

  FeaturedDestination({
    required this.title,
    required this.description,
    required this.state,
    //this.imagePath = 'assets/images/featured/Penang.jpg',
  });
}

// list of destinations
final List<FeaturedDestination> featuredDestinations = [
  FeaturedDestination(
    title: 'Penang Heritage Trail',
    description: 'Explore UNESCO World Heritage Sites',
    state: 'Penang',
  ),
  FeaturedDestination(
    title: 'Melaka Historical City',
    description: 'Walk through centuries of history',
    state: 'Melaka',
  ),
  FeaturedDestination(
    title: 'Kuala Lumpur City Tour',
    description: 'Modern meets traditional',
    state: 'Kuala Lumpur',
  ),
  FeaturedDestination(
    title: 'Sarawak Cultural Experience',
    description: 'Discover Borneo\'s indigenous culture',
    state: 'Sarawak',
  ),
  FeaturedDestination(
    title: 'Ipoh Heritage & Food Tour',
    description: 'Colonial architecture and famous cuisine',
    state: 'Perak',
  ),
];