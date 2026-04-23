import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  final supabase = Supabase.instance.client;
  List historyList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future fetchHistory() async {

    final data = await supabase
        .from('prediction_history')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('created_at', ascending: false);

    setState(() {
      historyList = data;
      loading = false;
    });

  }

  Widget historyCard(Map item) {

    return Container(

      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(children: const [
            Icon(Icons.medical_services, color: Colors.blue),
            SizedBox(width: 8),
            Text("Predicted Disease",
                style: TextStyle(fontWeight: FontWeight.bold))
          ]),

          const SizedBox(height: 6),

          Text(item['predicted_disease'] ?? "",
              style: const TextStyle(fontSize: 18)),

          const Divider(),

          Row(children: const [
            Icon(Icons.notes, color: Colors.green),
            SizedBox(width: 8),
            Text("Symptoms",
                style: TextStyle(fontWeight: FontWeight.bold))
          ]),

          const SizedBox(height: 6),

          Text(item['input_text'] ?? ""),

          const SizedBox(height: 8),

          Text(
            item['created_at'].toString(),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: const Text("Prediction History")),

      backgroundColor: const Color(0xFFF4F8FF),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : historyList.isEmpty
              ? const Center(child: Text("No prediction history"))
              : ListView.builder(
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    return historyCard(historyList[index]);
                  },
                ),
    );
  }
}