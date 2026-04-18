import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteerProfileScreen extends StatefulWidget {
  const VolunteerProfileScreen({super.key});
  @override
  State<VolunteerProfileScreen> createState() => _VolunteerProfileScreenState();
}

class _VolunteerProfileScreenState extends State<VolunteerProfileScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final List<String> _allSkills = ['Medical', 'Logistics', 'Teaching', 'Cooking', 'IT'];
  List<String> _selectedSkills = [];
  bool _saving = false;

  Future<void> _saveProfile() async {
    setState(() => _saving = true);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('volunteers').doc(uid).set({
      'id': uid,
      'name': _nameController.text.trim(),
      'location': _locationController.text.trim(),
      'skills': _selectedSkills,
      'isAvailable': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    setState(() => _saving = false);
    Navigator.pushReplacementNamed(context, '/volunteer/tasks');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name')),
            TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'Your Location')),
            const SizedBox(height: 16),
            const Text('Skills:', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              children: _allSkills.map((skill) => FilterChip(
                label: Text(skill),
                selected: _selectedSkills.contains(skill),
                onSelected: (val) => setState(() =>
                  val ? _selectedSkills.add(skill) : _selectedSkills.remove(skill)),
              )).toList(),
            ),
            const SizedBox(height: 24),
            _saving
              ? const CircularProgressIndicator()
              : ElevatedButton(onPressed: _saveProfile, child: const Text('Save & Continue')),
          ],
        ),
      ),
    );
  }
}