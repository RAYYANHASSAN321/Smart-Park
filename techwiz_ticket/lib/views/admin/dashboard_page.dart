import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techwiz_ticket/views/admin/manage_parking_page.dart';
import 'package:techwiz_ticket/views/admin/admin_booking_analytics.dart';
import '../../controllers/parking_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/parking_model.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final parkingCtrl = Get.put(ParkingController());
    final authCtrl = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics, color: Colors.white),
            tooltip: "View Analytics",
            onPressed: () => Get.to(() => const AdminBookingAnalyticsPage()),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
            onPressed: () => authCtrl.logout(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const ManageParkingPage()),
        label: const Text("Add Parking"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<List<ParkingModel>>(
        stream: parkingCtrl.getParkings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "🚗 No Parking Lots Added Yet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final list = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final p = list[i];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    child: const Icon(Icons.local_parking, color: Colors.blue),
                  ),
                  title: Text(
                    p.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    "${p.location}\nSlots: ${p.availableSlots} | Price: \$${p.price}",
                    style: TextStyle(color: Colors.grey[700], height: 1.4),
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            Get.to(() => ManageParkingPage(parking: p)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => parkingCtrl.deleteParking(p.id),
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
