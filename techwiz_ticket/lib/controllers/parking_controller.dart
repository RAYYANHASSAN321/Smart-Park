import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_model.dart';

class ParkingController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // add parking
  Future<void> addParking(String name, String location, int slots, double price) async {
    final doc = _db.collection("parking").doc();
    final parking = ParkingModel(
      id: doc.id,
      name: name,
      location: location,
      availableSlots: slots,
      price: price,
    );
    await doc.set(parking.toMap());
  }

  // update parking
  Future<void> updateParking(ParkingModel parking) async {
    await _db.collection("parking").doc(parking.id).update(parking.toMap());
  }

  // delete parking
  Future<void> deleteParking(String id) async {
    await _db.collection("parking").doc(id).delete();
  }

  // stream for real-time list
  Stream<List<ParkingModel>> getParkings() {
    return _db.collection("parking").snapshots().map(
      (snap) => snap.docs.map((doc) => ParkingModel.fromMap(doc.data())).toList(),
    );
  }
}
