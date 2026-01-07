import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourismapp/savedtripspage';
import '../controllers/session_controller.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  // Local state to handle the loading spinner
  bool _isSaving = false;

  // Logic: Saves the current session locally to SharedPreferences
  Future<void> _handleSave(
    BuildContext context,
    SessionController session,
  ) async {
    setState(() => _isSaving = true);

    try {
      // 1. Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // 2. Create a Map representing this specific trip/session
      final newTripData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'date': DateTime.now().toIso8601String(),
        'totalBudget': session.sessionTotal,
        'items': session.items.map((item) {
          return {
            'name': item.name,
            'adultQty': item.adultQty,
            'childQty': item.childQty,
            'total': item.total,
          };
        }).toList(),
      };

      // 3. Fetch existing history (if any)
      const String storageKey = 'savedtrips';
      final String? existingData = prefs.getString(storageKey);
      
      List<dynamic> history = [];
      if (existingData != null) {
        history = jsonDecode(existingData);
      }

      // 4. Append new trip to history and Save
      history.add(newTripData);
      await prefs.setString(storageKey, jsonEncode(history));

      // 5. Clear the current session UI since it is now saved
      session.clearSession();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Budget saved to History locally!'),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>();

    return Scaffold(
      // CSS STYLE: Matching Red Header
      appBar: AppBar(
        title: const Text(
          'Budget Summary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // --- NEW BUTTON: GO TO HISTORY ---
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'View History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SavedTripsPage()),
              );
            },
          ),
          // ---------------------------------
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            // Disable delete if saving or empty
            onPressed: (session.items.isEmpty || _isSaving)
                ? null
                : session.clearSession,
          ),
        ],
      ),
      body: Container(
        // CSS STYLE: Red Gradient Background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade400, Colors.red.shade700],
          ),
        ),
        child: session.items.isEmpty
            ? _buildEmptyState()
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: session.items.length,
                      itemBuilder: (_, i) => _buildItemCard(session, i),
                    ),
                  ),
                  _buildSummarySection(context, session),
                ],
              ),
      ),
    );
  }

  // SIMPLE PATTERN: Item Card UI
  Widget _buildItemCard(SessionController session, int index) {
    final item = session.items[index];
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade100,
          child: const Icon(Icons.location_on, color: Colors.red),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Adult x${item.adultQty} • Kids x${item.childQty}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'RM ${item.total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 16,
              ),
            ),
            const Text(
              'Long press to remove',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        // Disable interaction if currently saving
        onLongPress: _isSaving ? null : () => session.removeAt(index),
      ),
    );
  }

  // SIMPLE PATTERN: Bottom Summary Panel with Loading State
  Widget _buildSummarySection(BuildContext context, SessionController session) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL BUDGET',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                'RM ${session.sessionTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : () => _handleSave(context, session),
              // Swap Icon for Spinner if saving
              icon: _isSaving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.save_alt), 
              label: Text(
                _isSaving ? 'SAVING...' : 'SAVE TO HISTORY',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.white54),
          SizedBox(height: 16),
          Text(
            'Your budget is empty',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}