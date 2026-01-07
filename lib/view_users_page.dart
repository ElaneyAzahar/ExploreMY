import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewUsersPage extends StatelessWidget {
  const ViewUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // CSS STYLE: Soft background
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Registered Users',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      // STREAMBUILDER: Listens to the 'users' collection in real-time
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          // 1. Handle Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }

          // 2. Handle Error State
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // 3. Handle Empty Data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          // 4. Get the data
          final users = snapshot.data!.docs;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section (Dynamic Count)
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.red,
                width: double.infinity,
                child: Text(
                  'Total Users: ${users.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              // Users List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    // Extract data from the document
                    var userData = users[index].data() as Map<String, dynamic>;
                    
                    // distinct fields (safely handling nulls)
                    String email = userData['email'] ?? 'No Email';
                    // You can add more fields here like userData['name']

                    return _buildUserCard(context, email);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // SIMPLE PATTERN: Reusable User Card with "CSS" Styling
  Widget _buildUserCard(BuildContext context, String email) {
    return InkWell(
      onTap: () {
        // Add navigation logic here if needed
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Selected: $email"))
        );
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            // User Avatar Icon
            CircleAvatar(
              backgroundColor: Colors.red.withOpacity(0.1),
              child: const Icon(Icons.person, color: Colors.red),
            ),
            const SizedBox(width: 16),

            // Email Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    'Tap to view details',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Trailing Icon
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}