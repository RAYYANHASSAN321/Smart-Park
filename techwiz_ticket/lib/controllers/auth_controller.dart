import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:techwiz_ticket/models/user_model.dart';
import 'package:techwiz_ticket/views/admin/dashboard_page.dart';
import 'package:techwiz_ticket/views/auth/login_page.dart';
import 'package:techwiz_ticket/views/user/home_page.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? get user => _auth.currentUser;

  // Signup
  Future<void> signup(String name, String email, String password, String role, String vehicle, {String phone = ""}) async {
    try {
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        Get.snackbar("Error", "All fields are required!",
            backgroundColor: Colors.red.shade100,
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      if (password.length < 6) {
        Get.snackbar("Weak Password", "Password must be at least 6 characters",
            backgroundColor: Colors.orange.shade100,
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final newUser = UserModel(
        uid: cred.user!.uid,
        name: name,
        email: email,
        role: role,
        vehicle: vehicle,
        phone: phone,
      );

      await _db.collection("users").doc(newUser.uid).set(newUser.toMap());
      _redirectUser(newUser.role);
    } on FirebaseAuthException catch (e) {
      String message = "Signup failed";
      if (e.code == "email-already-in-use") {
        message = "This email is already registered";
      } else if (e.code == "invalid-email") {
        message = "Invalid email format";
      } else if (e.code == "weak-password") {
        message = "Password is too weak";
      }
      Get.snackbar("Error", message,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        Get.snackbar("Error", "Email and password are required",
            backgroundColor: Colors.red.shade100,
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final doc = await _db.collection("users").doc(cred.user!.uid).get();
      final userModel = UserModel.fromMap(doc.data()!);

      _redirectUser(userModel.role);
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";
      if (e.code == "user-not-found") {
        message = "No user found with this email";
      } else if (e.code == "wrong-password") {
        message = "Incorrect password";
      } else if (e.code == "invalid-email") {
        message = "Invalid email address";
      }
      Get.snackbar("Error", message,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Role-based redirect
  void _redirectUser(String role) {
    if (role == "admin") {
      Get.offAll(() => const AdminDashboard());
    } else {
      Get.offAll(() => const UserHomePage());
    }
  }

  // Logout
  void logout() async {
    await _auth.signOut();
    Get.offAll(() => LoginPage());
  }
}
