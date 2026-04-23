/*
auth gate - this will continously listen for auth state changes and redirect to the appropriate page (login or main page)
-------------------------------------------------------------------------------------------------------------------------

unauthenticated -> login page
authenticated -> main page
*/

import 'package:doctorlite/login_page.dart';
import 'package:doctorlite/main_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder:(context, snapshot) {
        //loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        //check if there is valid session currenty
        final session = snapshot.hasData ? snapshot.data!.session : null;
        if (session == null) {
          return const LoginPage();
        } else {
          return const MainPage();
        }
      },
      );
  }
}