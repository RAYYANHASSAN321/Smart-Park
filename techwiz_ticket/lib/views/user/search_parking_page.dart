import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bookpage.dart';
import '../../controllers/parking_controller.dart';
import '../../models/parking_model.dart';

class SearchParkingPage extends StatelessWidget {
  const SearchParkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final parkingCtrl = Get.put(ParkingController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Search Parking"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<List<ParkingModel>>(
        stream: parkingCtrl.getParkings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snapshot.data!;
          if (list.isEmpty) {
            return const Center(
              child: Text("🚫 No parking spots available",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (c, i) {
              final p = list[i];
              final hasSlots = p.availableSlots > 0;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Parking Name
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Location
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.redAccent),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              p.location,
                              style: const TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Slots & Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Slots: ${p.availableSlots}",
                            style: TextStyle(
                              fontSize: 16,
                              color: hasSlots ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "\$${p.price}/hr",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Book Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.local_parking, color: Colors.white),
                          label: const Text("Book Now"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasSlots ? Colors.blueAccent : Colors.grey,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: hasSlots
                              ? () => Get.to(() => BookPage(parking: p))
                              : null,
                        ),
                      )
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
