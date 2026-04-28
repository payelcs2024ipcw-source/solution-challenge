import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  Future<String> _getAIExplanation(Map<String, dynamic> task) async {
    final apiKey = 'AIzaSyAg-AsiX2VFurZAkhF_W5jp8VLVrC_UXSU';
    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text': '''A volunteer has been matched to this community task:
Title: ${task['category']}
Category: ${task['category']}
Urgency: ${task['urgency']}
Description: ${task['description']}
Location: ${task['location']}

In 2-3 sentences, explain to the volunteer why this task matters and what they should bring or prepare.'''
              }
            ]
          }
        ]
      }),
    );
    final data = jsonDecode(response.body);
    return data['candidates'][0]['content']['parts'][0]['text'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matched Tasks')),
      floatingActionButton: FloatingActionButton.extended(
      onPressed: () => Navigator.pushNamed(context, '/volunteer/map'),
      icon: const Icon(Icons.map),
      label: const Text('View Map'),
      backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('community_needs').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No tasks yet. Check back soon!'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['category'] ?? 'Community Need'),
                subtitle: Text('${data['description'] ?? ''} • ${data['urgency'] ?? ''} urgency'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  final explanation = await _getAIExplanation(data);
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['title'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('📍 ${data['location']}  •  🔴 ${data['urgency']} urgency'),
                          const SizedBox(height: 12),
                          Text(explanation),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/volunteer/chatbot'),
                            child: const Text('Ask AI Assistant'),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

