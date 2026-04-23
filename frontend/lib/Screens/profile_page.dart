import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final supabase = Supabase.instance.client;

  String name = "None";
  String age = "None";
  String gender = "None";
  String email = "";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {

    final user = supabase.auth.currentUser;
    email = user?.email ?? "";

    final data = await supabase
        .from('user_profiles')
        .select()
        .eq('id', user!.id)
        .maybeSingle();

    if (data != null) {
      name = data['name'] ?? "None";
      age = data['age']?.toString() ?? "None";
      gender = data['gender'] ?? "None";
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> logout() async {

    await supabase.auth.signOut();

    Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false
    );
  }

  Widget profileTile(String title, String value) {

    return Container(

      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6)
        ],
      ),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue
            ),
          ),

          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),

        ],

      ),

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F8FF),

      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),

            const SizedBox(height: 30),

            profileTile("Name", name),
            profileTile("Age", age),
            profileTile("Gender", gender),
            profileTile("Email", email),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton.icon(

                icon: const Icon(Icons.edit),

                label: const Text("Edit Profile"),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),

                onPressed: () async {

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfilePage(),
                    ),
                  );

                  loadProfile();

                },

              ),

            )

          ],

        ),

      ),

    );

  }

}