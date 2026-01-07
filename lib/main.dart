import 'package:firebase_core/firebase_core.dart'; // Firebase initialization
import 'package:flutter/material.dart'; // Flutter UI framework
import 'package:provider/provider.dart'; // State management with Provider
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore database
import 'package:tourismapp/homepage.dart'; // Home page
import 'package:tourismapp/loginpage.dart'; // Login page
import '../controllers/session_controller.dart'; // Session controller for state management
import 'package:tourismapp/splash_screen.dart'; // Splash screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure proper binding of widgets before initialization
  await Firebase.initializeApp(); // Initialize Firebase

  // ❌ REMOVE THIS (otherwise always guest)
  await FirebaseAuth.instance.signOut(); // Sign out any existing user, useful for resetting sessions

  runApp(
    ChangeNotifierProvider( // Provide SessionController to the app for state management
      create: (_) => SessionController(),
      child: const MyApp(), // Main app widget
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TourismApp', // App title
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Custom color scheme
        useMaterial3: true, // Use Material 3 for UI components
      ),
      home: const SplashScreen(), // Set SplashScreen as the initial screen
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title}); // Home page with a title
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Function to route the user based on their role
  Future<void> routeByRole(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser; // Get the current logged-in user

      // If the user is not logged in, navigate to the LoginPage
      if (user == null) {
        if (!context.mounted) return; // Check if the context is still valid
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()), // Navigate to login page
        );
        return;
      }

      // Fetch the user's role from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // ✅ After await, check if the context is mounted
      if (!context.mounted) return;

      // Get the user's role, default to 'user' if it's not available
      final role = (doc.data()?['role'] is String && (doc.data()?['role'] as String).isNotEmpty)
          ? doc.data()!['role'] as String
          : 'user';

      // Check if the user is an admin
      final isAdmin = role == 'admin';

      // Navigate to HomePage based on the user's role (admin or not)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(isAdmin: isAdmin)),
      );
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Firebase error')), // Show error message
      );
    } catch (e) {
      // Handle other exceptions
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')), // Show generic error message
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExploreMY', // App title
      theme: ThemeData(
        primarySwatch: Colors.red, // Primary color
        scaffoldBackgroundColor: Colors.white, // Background color
      ),
      home: const SplashScreen(), // Initial screen is SplashScreen
      debugShowCheckedModeBanner: false, // Disable debug banner
    );
  }
}
