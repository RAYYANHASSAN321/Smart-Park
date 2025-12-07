import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../controllers/auth_controller.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final uid = auth.user!.uid;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Bookings"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("bookings")
            .where("userId", isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No bookings found 😕",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, i) {
              final data = bookings[i].data() as Map<String, dynamic>;
              final bookingId = bookings[i].id;
              final status = data['status'] ?? "Booked";

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🅿️ Parking ID
                      Row(
                        children: [
                          const Icon(Icons.local_parking,
                              color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Text("Parking ID: ${data['parkingId']}",
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // 📅 Time
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: Colors.orangeAccent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text("Time: ${data['time']}",
                                style: const TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // ✅/❌ Status Badge
                      Row(
                        children: [
                          const Icon(Icons.info, color: Colors.grey),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: status == "Booked"
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: status == "Booked"
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 🔳 QR Code
                      Center(
                        child: QrImageView(
                          data: bookingId,
                          version: QrVersions.auto,
                          size: 140,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ❌ Cancel Button
                      if (status == "Booked")
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.cancel, color: Colors.white),
                            label: const Text("Cancel Booking"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("bookings")
                                  .doc(bookingId)
                                  .update({"status": "Cancelled"});

                              Get.snackbar(
                                "Booking Cancelled",
                                "Your booking has been cancelled successfully",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red.shade100,
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
