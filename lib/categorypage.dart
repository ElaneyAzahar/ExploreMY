import 'package:flutter/material.dart';
import 'package:tourismapp/foodlistpage.dart';
import 'package:tourismapp/placelistpage.dart';

class CategoryPage extends StatelessWidget {
  final String stateId;
  final String stateName;
  final bool isAdmin;

  const CategoryPage({
    super.key,
    required this.stateId,
    required this.stateName,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(stateName),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select A Category',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Text(
              'Which one would you like to explore?',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Historical Places Category
            _buildCategoryCard(
              context,
              title: 'Historical Places',
              subtitle: 'Discover heritage sites',
              icon: Icons.account_balance,
              color: Colors.blue.shade700,
              destination: PlaceListPage2(
                stateId: stateId,
                stateName: stateName,
                isAdmin: isAdmin,
              ),
            ),

            const SizedBox(height: 16),

            // Traditional Food Category
            _buildCategoryCard(
              context,
              title: 'Traditional Food',
              subtitle: 'Taste local cuisine',
              icon: Icons.restaurant,
              color: Colors.orange.shade800,
              destination: FoodListPage(
                isAdmin: isAdmin,
                stateId: stateId,
                stateName: stateName,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // REUSABLE UI PATTERN
  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget destination,
  }) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => destination)),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(20),
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
            // Icon Container with soft background color
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 20),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
            // Decorative Arrow
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}