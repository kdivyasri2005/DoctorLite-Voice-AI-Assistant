import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class OutputPage extends StatefulWidget {
  final String disease;
  final String severity;
  final String advice;

  const OutputPage({
    super.key,
    required this.disease,
    required this.severity,
    required this.advice,
  });

  @override
  State<OutputPage> createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {

  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    speakResult();
  }

  Future speakResult() async {

    String text =
        "Hello. I am your AI Doctor. "
        "The predicted disease is ${widget.disease}. "
        "Severity level is ${widget.severity}. "
        "My advice is ${widget.advice}.";

    await tts.setLanguage("en-US");
    await tts.setSpeechRate(0.45);
    await tts.speak(text);
  }

  // ===============================
  // RESULT CARD
  // ===============================

  Widget resultCard(String title, String value, IconData icon, Color color) {

    return Container(

      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8)
        ],
      ),

      child: Row(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              ],

            ),
          )

        ],

      ),

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F8FF),

      appBar: AppBar(
        title: const Text("AI Diagnosis Result"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height: 10),

            // ===============================
            // AI DOCTOR AVATAR
            // ===============================

            Container(

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ],
              ),

              child: Column(

                children: [

                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.medical_services,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "AI Doctor",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Tap the button to hear diagnosis",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 12),

                  ElevatedButton.icon(

                    onPressed: speakResult,

                    icon: const Icon(Icons.volume_up),

                    label: const Text("Speak Result"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),

                  ),

                ],

              ),

            ),

            const SizedBox(height: 30),

            // ===============================
            // RESULTS
            // ===============================

            resultCard(
              "Predicted Disease",
              widget.disease,
              Icons.coronavirus,
              Colors.red,
            ),

            resultCard(
              "Severity Level",
              widget.severity,
              Icons.warning,
              Colors.orange,
            ),

            resultCard(
              "Medical Advice",
              widget.advice,
              Icons.medical_information,
              Colors.green,
            ),

          ],

        ),

      ),

    );

  }

}