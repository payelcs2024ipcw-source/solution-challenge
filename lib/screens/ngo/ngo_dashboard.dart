import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/weather_services.dart';
import '../../services/gemini_services.dart';

class NgoDashboard extends StatefulWidget {
  const NgoDashboard({super.key});

  @override
  State<NgoDashboard> createState() => _NgoDashboardState();
}

class _NgoDashboardState extends State<NgoDashboard> {
  String weatherPrediction = 'Loading prediction...';
  String geminiMatch = '';
  bool isMatching = false;

  @override
  void initState() {
    super.initState();
    loadWeatherPrediction();
  }

  Future<void> loadWeatherPrediction() async {
    final result = await WeatherService.getWeatherPrediction('Delhi');
    setState(() {
      weatherPrediction = result['prediction'];
    });
  }

  Future<void> matchVolunteers(Map<String, dynamic> need) async {
    setState(() => isMatching = true);

    print('Fetching volunteers...');

    List<Map<String, dynamic>> volunteers = [];

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('volunteers')
          .where('availability', isEqualTo: 'available')
          .get()
          .timeout(const Duration(seconds: 5));

      volunteers = snapshot.docs.map((d) => d.data()).toList();
      print('Volunteers from Firestore: ${volunteers.length}');
    } catch (e) {
      print('Firestore failed, using sample data: $e');
    }

    if (volunteers.isEmpty) {
      print('Using sample volunteers');
      volunteers = [
        {
          'name': 'Rahul Sharma',
          'skills': ['medical', 'first aid'],
          'location': 'North Delhi',
          'availability': 'available'
        },
        {
          'name': 'Priya Singh',
          'skills': ['teaching', 'education'],
          'location': 'South Delhi',
          'availability': 'available'
        },
        {
          'name': 'Amit Kumar',
          'skills': ['food distribution', 'shelter'],
          'location': 'East Delhi',
          'availability': 'available'
        },
      ];
    }

    print('Calling Gemini with ${volunteers.length} volunteers...');

    final match = await GeminiService.matchVolunteerToNeed(
      needDescription: need['description'] ?? '',
      needCategory: need['category'] ?? '',
      needLocation: need['location'] ?? '',
      volunteers: volunteers,
    );

    print('Gemini response: $match');

    if (mounted) {
      setState(() {
        geminiMatch = match;
        isMatching = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('AI Match Result'),
          content: SingleChildScrollView(child: Text(match)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NGO Dashboard'),
        backgroundColor: const Color(0xFF534AB7),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => Navigator.pushNamed(context, '/ngo-map'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEEEDFE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.wb_sunny, color: Color(0xFF534AB7)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    weatherPrediction,
                    style: const TextStyle(
                      color: Color(0xFF3C3489),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('community_needs')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final needs = snapshot.data!.docs;
                if (needs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No needs submitted yet.\nTap + to add one.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: needs.length,
                  itemBuilder: (context, index) {
                    final need =
                        needs[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: need['urgency'] == 'high'
                              ? Colors.red[100]
                              : need['urgency'] == 'medium'
                                  ? Colors.orange[100]
                                  : Colors.green[100],
                          child: Icon(
                            Icons.warning,
                            color: need['urgency'] == 'high'
                                ? Colors.red
                                : need['urgency'] == 'medium'
                                    ? Colors.orange
                                    : Colors.green,
                          ),
                        ),
                        title: Text(need['category'] ?? ''),
                        subtitle: Text(need['description'] ?? ''),
                        trailing: IconButton(
                          icon: isMatching
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : const Icon(
                                  Icons.auto_awesome,
                                  color: Color(0xFF534AB7),
                                ),
                          onPressed: () => matchVolunteers(need),
                          tooltip: 'AI Match Volunteer',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/submit-need'),
        backgroundColor: const Color(0xFF534AB7),
        label: const Text(
          'Submit Need',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}