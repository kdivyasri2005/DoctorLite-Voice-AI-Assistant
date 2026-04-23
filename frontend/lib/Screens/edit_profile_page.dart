import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final supabase = Supabase.instance.client;

  final nameController = TextEditingController();
  final ageController = TextEditingController();

  String gender = "Male";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {

    final user = supabase.auth.currentUser;

    final data = await supabase
        .from('user_profiles')
        .select()
        .eq('id', user!.id)
        .maybeSingle();

    if (data != null) {
      nameController.text = data['name'] ?? "";
      ageController.text = data['age']?.toString() ?? "";
      gender = data['gender'] ?? "Male";
    }

    setState(() {});
  }

  Future<void> saveProfile() async {

    final user = supabase.auth.currentUser;

    await supabase.from('user_profiles').upsert({

      'id': user!.id,
      'name': nameController.text,
      'age': int.tryParse(ageController.text),
      'gender': gender,

    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile Updated Successfully"),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Age"),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField(

              value: gender,

              items: const [
                DropdownMenuItem(value: "Male", child: Text("Male")),
                DropdownMenuItem(value: "Female", child: Text("Female")),
                DropdownMenuItem(value: "Other", child: Text("Other")),
              ],

              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },

              decoration: const InputDecoration(labelText: "Gender"),

            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: saveProfile,

                child: const Text("Save Profile"),

              ),

            )

          ],

        ),

      ),

    );

  }

}