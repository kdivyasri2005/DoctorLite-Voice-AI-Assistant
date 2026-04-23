import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/api_service.dart';
import 'output_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {

  final TextEditingController textController = TextEditingController();
  final SpeechToText _speech = SpeechToText();
  final supabase = Supabase.instance.client;

  bool isListening = false;
  bool isLoading = false;
  String userText = "";

  late AnimationController waveController;

  @override
  void initState() {
    super.initState();

    waveController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    waveController.dispose();
    super.dispose();
  }

  Future<void> startListening() async {
    bool available = await _speech.initialize();

    if (available) {
      setState(() => isListening = true);

      _speech.listen(
        localeId: "en_US",
        onResult: (result) {
          setState(() {
            userText = result.recognizedWords;
            textController.text = userText;
          });
        },
      );
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
    setState(() => isListening = false);
  }

  Future<void> getPrediction() async {
    if (userText.isEmpty) return;

    setState(() => isLoading = true);

    final result = await ApiService.predictDisease(userText);

    String disease = result["predicted_disease"];
    String severity = result["severity"];
    String advice = result["advice"];

    await supabase.from('prediction_history').insert({
      'user_id': supabase.auth.currentUser!.id,
      'input_text': userText,
      'predicted_disease': disease,
    });

    setState(() => isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OutputPage(
          disease: disease,
          severity: severity,
          advice: advice,
        ),
      ),
    );
  }

  Widget voiceWave() {
    return AnimatedBuilder(
      animation: waveController,
      builder: (context, child) {
        return Container(
          height: 120 + waveController.value * 20,
          width: 120 + waveController.value * 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(0.2),
          ),
          child: child,
        );
      },
      child: Container(
        height: 100,
        width: 100,
        decoration:
            const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
        child: const Icon(Icons.mic, color: Colors.white, size: 50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Text(
                "DoctorLite",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),

              const SizedBox(height: 40),

              GestureDetector(
                onTap: () {
                  isListening ? stopListening() : startListening();
                },
                child: isListening
                    ? voiceWave()
                    : Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                            color: Colors.blue, shape: BoxShape.circle),
                        child: const Icon(Icons.mic_none,
                            color: Colors.white, size: 50),
                      ),
              ),

              const SizedBox(height: 10),

              Text(isListening ? "Listening..." : "Tap to Speak Symptoms"),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: textController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      hintText: "Type symptoms here...",
                      border: InputBorder.none),
                ),
              ),

              const SizedBox(height: 30),

              isLoading
                  ? Column(
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("AI is analyzing symptoms...")
                      ],
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: getPrediction,
                      child: const Text("Predict Disease"),
                    )
            ],
          ),
        ),
      ),
    );
  }
}