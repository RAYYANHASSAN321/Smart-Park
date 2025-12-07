import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminBookingAnalyticsPage extends StatelessWidget {
  const AdminBookingAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingsRef = FirebaseFirestore.instance.collection("bookings");

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Booking Analytics"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: bookingsRef.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          final total = docs.length;

          // Count by status
          final active = docs.where((d) => d['status'] == "Booked").length;
          final cancelled = docs.where((d) => d['status'] == "Cancelled").length;

          // Most booked parking
          Map<String, int> parkingCount = {};
          for (var d in docs) {
            final pid = d['parkingId'];
            parkingCount[pid] = (parkingCount[pid] ?? 0) + 1;
          }

          String mostBooked = "N/A";
          int maxCount = 0;
          parkingCount.forEach((key, value) {
            if (value > maxCount) {
              mostBooked = key;
              maxCount = value;
            }
          });

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatCard("📊 Total Bookings", "$total", Colors.blue),
                _buildStatCard("✅ Active Bookings", "$active", Colors.green),
                _buildStatCard("❌ Cancelled Bookings", "$cancelled", Colors.red),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(Icons.local_parking,
                            size: 40, color: Colors.orange),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Most Booked Parking Lot:\n$mostBooked ($maxCount times)",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Custom card widget for stats
  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Text(
            value,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: color),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
