import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/parking_model.dart';

class NavigationPage extends StatelessWidget {
  final String bookingId;
  final ParkingModel parking;

  const NavigationPage({super.key, required this.bookingId, required this.parking});

  // 🔗 Open Google Maps with location text
  Future<void> _openInGoogleMaps(String location) async {
    final query = Uri.encodeComponent(location);
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Navigation & QR Code"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🅿️ Parking Info Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      parking.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, color: Colors.redAccent),
                        const SizedBox(width: 6),
                        Text(parking.location,
                            style: const TextStyle(fontSize: 16, color: Colors.black54)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text("Price: \$${parking.price} / hr",
                        style: const TextStyle(fontSize: 16, color: Colors.green)),
                  ],
                ),
              ),
            ),

            // 🔳 QR Code
            QrImageView(
              data: bookingId,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 10),
            const Text(
              "📌 Scan this QR at the gate",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 30),

            // 📍 Open in Maps button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.map, color: Colors.white),
                label: const Text("Open in Google Maps"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _openInGoogleMaps(parking.location),
              ),
            )
          ],
        ),
      ),
    );
  }
}
