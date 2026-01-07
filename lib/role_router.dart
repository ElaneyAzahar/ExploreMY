import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourismapp/admin_dashboard_page.dart';
import 'package:tourismapp/homepage.dart';
import 'package:tourismapp/loginpage.dart';

class RoleRouter extends StatelessWidget {
  const RoleRouter({super.key});

  Stream<String> _roleStream(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return 'user';
          final role = doc.data()?['role'];
          if (role is String && role.isNotEmpty) return role;
          return 'user';
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = authSnap.data;
        if (user == null) {
          return const GuestPage();
        }

        return StreamBuilder<String>(
          stream: _roleStream(user.uid),
          builder: (context, roleSnap) {
            if (roleSnap.hasError) {
              // optional: you can show an error UI, but safest fallback is user
              return HomePage(isAdmin: false);
            }

            if (roleSnap.connectionState == ConnectionState.waiting ||
                !roleSnap.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

           final role = roleSnap.data!; // safe now
            final isAdmin = role == 'admin';

            // Route to Admin Dashboard if the user is an admin, otherwise HomePage
            if (isAdmin) {
              return const AdminDashboardPage(); // Admin Dashboard Page for admins
            }

            return HomePage(isAdmin: false); // HomePage for regular user
       },
        );
      },
    );
  }
}