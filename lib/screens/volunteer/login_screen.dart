import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteerLoginScreen extends StatefulWidget {
  const VolunteerLoginScreen({super.key});
  @override
  State<VolunteerLoginScreen> createState() => _VolunteerLoginScreenState();
}

class _VolunteerLoginScreenState extends State<VolunteerLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String _error = '';

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/volunteer/profile');
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'Login failed');
    }
    setState(() => _loading = false);
  }

  Future<void> _register() async {
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/volunteer/profile');
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'Registration failed');
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Volunteer Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            if (_error.isNotEmpty) Text(_error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (!_loading) ...[
              ElevatedButton(onPressed: _login, child: const Text('Login')),
              TextButton(onPressed: _register, child: const Text('Register')),
            ]
          ],
        ),
      ),
    );
  }
}