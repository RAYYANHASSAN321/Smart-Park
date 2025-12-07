import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/parking_controller.dart';
import '../../models/parking_model.dart';

class ManageParkingPage extends StatefulWidget {
  final ParkingModel? parking; // null => Add, not null => Edit

  const ManageParkingPage({super.key, this.parking});

  @override
  State<ManageParkingPage> createState() => _ManageParkingPageState();
}

class _ManageParkingPageState extends State<ManageParkingPage> {
  final nameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final slotsCtrl = TextEditingController();
  final priceCtrl = TextEditingController();

  final parkingCtrl = Get.find<ParkingController>();

  @override
  void initState() {
    super.initState();
    if (widget.parking != null) {
      nameCtrl.text = widget.parking!.name;
      locationCtrl.text = widget.parking!.location;
      slotsCtrl.text = widget.parking!.availableSlots.toString();
      priceCtrl.text = widget.parking!.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.parking != null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(isEdit ? "Edit Parking" : "Add Parking"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildInputField(controller: nameCtrl, label: "Parking Name", icon: Icons.local_parking),
                const SizedBox(height: 15),
                _buildInputField(controller: locationCtrl, label: "Location", icon: Icons.location_on),
                const SizedBox(height: 15),
                _buildInputField(controller: slotsCtrl, label: "Available Slots", icon: Icons.event_seat, isNumber: true),
                const SizedBox(height: 15),
                _buildInputField(controller: priceCtrl, label: "Price per hour", icon: Icons.attach_money, isNumber: true),
                const SizedBox(height: 25),
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
                    onPressed: () {
                      if (isEdit) {
                        parkingCtrl.updateParking(
                          ParkingModel(
                            id: widget.parking!.id,
                            name: nameCtrl.text,
                            location: locationCtrl.text,
                            availableSlots: int.tryParse(slotsCtrl.text) ?? 0,
                            price: double.tryParse(priceCtrl.text) ?? 0,
                          ),
                        );
                      } else {
                        parkingCtrl.addParking(
                          nameCtrl.text,
                          locationCtrl.text,
                          int.tryParse(slotsCtrl.text) ?? 0,
                          double.tryParse(priceCtrl.text) ?? 0,
                        );
                      }
                      Get.back();
                    },
                    child: Text(
                      isEdit ? "Update Parking" : "Add Parking",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable input field widget
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.8),
        ),
      ),
    );
  }
}
