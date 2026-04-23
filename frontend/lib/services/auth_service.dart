import 'package:doctorlite/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  final supabase = Supabase.instance.client;

  // =========================
  // SIGN UP
  // =========================
  Future<String?> signUp(String email, String password) async {
    try {

      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return null; // success
      } else {
        return "Signup failed";
      }

    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Error: $e";
    }
  }

  // =========================
  // LOGIN
  // =========================
  Future<String?> login(String email, String password) async {
    try {

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return null; // success
      }

      return "Invalid email or password";

    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Error: $e";
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout(BuildContext context) async {
    try {

      await supabase.auth.signOut();

      if (!context.mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );

    } catch (e) {
      print("Error logging out: $e");
    }
  }

  // =========================
  // GET CURRENT USER
  // =========================
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  // =========================
  // GET CURRENT USER EMAIL
  // =========================
  String? getCurrentUserEmail() {
    final user = supabase.auth.currentUser;
    return user?.email;
  }

}