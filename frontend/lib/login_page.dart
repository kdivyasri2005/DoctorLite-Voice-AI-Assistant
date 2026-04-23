import 'package:doctorlite/Widgets/snack_bar.dart';
import 'package:doctorlite/main_page.dart';
import 'package:doctorlite/services/auth_service.dart';
import 'package:doctorlite/signup_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final AuthService authService = AuthService();

  bool isLoading = false;

  void login() async {

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (!email.contains('@') || !email.contains('.com')) {
      showSnackBar(context, "Please enter a valid email");
      return;
    }

    if (password.length < 6) {
      showSnackBar(context, "Password must be at least 6 characters");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await authService.login(email, password);

    setState(() {
      isLoading = false;
    });

    if (result == null) {

      showSnackBar(context, "Login successful");

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      }

    } else {

      showSnackBar(context, "Login failed: $result");

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F8FF),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.symmetric(horizontal: 28),

            child: Column(

              children: [

                const SizedBox(height: 40),

                // Logo + Title
                Row(

                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    Image.asset(
                      "assets/images/logo.png",
                      height: 50,
                    ),

                    const SizedBox(width: 10),

                    const Text(
                      "DoctorLite",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    )

                  ],

                ),

                const SizedBox(height: 30),

                Image.asset(
                  "assets/images/sign_in.png",
                  height: 200,
                ),

                const SizedBox(height: 35),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: 170,
                        height: 42,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: login,
                          child: const Text(
                            "Sign In",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                const SizedBox(height: 25),

                Row(

                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    const Text("Don't have an account? "),

                    GestureDetector(

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupPage(),
                          ),
                        );
                      },

                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    )

                  ],

                ),

                const SizedBox(height: 40),

              ],

            ),

          ),

        ),

      ),

    );

  }

}