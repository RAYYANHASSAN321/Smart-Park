class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role; // "admin" or "user"
  final String vehicle;
  final String phone;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.vehicle,
    required this.phone,
  });

  // convert to map (Firestore me store karne ke liye)
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "role": role,
      "vehicle": vehicle,
      "phone": phone,
    };
  }

  // Firestore se data lene ke liye
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"] ?? "",
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      role: map["role"] ?? "user",
      vehicle: map["vehicle"] ?? "",
      phone: map["phone"] ?? "",
    );
  }
}
