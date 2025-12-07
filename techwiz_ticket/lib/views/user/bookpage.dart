import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controllers/auth_controller.dart';
import '../../models/parking_model.dart';
import 'navigation_page.dart';

class BookPage extends StatelessWidget {
  final ParkingModel parking;
  const BookPage({super.key, required this.parking});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final uid = auth.user!.uid;
    final db = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Booking Details"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🅿️ Parking Name
                Text(
                  parking.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8),

                // 📍 Location
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.redAccent),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        parking.location,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 💰 Price
                Row(
                  children: [
                    const Icon(Icons.attach_money, color: Colors.green),
                    const SizedBox(width: 6),
                    Text(
                      "${parking.price} / hour",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 🚗 Slots
                Row(
                  children: [
                    const Icon(Icons.local_parking, color: Colors.blueGrey),
                    const SizedBox(width: 6),
                    Text(
                      "Available Slots: ${parking.availableSlots}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // ✅ Confirm Booking Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final bookingRef = db.collection("bookings").doc();
                      await bookingRef.set({
                        "id": bookingRef.id,
                        "userId": uid,
                        "parkingId": parking.id,
                        "time": DateTime.now().toIso8601String(),
                        "status": "Booked"
                      });

                      // Go to QR + Navigation page
                      Get.to(() => NavigationPage(
                            bookingId: bookingRef.id,
                            parking: parking,
                          ));
                    },
                    child: const Text(
                      "Confirm Booking",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
