import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'search_parking_page.dart';
import 'my_bookings_page.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Park Smart"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Welcome text
            const Text(
              "Welcome 👋",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Choose an option below to continue:",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            // Search Parking card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                leading: const Icon(Icons.local_parking,
                    size: 40, color: Colors.blueAccent),
                title: const Text(
                  "Search Parking",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Find and book a nearby parking spot."),
                onTap: () => Get.to(() => const SearchParkingPage()),
              ),
            ),
            const SizedBox(height: 20),

            // My Bookings card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                leading: const Icon(Icons.qr_code,
                    size: 40, color: Colors.green),
                title: const Text(
                  "My Bookings",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle:
                    const Text("View your active bookings and QR codes."),
                onTap: () => Get.to(() => const MyBookingsPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
