class ParkingModel {
  final String id;
  final String name;
  final String location;
  final int availableSlots;
  final double price;

  ParkingModel({
    required this.id,
    required this.name,
    required this.location,
    required this.availableSlots,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "location": location,
      "availableSlots": availableSlots,
      "price": price,
    };
  }

  factory ParkingModel.fromMap(Map<String, dynamic> map) {
    return ParkingModel(
      id: map["id"],
      name: map["name"],
      location: map["location"],
      availableSlots: map["availableSlots"],
      price: (map["price"] as num).toDouble(),
    );
  }
}
